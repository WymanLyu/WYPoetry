//
//  UITabBarItem+WY.h
//  WY-BSBDJ
//
//  Created by sialice on 16/4/22.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITabBarItem (WY)

+ (instancetype)itemWithTitle:(NSString *)title
              normalImageName:(NSString *)normalImageName
            selectedImageName:(NSString *)selectedImageName;


@end
