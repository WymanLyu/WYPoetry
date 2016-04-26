//
//  UIBarButtonItem+WY.m
//  WY-BSBDJ
//
//  Created by sialice on 16/4/23.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "UIBarButtonItem+WY.h"

@implementation UIBarButtonItem (WY)

+ (instancetype)itemWithNormalImageName:(NSString *)normalImageName
             clickedImageName:(NSString *)clickedImageName
                       target:(id)target
                       action:(SEL)action
               positionOffset:(CGFloat)positionOffset{
    // 1.创建按钮
    UIButton *btn = [[UIButton alloc] init];
    
    // 1.设置图片
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *clickedImage = [UIImage imageNamed:clickedImageName];
    clickedImage = [clickedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:clickedImage forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    // 2.设置图片偏移量
    if (positionOffset > 0) { // 往右边偏移
         btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -positionOffset);
    } else { // 往左边偏移
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, positionOffset, 0, 0);
    }
    
    // 3.监听点击
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 4.包装view和设置偏移量
    UIView *view = [[UIView alloc] init];
    view.wy_size = btn.wy_size;
    [view addSubview:btn];
//    view.backgroundColor= [UIColor wy_randomColor];
    
    // 5.创建btnItem
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    // 6.返回tabBarItem
    return barBtnItem;
}

+ (instancetype)backItemWithNormalImageName:(NSString *)normalImageName
                           clickedImageName:(NSString *)clickedImageName
                                     target:(id)target
                                     action:(SEL)action
                             positionOffset:(CGFloat)positionOffset{
    // 1.创建按钮
    UIButton *btn = [[UIButton alloc] init];
    
    // 1.设置图片
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    UIImage *clickedImage = [UIImage imageNamed:clickedImageName];
    clickedImage = [clickedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    [btn setImage:normalImage forState:UIControlStateNormal];
    [btn setImage:clickedImage forState:UIControlStateHighlighted];
    [btn setTitle:@"返回" forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor redColor] forState:UIControlStateHighlighted];
    [btn sizeToFit];
    
    // 2.设置图片偏移量
    if (positionOffset > 0) { // 往右边偏移
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, 0, 0, -positionOffset);
    } else { // 往左边偏移
        btn.contentEdgeInsets = UIEdgeInsetsMake(0, positionOffset, 0, 0);
    }
    
    // 3.监听点击
    [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
    
    // 4.包装view和设置偏移量
    UIView *view = [[UIView alloc] init];
    view.wy_size = btn.wy_size;
    [view addSubview:btn];
    //    view.backgroundColor= [UIColor wy_randomColor];
    
    // 5.创建btnItem
    UIBarButtonItem *barBtnItem = [[UIBarButtonItem alloc] initWithCustomView:view];
    
    // 6.返回tabBarItem
    return barBtnItem;
}



@end
