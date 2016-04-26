//
//  UIBarButtonItem+WY.h
//  WY-BSBDJ
//
//  Created by sialice on 16/4/23.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (WY)

+ (instancetype)itemWithNormalImageName:(NSString *)normalImageName
                       clickedImageName:(NSString *)clickedImageName
                                 target:(id)target
                                 action:(SEL)action
                         positionOffset:(CGFloat)positionOffset;

+ (instancetype)backItemWithNormalImageName:(NSString *)normalImageName
                           clickedImageName:(NSString *)clickedImageName
                                     target:(id)target
                                     action:(SEL)action
                             positionOffset:(CGFloat)positionOffset;

@end
