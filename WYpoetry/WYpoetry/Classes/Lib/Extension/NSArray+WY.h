//
//  NSArray+Extension.h
//  02-26Qz2D
//
//  Created by sialice on 16/2/27.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSArray (WY)

// 根据字符分割字符串
+ (instancetype)wy_arryWithString:(NSString *)string divideByCharacter:(char)character;

// 返回数组最大值/*数组必须存储NSNumber*/
- (double)wy_getMaxObject;

@end
