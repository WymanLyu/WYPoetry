//
//  WYDatabase.h
//  WYpoetry
//
//  Created by sialice on 16/5/7.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYDatabase : NSObject

/** 连接数据库（无则创建）并获取数据库 */
+ (instancetype)shareDatabase;

/** 注册对象（根据对象属性创表） */
- (void)registeTableWithClass:(Class)objcClass;

/** 增 */
- (NSInteger)insertObjc:(id)obj;

/** 删 */
- (void)deleteObjc:(id)obj; // 删除ID的对象
- (void)deleteObjcWithObjID:(NSInteger)objID; // 删除ID的对象

/** 查 */
- (NSArray *)selectObjcsWithClass:(Class)objcClass; // 获取这个类型的所有对象（即表中所以记录）

- (id)selectObjcWithObjID:(NSInteger)objID; // 获得唯一的存储对象
- (NSArray *)selectObjcsWithFiledDict:(NSDictionary *)dict; // 根据属性值获取存储对象


/** 改 */
- (void)setObjc:(id)objc WithFiledValueDict:(NSDictionary *)dict; // 更新对象的属性

@end
