//
//  WYFailView.m
//  WYpoetry
//
//  Created by sialice on 16/5/2.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYFailView.h"

@implementation WYFailView

- (void)drawRect:(CGRect)rect {
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 画勾
    CGContextMoveToPoint(ctx, rect.size.width * 0.25, rect.size.height * 0.25);
    CGContextAddLineToPoint(ctx, rect.size.width * 0.75, rect.size.height * 0.75);
    CGContextSetLineWidth(ctx, 3.0);
    
    // 绘制
    CGContextStrokePath(ctx);
    
    CGContextMoveToPoint(ctx, rect.size.width * 0.75, rect.size.height * 0.25);
    CGContextAddLineToPoint(ctx, rect.size.width * 0.25, rect.size.height * 0.75);
    CGContextSetLineWidth(ctx, 3.0);
    
    // 绘制
    CGContextStrokePath(ctx);
}

@end
