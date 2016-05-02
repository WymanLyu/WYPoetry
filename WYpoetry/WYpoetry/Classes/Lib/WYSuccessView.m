//
//  WYSuccessView.m
//  WYpoetry
//
//  Created by sialice on 16/5/2.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYSuccessView.h"

@implementation WYSuccessView


- (void)drawRect:(CGRect)rect {
    // 获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    
    // 画勾
    CGContextMoveToPoint(ctx, rect.size.width * 0.3, rect.size.height * 0.5);
    CGContextAddLineToPoint(ctx, rect.size.width * 0.4, rect.size.height * 0.7);
    CGContextAddLineToPoint(ctx, rect.size.width * 0.8, rect.size.height * 0.3);
    CGContextSetLineWidth(ctx, 3.0);
    
    // 绘制
    CGContextStrokePath(ctx);
}


@end
