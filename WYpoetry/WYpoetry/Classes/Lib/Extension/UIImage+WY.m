//
//  UIImage+Extension.m
//  02-01聊天界面
//
//  Created by sialice on 16/2/2.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import "UIImage+WY.h"

@implementation UIImage (WY)

+ (instancetype)wy_resizabledImageNamed:(NSString *)name
{
    // 拉伸的图片
    UIImage *image = [UIImage imageNamed:name];
    //        UIEdgeInsets inset = UIEdgeInsetsMake(messageFrame.textBtnF.size.height*0.5 - 1, messageFrame.textBtnF.size.width*0.5 - 1, messageFrame.textBtnF.size.height*0.5, messageFrame.textBtnF.size.width*0.5);
    // 保护的范围（只拉伸中间的点）
    UIEdgeInsets inset = UIEdgeInsetsMake(image.size.height * 0.5, image.size.width * 0.5, image.size.height*0.5, image.size.width *0.5);
    // 拉伸后的图片
    UIImage *resizabledImage = [image resizableImageWithCapInsets:inset resizingMode:UIImageResizingModeStretch];
    // 返回拉伸的图片
    return resizabledImage;
}

// 根据颜色创建一张图片
+ (instancetype)wy_imageWithUIColor:(UIColor *)color andFrame:(CGRect)rect
{
    // 开启上下文
    UIGraphicsBeginImageContext(rect.size);
    CGContextRef context = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(context, [color CGColor]);
    CGContextFillRect(context, rect);
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return image;
    
}

// 返回圆角图片
- (instancetype)wy_circleCornerImage {
    // 根据图片设置上下文大小
    CGFloat border = self.size.width < self.size.height ? self.size.width : self.size.height;
    CGSize ctxSize = CGSizeMake(border, border);
    // 开启图片上下文
    UIGraphicsBeginImageContext(ctxSize);
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 设置裁剪区域
    CGContextAddEllipseInRect(ctx, CGRectMake(0, 0, border, border));
    CGContextClip(ctx);
    // 上下文绘制图片
    [self drawAtPoint:CGPointZero];
    // 获取新图片
    UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
    // 关闭上下文
    UIGraphicsEndImageContext();
    return newImage;
}


@end
