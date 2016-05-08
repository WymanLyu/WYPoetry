//
//  WYPoetryModel.h
//  WYpoetry
//
//  Created by sialice on 16/4/29.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface WYPoetryModel : NSObject

/** 作者 */
@property (nonatomic, copy) NSString *artist;

/** 诗句数组 */
@property (nonatomic, copy) NSArray *contents;

/** 诗名 */
@property (nonatomic, copy) NSString *title;

#pragma mark - 自定义字段
/** 是否喜好 */
@property (nonatomic, assign, getter=isFavourite) BOOL favourite;

- (instancetype)initWithDict:(NSDictionary *)dict;
+ (instancetype)poetryModelWithDict:(NSDictionary *)dict;

@end
