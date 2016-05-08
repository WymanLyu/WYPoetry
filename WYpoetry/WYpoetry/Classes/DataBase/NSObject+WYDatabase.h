//
//  NSObject+WYDatabase.h
//  5-7数据库
//
//  Created by sialice on 16/5/8.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSObject (WYDatabase)

/** 数据库存储ID */
@property (nonatomic, assign) NSInteger wy_objcID;

/** 数据库存储对象中二进制的指针数组 */
@property (nonatomic, strong) NSMutableArray *wy_pdataArrM;

/** 保存对象 */
- (void)wy_save;
/** 删除对象 */
- (void)wy_delete;

@end
