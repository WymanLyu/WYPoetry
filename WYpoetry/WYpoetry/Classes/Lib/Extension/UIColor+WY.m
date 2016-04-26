//
//  UIColor+Extension.m
//  02-26Qz2D
//
//  Created by sialice on 16/2/27.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import "UIColor+WY.h"

@implementation UIColor (WY)

+ (instancetype)wy_randomColor
{
    CGFloat r = (arc4random()%255)/255.0;
    CGFloat g = (arc4random()%255)/255.0;
    CGFloat b = (arc4random()%255)/255.0;
    
    return [self colorWithRed:r green:g blue:b alpha:1];
}

@end
