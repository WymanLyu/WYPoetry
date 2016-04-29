//
//  WYPoetryModel.m
//  WYpoetry
//
//  Created by sialice on 16/4/29.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYPoetryModel.h"

@implementation WYPoetryModel

- (instancetype)initWithDict:(NSDictionary *)dict {
    if (self = [super init]) {
        self.artist = dict[@"artist"];
        self.title = dict[@"title"];
        NSString *str = dict[@"content"];
        self.contents = [str componentsSeparatedByString:@"|^n|"] ;
    }
    return self;
}

+ (instancetype)poetryModelWithDict:(NSDictionary *)dict {
    return [[self alloc] initWithDict:dict];
}

@end
