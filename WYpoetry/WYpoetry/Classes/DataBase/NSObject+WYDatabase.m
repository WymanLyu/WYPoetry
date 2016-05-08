//
//  NSObject+WYDatabase.m
//  5-7数据库
//
//  Created by sialice on 16/5/8.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "NSObject+WYDatabase.h"
#import "WYDatabase.h"
#import <objc/runtime.h>

const char *objcKey = "headKey";
const char *pdataKey = "pdataKey";
@implementation NSObject (WYDatabase)

/** 保存对象 */
- (void)wy_save {
    // 1.注册对象
    [[WYDatabase shareDatabase] registeTableWithClass:[self class]];
    
    // 2.插入对象
    [[WYDatabase shareDatabase] insertObjc:self];
}

/** 删除对象 */
- (void)wy_delete {
    if (self.wy_objcID != 0) { // 仅当存储时删除
        [[WYDatabase shareDatabase] deleteObjc:self];
    }
}

/** 获取存储对象 */
+ (NSArray *)wy_objs {
    return [[WYDatabase shareDatabase] selectObjcsWithClass:self];
}

- (void)setWy_objcID:(NSInteger)wy_objcID {
    // 建立关联属性
    objc_setAssociatedObject(self, objcKey, @(wy_objcID), OBJC_ASSOCIATION_ASSIGN);
}

- (NSInteger)wy_objcID {
    // 获取属性
    return  [objc_getAssociatedObject(self, objcKey) integerValue];
}

- (void)setWy_pdataArrM:(NSMutableArray *)wy_pdataArrM {
    // 建立关联属性
    objc_setAssociatedObject(self, pdataKey, wy_pdataArrM, OBJC_ASSOCIATION_ASSIGN);
}

- (NSMutableArray *)wy_pdataArrM {
    // 获取属性
    return  objc_getAssociatedObject(self, pdataKey);
}


@end
