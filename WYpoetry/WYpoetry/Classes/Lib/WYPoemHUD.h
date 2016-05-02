//
//  WYPoemHUD.h
//  WYpoetry
//
//  Created by sialice on 16/5/2.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYPoemHUD : UIView

/** 获取单例 */
+ (instancetype)shareView;

+ (void)show;
+ (void)dismiss;

+ (void)showSuccess;
+ (void)showFail;

@end
