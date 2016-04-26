//
//  NSArray+Extension.m
//  02-26Qz2D
//
//  Created by sialice on 16/2/27.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import "NSArray+WY.h"

@implementation NSArray (WY)

+ (instancetype)wy_arryWithString:(NSString *)string divideByCharacter:(char)character
{
    // 最后字符不是分隔符则补上分隔符
    NSMutableString *str;
    if ([string characterAtIndex:string.length - 1]!= character){
        str = [NSMutableString stringWithFormat:@"%@%c", string, character];
    }else{
        str = [NSMutableString stringWithString:string];
    }
    int startIndex = 0;
    int endIndex = -1;
    NSMutableArray *arrM = [NSMutableArray array];
    // 遍历字符串
    for (int i = 0; i < str.length; i++) {
        char c = [str characterAtIndex:i];
        if (c == character) {
            startIndex = endIndex;
            endIndex = i;
            NSString *numStr = [str substringWithRange:NSMakeRange(startIndex+1, endIndex - startIndex-1)];
            [arrM addObject:numStr];
        }
    }
    return [self arrayWithArray:arrM];
    
}

// 返回数组最大值/
- (double)wy_getMaxObject
{
    NSComparator cmptr = ^(id obj1, id obj2){
        if ([obj1 doubleValue] > [obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedDescending;
        }
        
        if ([obj1 doubleValue] < [obj2 doubleValue]) {
            return (NSComparisonResult)NSOrderedAscending;
        }
        return (NSComparisonResult)NSOrderedSame;
    };
    NSArray *sortedArray = [self sortedArrayUsingComparator:cmptr];
    NSNumber *number = [sortedArray lastObject];
    return number.doubleValue;
}

@end
