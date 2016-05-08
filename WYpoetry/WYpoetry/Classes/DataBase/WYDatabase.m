//
//  WYDatabase.m
//  WYpoetry
//
//  Created by sialice on 16/5/7.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYDatabase.h"
#import "NSObject+WYDatabase.h"
#import <sqlite3.h>
#import <objc/runtime.h>

@interface WYDatabase ()
{
    sqlite3 *_database;
}
/** 表名 一个表对应一个类 */
@property (nonatomic, strong) NSMutableArray *tableNameArrM;

/** 表字段 一个表名对应一个key  value为 字段及字段类型字典 的数组*/
@property (nonatomic, strong) NSMutableDictionary *tableFiledDictM;

/** 表字段数组 对应一个类的属性 */

@end

@implementation WYDatabase

#pragma mark - 数据库单例

static WYDatabase *_instance;

+ (instancetype)allocWithZone:(struct _NSZone *)zone {
    if (_instance == nil) { // 不存在则创建
        // 1.首先获取iPhone上sqlite3的数据库文件的地址
        NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
        NSString *documentsDirectory = [paths firstObject];
        NSString *path = [documentsDirectory stringByAppendingPathComponent:@"database.sqlite"];
        
        // 2.打开iPhone上的sqlite3的数据库文件
        sqlite3 *database;
        int isOpen = sqlite3_open([path UTF8String], &database); // 无则创建
        if (isOpen == SQLITE_OK) {
            // 连接成功
            // 3.创建类
            static dispatch_once_t onceToken;
            dispatch_once(&onceToken, ^{
                _instance = [super allocWithZone:zone];
                // 记录数据库
                _instance->_database = database;
            });
            return _instance;
        }else {
            // 创建失败
            NSAssert(NO, @"数据库连接失败，无法获取实例！");
            _instance = nil;
        }
        
    }
    return _instance;
}

+ (instancetype)alloc { // 不给使用者调用alloc方法
    // 1.创建异常
    NSException *exc = [NSException exceptionWithName:@"NSInternalInconsistencyException" reason:@"There can only be one WYSingle instance." userInfo:nil];
    // 2.抛出异常
    [exc raise];
    
    return nil;
}

- (id)copyWithZone:(NSZone *)zone {
    return _instance;
}
- (id)mutableCopyWithZone:(NSZone *)zone {
    return _instance;
}

#if __has_feature(objc_arc)
#else
- (instancetype)retain {
    return _instance;
}

- (oneway void)release {
    
}

- (NSUInteger)retainCount {
    return MAXFLOAT;
}

#endif

/** 连接数据库（无则创建）并获取数据库 */
+ (instancetype)shareDatabase {
    NSZone *zone;
    return [[self allocWithZone:zone] init];
}

#pragma mark - 懒加载
- (NSMutableArray *)tableNameArrM {
    if (!_tableNameArrM) {
        _tableNameArrM = [NSMutableArray array];
        // 获取数据库表
        sqlite3_stmt *statement;
        const char *getTableInfo = "select * from sqlite_master where type='table' order by name";
        sqlite3_prepare_v2(_database, getTableInfo, -1, &statement, nil);
        while (sqlite3_step(statement) == SQLITE_ROW) {
            char *nameData = (char *)sqlite3_column_text(statement, 1);
            NSString *tableName = [[NSString alloc] initWithUTF8String:nameData];
            [_tableNameArrM addObject:tableName];
//            NSLog(@"name:%@",tableName);
        }
    }
    return _tableNameArrM;
}

- (NSMutableDictionary *)tableFiledDictM {
    if (!_tableFiledDictM) {
        _tableFiledDictM = [NSMutableDictionary dictionary];
    }
    return _tableFiledDictM;
}

#pragma mark - 数据库方法

/** 注册对象 */
- (void)registeTableWithClass:(Class)objcClass {
    unsigned int count = 0;
    // 1.根据类名记录表名 表字典中的key
    NSString *tableName = NSStringFromClass(objcClass);
    if ([self isExistTableWithName:tableName]) return; // 存在了则不创建
    [self.tableNameArrM addObject:tableName];
    
    // 2.表字典中的value: 数组（存储属性名及类型字典）
    NSMutableArray *filedArrM = [NSMutableArray array];
    
    // 3.拼接sql语句
    NSMutableString *filedSql = [NSMutableString string];
    objc_property_t *propertyList = class_copyPropertyList(objcClass, &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        // 2.1.获取类型
        NSString *filedType = [NSString stringWithUTF8String:property_getAttributes(property)];
        filedType = [[filedType componentsSeparatedByString:@","] firstObject];
        filedType = [filedType substringFromIndex:1];
        filedType = [self convertToSQLType:filedType];
        
        // 2.2.获取属性名
        NSString *filedName = [NSString stringWithUTF8String:property_getName(property)];
        
        // 2.3.拼接sql
        [filedSql appendString:[NSString stringWithFormat:@"%@ %@,", filedName, filedType]];
    }
    // 2.4.去掉尾部逗号
    NSString *filedSqlSentence = [filedSql substringToIndex:filedSql.length - 1];
    
    // 4.存储类型数据
    [self.tableFiledDictM setObject:filedArrM forKey:tableName];
    
    // 5.根据类名创表，属性名为字段
    NSString *sql = [NSString stringWithFormat:@"CREATE TABLE IF NOT EXISTS t_%@ (objcID integer PRIMARY KEY autoincrement, %@)", tableName, filedSqlSentence];
//    NSLog(@"%@", sql);
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, NULL)!= SQLITE_OK) {
        NSLog(@"注册对象失败/创表失败");
    };
}

/** 增 */
- (NSInteger)insertObjc:(id)obj {
    // 0.转OC对象
    NSObject *objc = (NSObject *)obj;
    
    // 1.获取表名
    NSString *tableName = NSStringFromClass([obj class]);
    if (![self isExistTableWithName:tableName]) return 0; // 不存在则返回0
    
    // 2.获取类的属性（字段）
    NSString *filedName= [self getSQLFiledNameStringWithObjc:obj];
    
    // 3.获取类的属性值 (字段内容)
    NSString *filedValue = [self getSQLFiledValueStringWithObjc:obj];
    
    // 4.获取插入语句
    NSString *sql = [NSString stringWithFormat:@"INSERT INTO t_%@(%@) VALUES (%@)", tableName, filedName, filedValue];
//    NSLog(@"%@", sql);
    // 5.插入
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, NULL)!= SQLITE_OK) {
        NSLog(@"添加对象失败");
    }else {
        NSLog(@"添加对象成功");
        // 获取ID
        NSString *sql = [NSString stringWithFormat:@"SELECT objcID FROM t_%@ ORDER BY objcID DESC LIMIT 0,1", tableName];
        sqlite3_stmt *stmt;
        if (sqlite3_prepare(_database, [sql UTF8String], -1, &stmt, NULL) == SQLITE_OK) { // 准备成功 ---SQL语句正确
            
            while (sqlite3_step(stmt) == SQLITE_ROW) { // 成功取出一条数据
                NSInteger objcID = (NSInteger)sqlite3_column_int(stmt, 0);
                // 记录ID
                objc.wy_objcID = objcID;
                NSLog(@"%zd", objcID);
            }
        }
    }
    return objc.wy_objcID;
    
}

/** 查 */
- (NSArray *)selectObjcsWithClass:(Class)objcClass {
    // 1.获取表名
    NSString *tableName = NSStringFromClass(objcClass);
    if (![self isExistTableWithName:tableName]) { // 不存在
        NSLog(@"这个类还没有注册！");
        return nil;
    }
    
    // 2.结果数组
    NSMutableArray *arrM = [NSMutableArray array];
    unsigned int count = 0;
    
    // 3.sql语句
    NSString *sql = [NSString stringWithFormat:@"SELECT *FROM t_%@", tableName];
//     NSLog(@"%@", sql);
    sqlite3_stmt *statement;
    if (sqlite3_prepare(_database, [sql UTF8String], -1, &statement, NULL) == SQLITE_OK) {
        
        // 3.1.遍历记录
        while (sqlite3_step(statement) == SQLITE_ROW) { // 成功取出一条数据
            
            // 3.2.创建取出的对象
           NSObject *obj = [objcClass new];
            // 3.2.1.获取主键
            int value = sqlite3_column_int(statement, 0);
            obj.wy_objcID = value;
            
            // 3.3.获取对象所有属性并遍历初始化
           objc_property_t *propertyList = class_copyPropertyList(objcClass, &count);
            for (int i = 0; i < count; i++) {
                
                // 3.3.0.获取属性列表
                objc_property_t property = propertyList[i];
                
                // 3.3.1.获取该属性类型
                NSString *filedType = [NSString stringWithUTF8String:property_getAttributes(property)];
                filedType = [[filedType componentsSeparatedByString:@","] firstObject];
                filedType = [filedType substringFromIndex:1];
//                NSLog(@"%zd - %@", i+1, filedType);
                
                
                // 3.3.2.获取该索引的属性名
                NSString *propertyName = [NSString stringWithUTF8String:property_getName(property)];
                
                // 3.3.2.根据类型解析对应字段的内容(除去主键) 并赋值
                if ([filedType isEqualToString:@"f"] || [filedType isEqualToString:@"d"]) { // 浮点
                    double value = sqlite3_column_double(statement, i + 1);
                    [obj setValue:@(value) forKey:propertyName];
                }else if ([filedType hasPrefix:@"@"]) { // 对象
                    // 截取类型
                    if ([filedType rangeOfString:@"NSString"].length) { // 文本
                        NSString *value;
                        char *valueStr = (char *)sqlite3_column_text(statement, i + 1);
                        if (valueStr != NULL) {
                            value = [NSString stringWithUTF8String:valueStr];
                        }else { // 为空
                            value = nil;
                        }
                        [obj setValue:value forKey:propertyName];
                    }else { // 非文本 - > 二进制(转成字符)
                        NSObject *value;
                        char *valueStr = (char *)sqlite3_column_text(statement, i + 1);
                        if (valueStr != NULL) {
                            NSString *strData = [NSString stringWithUTF8String:valueStr];
                            
                            // 1.截取成JSON字符串的二进制
                            NSData *valueData = [strData dataUsingEncoding:NSUTF8StringEncoding];
                            
                            // 2.解析JSON
                            value = [NSJSONSerialization JSONObjectWithData:valueData options:NSJSONReadingMutableContainers error:nil];
                        }else { // 为空则为空属性
                            value = nil;
                        }
                        [obj setValue:value forKey:propertyName];
                    }
                }else { // 整数
                    int value = sqlite3_column_int(statement, i + 1);
                    [obj setValue:@(value) forKey:propertyName];
                }
            }
            
            // 3.4.添加至结果数组
            [arrM addObject:obj];
        }
    }else {
        NSLog(@"查询错误!");
    }
   
    return arrM;
    
}

/** 删 */
- (void)deleteObjc:(id)obj {
    NSObject *objc = (NSObject *)obj;
    
    // 1.获取表名
    NSString *tableName = NSStringFromClass([obj class]);
    if (![self isExistTableWithName:tableName]) { // 不存在
        NSLog(@"这个类还没有注册！");
        return;
    }
    
    // 2.获取ID
    NSInteger objcID = objc.wy_objcID;
    
    // 3.sql语句
    // 4.获取插入语句
    NSString *sql = [NSString stringWithFormat:@"DELETE FROM t_%@ WHERE objcID=%zd", tableName, objcID];
    NSLog(@"%@", sql);
    if (sqlite3_exec(_database, [sql UTF8String], NULL, NULL, NULL)!= SQLITE_OK) {
        NSLog(@"删除对象失败");
    }else {
        NSLog(@"删除对象成功");
        // 清空主键
        objc.wy_objcID = 0;
    }
}

#pragma mark - 数据库语句字符串

/** 转换成SQL存储格式 */
- (NSString *)convertToSQLType:(NSString *)codeType {
    if ([codeType isEqualToString:@"f"] || [codeType isEqualToString:@"d"]) { // 浮点
        return @"real";
    }else if ([codeType hasPrefix:@"@"]) { // 对象
        // 截取类型
        if ([codeType rangeOfString:@"NSString"].length) { // 文本
            return @"text";
        }else { // 非文本 - > 二进制(转成字符)
            return @"text";
        }
    }else { // 整数
        return @"integer";
    }
}

/** 表名是否存在 */
- (BOOL)isExistTableWithName:(NSString *)tableName {
    __block BOOL existFlag = NO;
    [self.tableNameArrM enumerateObjectsUsingBlock:^(id  _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        if ([obj isEqualToString:[NSString stringWithFormat:@"t_%@", tableName]]) {// 存在
            existFlag = YES; // 标记存在
            *stop = YES; // 停止遍历
        }
    }];
    if (!existFlag) { // 不存在
        NSLog(@"请注册该类!");
        existFlag = NO; // 标记不存在
    }
    return existFlag;
}

/** 获取属性名字符串 eg: xxx, xxx, ... */
- (NSString *)getSQLFiledNameStringWithObjc:(id)obj {
    unsigned int count = 0;
    // sql语句
    NSMutableString *filedNameSql = [NSMutableString string];
    objc_property_t *propertyList = class_copyPropertyList([obj class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        // 1.获取字段名
        NSString *filedName = [NSString stringWithUTF8String:property_getName(property)];
        
        // 拼接sql语句的字段部分
        [filedNameSql appendString:[NSString stringWithFormat:@"%@,", filedName]];

    }
    NSString *filedSqlNameSentence = [filedNameSql substringToIndex:filedNameSql.length - 1];
//    NSLog(@"%@", filedSqlNameSentence);
    return filedSqlNameSentence;
}

/** 获取属性值字符串 eg: xxx, xxx, ... */
- (NSString *)getSQLFiledValueStringWithObjc:(id)obj {
    unsigned int count = 0;
    // sql语句
    NSMutableString *filedValueSql = [NSMutableString string];
    objc_property_t *propertyList = class_copyPropertyList([obj class], &count);
    for (int i = 0; i < count; i++) {
        objc_property_t property = propertyList[i];
        // 1.获取字段名
        NSString *filedName = [NSString stringWithUTF8String:property_getName(property)];
        
        // 2.获取属性值
        id value = [obj valueForKey:filedName];
        if ([value isKindOfClass:[NSString class]]) { // 字符则添加单引号
            value = [NSString stringWithFormat:@"'%@'", value];
        }else if ([value isKindOfClass:[NSArray class]] || [value isKindOfClass:[NSDictionary class]]){ // 基本集合类型
            // 集合类型 -> JSON二进制 -> 字符串 （这样能获得格式较好地字符串）
            value = [NSJSONSerialization dataWithJSONObject:value options:0 error:nil];
            value = [[NSString alloc]initWithData:value encoding:NSUTF8StringEncoding];
            value = [NSString stringWithFormat:@"'%@'", value];
//            NSLog(@"%@", value);
        }else if ([value isKindOfClass:[NSNumber class]]) { // 数字类型
            
        }else { // 对象
#warning 待拓展
        }
        
        // 拼接sql语句的字段部分
        [filedValueSql appendString:[NSString stringWithFormat:@"%@,", value]];
    }
    NSString *filedSqlValueSentence = [filedValueSql substringToIndex:filedValueSql.length - 1];
//    NSLog(@"%@", filedSqlValueSentence);
    return filedSqlValueSentence;
}












@end
