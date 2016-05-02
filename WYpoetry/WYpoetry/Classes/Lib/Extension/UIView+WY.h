/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import <UIKit/UIKit.h>

CGPoint wy_CGRectGetCenter(CGRect rect);
CGRect  wy_CGRectMoveToCenter(CGRect rect, CGPoint center);

@interface UIView (WY)

@property CGPoint wy_origin;
@property CGSize wy_size;

@property (readonly) CGPoint wy_bottomLeft;
@property (readonly) CGPoint wy_bottomRight;
@property (readonly) CGPoint wy_topRight;

@property CGFloat wy_height;
@property CGFloat wy_width;

@property CGFloat wy_top;
@property CGFloat wy_left;

@property CGFloat wy_bottom;
@property CGFloat wy_right;

- (void) wy_moveBy: (CGPoint) delta;
- (void) wy_scaleBy: (CGFloat) scaleFactor;
- (void) wy_fitInSize: (CGSize) aSize;

/**
 *  添加直线或虚线
 *
 *  @param lineColor 边线颜色
 *  @param isDash    是否虚线
 */
- (void)addBorderLayerWithColor:(UIColor *)lineColor dashDotted:(BOOL)isDash;

/**
 *  获取指定区域的截图
 *
 *  @return 图片
 */
- (UIImage *)getImageInRect:(CGRect)rect;
@end