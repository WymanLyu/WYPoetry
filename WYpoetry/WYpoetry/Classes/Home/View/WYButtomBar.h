//
//  WYButtomBar.h
//  WYpoetry
//
//  Created by sialice on 16/4/26.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef NS_ENUM(NSInteger, WYButtomBarButtonStyle) {
    WYButtomBarButtonStylePlaceHolder, // 占位按钮，不显示
    WYButtomBarButtonStylePlain, // 普通按钮，显示图片
};

@class WYButtomBarButton;
@interface WYButtomBar : UIView

/** 创建ButtomBar */
- (instancetype)initWithButtomBarButtonArray:(NSArray<WYButtomBarButton *> *)btnArray;
+ (instancetype)buttomBarWithButtomBarButtonArray:(NSArray<WYButtomBarButton *> *)btnArray;

@end


@interface WYButtomBarButton : UIView

/** 选中状态 */
@property (nonatomic, assign, getter=isSelected) BOOL selected;

- (instancetype)initWithImageName:(nullable NSString *)imageName style:(WYButtomBarButtonStyle)style target:(nullable id)target action:(nullable SEL)action;

- (instancetype)initWithImageName:(nullable NSString *)imageName selectedImageName:(nullable NSString *)selectedImageName style:(WYButtomBarButtonStyle)style target:(nullable id)target action:(nullable SEL)action;

@end