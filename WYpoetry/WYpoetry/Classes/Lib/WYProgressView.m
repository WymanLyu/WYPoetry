//
//  WYProgressView.m
//  02-26Qz2D
//
//  Created by sialice on 16/2/27.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import "WYProgressView.h"

@implementation WYProgressView

- (void)setProgress:(CGFloat)progress{
    _progress = progress;
   
    if (_progress > 3) return;
    [self setNeedsDisplay];
}

- (void)drawRect:(CGRect)rect{
    // 画大圆
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGFloat r = self.bounds.size.width < self.bounds.size.height ? (self.bounds.size.width/2.0 - 10):(self.bounds.size.height/2.0 - 10);
    CGFloat endAngle = self.progress * M_PI * 2 - M_PI_2;
    UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(self.bounds.size.width/2.0, self.bounds.size.height/2.0) radius:r startAngle:-M_PI_2 endAngle:endAngle clockwise:YES];
    CGContextAddPath(ctx, path.CGPath);
    CGContextSetLineWidth(ctx, 1.0);
    [[[UIColor blackColor] colorWithAlphaComponent:0.35] setStroke];
    CGContextStrokePath(ctx);
    
    if (self.progress > 1) { // 画小圆
        CGFloat newProgress = self.progress - 1;
        CGFloat radius = r * 0.35;
        // 计算内切圆圆心
        CGFloat board = (r - radius) * sin(M_PI_4);
        CGFloat centerX = self.bounds.size.width/2.0 + board;
        CGFloat centerY = self.bounds.size.height/2.0 - board;
        CGFloat endAngle = newProgress * M_PI * 2 - M_PI_4;
        UIBezierPath *path = [UIBezierPath bezierPathWithArcCenter:CGPointMake(centerX, centerY) radius:radius startAngle:-M_PI_4 endAngle:endAngle clockwise:YES];
        CGContextAddPath(ctx, path.CGPath);
        [[[UIColor blackColor] colorWithAlphaComponent:0.65] setStroke];
        CGContextStrokePath(ctx);
        if (self.progress > 2) { // 画竖线
            UIBezierPath *path = [UIBezierPath bezierPath];
            CGFloat startX = centerX - radius;
            CGFloat startY = centerY;
            CGFloat lineLong = self.bounds.size.height/2.0 - centerY;
            [path moveToPoint:CGPointMake(startX, startY)];
            newProgress = self.progress - 2;
            [path addLineToPoint:CGPointMake(startX, startY + lineLong * newProgress)];
            CGContextAddPath(ctx, path.CGPath);
            [[[UIColor blackColor] colorWithAlphaComponent:0.65] setStroke];
            CGContextStrokePath(ctx);
        }
        
    }
}

@end
