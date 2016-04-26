//
//  UITabBarItem+WY.m
//  WY-BSBDJ
//
//  Created by sialice on 16/4/22.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "UITabBarItem+WY.h"

#define TABBAR_TITLEOFFSETVERTICAL -2

@implementation UITabBarItem (WY)

+ (instancetype)itemWithTitle:(NSString *)title
              normalImageName:(NSString *)normalImageName
            selectedImageName:(NSString *)selectedImageName {
    // 1.设置图片
    UIImage *normalImage = [UIImage imageNamed:normalImageName];
    UIImage *selectedImage = [UIImage imageNamed:selectedImageName];
    normalImage = [normalImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    selectedImage = [selectedImage imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal];
    
    UITabBarItem *tabBarItem = [[UITabBarItem alloc] initWithTitle:title image:normalImage selectedImage:selectedImage];
    
    // 2.设置文字属性
    NSDictionary *textAttributesDict = @{
                                         NSFontAttributeName : [UIFont systemFontOfSize:12.0],
                                         NSForegroundColorAttributeName : [UIColor blackColor]
                                         };
    [tabBarItem setTitleTextAttributes:textAttributesDict forState:UIControlStateSelected];
    tabBarItem.titlePositionAdjustment  = UIOffsetMake(0, TABBAR_TITLEOFFSETVERTICAL);
    
    // 3.返回tabBarItem
    return tabBarItem;
}

@end
