//
//  UIImageView+WY.m
//  WY-BSBDJ
//
//  Created by sialice on 16/4/24.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "UIImageView+WY.h"

@implementation UIImageView (WY)

- (void)wy_clipToCircleCornerImageView {
    // 根据图片设置上下文大小
    CGFloat border = self.frame.size.width < self.frame.size.height ? self.frame.size.width : self.frame.size.height;
    CGSize ctxSize = CGSizeMake(border, border);
    // 开启图片上下文
    UIGraphicsBeginImageContextWithOptions(ctxSize, NO, 0);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 设置裁剪区域
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, border, border));
    CGContextClip(ctx);
    // 上下文绘制图片
    [self.image drawAtPoint:CGPointZero];
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    // 赋值
    self.image = newImage;
}

@end
