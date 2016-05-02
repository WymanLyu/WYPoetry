/*
 Erica Sadun, http://ericasadun.com
 iPhone Developer's Cookbook, 3.0 Edition
 BSD License, Use at your own risk
 */

#import "UIView+WY.h"

CGPoint wy_CGRectGetCenter(CGRect rect)
{
    CGPoint pt;
    pt.x = CGRectGetMidX(rect);
    pt.y = CGRectGetMidY(rect);
    return pt;
}

CGRect wy_CGRectMoveToCenter(CGRect rect, CGPoint center)
{
    CGRect newrect = CGRectZero;
    newrect.origin.x = center.x-CGRectGetMidX(rect);
    newrect.origin.y = center.y-CGRectGetMidY(rect);
    newrect.size = rect.size;
    return newrect;
}

@implementation UIView (WY)


// Retrieve and set the origin
- (CGPoint) wy_origin
{
	return self.frame.origin;
}

- (void) setWy_origin: (CGPoint) aPoint
{
	CGRect newframe = self.frame;
	newframe.origin = aPoint;
	self.frame = newframe;
}


// Retrieve and set the size
- (CGSize) wy_size
{
	return self.frame.size;
}

- (void) setWy_size: (CGSize) aSize
{
	CGRect newframe = self.frame;
	newframe.size = aSize;
	self.frame = newframe;
}

// Query other frame locations
- (CGPoint) wy_bottomRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) wy_bottomLeft
{
	CGFloat x = self.frame.origin.x;
	CGFloat y = self.frame.origin.y + self.frame.size.height;
	return CGPointMake(x, y);
}

- (CGPoint) wy_topRight
{
	CGFloat x = self.frame.origin.x + self.frame.size.width;
	CGFloat y = self.frame.origin.y;
	return CGPointMake(x, y);
}


// Retrieve and set height, width, top, bottom, left, right
- (CGFloat) wy_height
{
	return self.frame.size.height;
}

- (void) setWy_height: (CGFloat) newheight
{
	CGRect newframe = self.frame;
	newframe.size.height = newheight;
	self.frame = newframe;
}

- (CGFloat) wy_width
{
	return self.frame.size.width;
}

- (void) setWy_width: (CGFloat) newwidth
{
	CGRect newframe = self.frame;
	newframe.size.width = newwidth;
	self.frame = newframe;
}

- (CGFloat) wy_top
{
	return self.frame.origin.y;
}

- (void) setWy_top: (CGFloat) newtop
{
	CGRect newframe = self.frame;
	newframe.origin.y = newtop;
	self.frame = newframe;
}

- (CGFloat) wy_left
{
	return self.frame.origin.x;
}

- (void) setWy_left: (CGFloat) newleft
{
	CGRect newframe = self.frame;
	newframe.origin.x = newleft;
	self.frame = newframe;
}

- (CGFloat) wy_bottom
{
	return self.frame.origin.y + self.frame.size.height;
}

- (void) setWy_bottom: (CGFloat) newbottom
{
	CGRect newframe = self.frame;
	newframe.origin.y = newbottom - self.frame.size.height;
	self.frame = newframe;
}

- (CGFloat) wy_right
{
	return self.frame.origin.x + self.frame.size.width;
}

- (void) setWy_right: (CGFloat) newright
{
	CGFloat delta = newright - (self.frame.origin.x + self.frame.size.width);
	CGRect newframe = self.frame;
	newframe.origin.x += delta ;
	self.frame = newframe;
}

// Move via offset
- (void) wy_moveBy: (CGPoint) delta
{
	CGPoint newcenter = self.center;
	newcenter.x += delta.x;
	newcenter.y += delta.y;
	self.center = newcenter;
}

// Scaling
- (void) wy_scaleBy: (CGFloat) scaleFactor
{
	CGRect newframe = self.frame;
	newframe.size.width *= scaleFactor;
	newframe.size.height *= scaleFactor;
	self.frame = newframe;
}

// Ensure that both dimensions fit within the given size by scaling down
- (void) wy_fitInSize: (CGSize) aSize
{
	CGFloat scale;
	CGRect newframe = self.frame;
	
	if (newframe.size.height && (newframe.size.height > aSize.height))
	{
		scale = aSize.height / newframe.size.height;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	if (newframe.size.width && (newframe.size.width >= aSize.width))
	{
		scale = aSize.width / newframe.size.width;
		newframe.size.width *= scale;
		newframe.size.height *= scale;
	}
	
	self.frame = newframe;	
}

- (void)addBorderLayerWithColor:(UIColor *)lineColor dashDotted:(BOOL)isDash {
//    // 移除上一次虚线图层
//    CALayer *lineLayer = [self.layer.sublayers lastObject];
//    [lineLayer removeFromSuperlayer];
    // 创建图层
    CAShapeLayer *shapeLayer = [CAShapeLayer layer];
    // 设置图层颜色和尺寸
    [shapeLayer setFrame:self.bounds];
    [shapeLayer setFillColor:[[UIColor clearColor] CGColor]];
    // 设置图层边线颜色为blackColor
    [shapeLayer setStrokeColor:[lineColor CGColor]];
    // 设置图层边线的宽度
    [shapeLayer setLineWidth:1.0f];
    [shapeLayer setLineJoin:kCALineJoinRound];
    // 设置图层边线虚实
    NSArray *pattern = isDash ? @[@10, @10] : nil;
    [shapeLayer setLineDashPattern:pattern];
    // 设置图层样式/路径
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathMoveToPoint(path, NULL, self.frame.origin.x, self.frame.origin.y);
    CGPathAddRect(path, NULL, self.bounds);
    [shapeLayer setPath:path];
    CGPathRelease(path);
    // 载蒙版上添加
    [[self layer] addSublayer:shapeLayer];

}

/** 获取指定区域的截图 */
- (UIImage *)getImageInRect:(CGRect)rect {
    // 1.开启上下文
    UIGraphicsBeginImageContextWithOptions(self.frame.size, NO, 0);
    // 2.设置路径
    UIBezierPath *path = [UIBezierPath bezierPathWithRect:rect];
    [path addClip];
    // 3.获取上下文
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    // 4.渲染layer
    [self.layer renderInContext:ctx];
    // 5.获取图片
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    // 6.关闭上下文
    UIGraphicsEndImageContext();

    return image;

}

@end