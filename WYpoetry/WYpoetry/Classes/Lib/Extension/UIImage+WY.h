//
//  UIImage+Extension.h
//  02-01聊天界面
//
//  Created by sialice on 16/2/2.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIImage (WY)


// 利用拉伸模式进行拉伸图片
+ (instancetype)wy_resizabledImageNamed:(NSString *)name;

// 根据颜色创建一张图片
+ (instancetype)wy_imageWithUIColor:(UIColor *)colorm andFrame:(CGRect)rect;

// 设置圆形图片 半径为最小边
- (instancetype)wy_circleCornerImage;

/**
 *  生成右下角水印
 *
 *  @param mark 水印文字
 *
 *  @return 新的图片
 */
- (UIImage *)addWaterMark:(NSString *)mark inRect:(CGRect)rect ;

/** 设置图片透明度 */
+ (UIImage *)imageByApplyingAlpha:(CGFloat)alpha image:(UIImage*)image;
@end
