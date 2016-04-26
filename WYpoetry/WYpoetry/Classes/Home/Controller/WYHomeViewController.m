//
//  WYHomeViewController.m
//  WYpoetry
//
//  Created by sialice on 16/4/26.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYHomeViewController.h"
#import "WYButtomBar.h"

@interface WYHomeViewController ()
@property (nonatomic, weak) WYButtomBar *buttomBar;

@end

@implementation WYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = BASECOLOR;
    
    // 设置底部栏
    [self setupButtomBar];

}

- (void)setupButtomBar {
    WYButtomBar *toolbar = [[WYButtomBar alloc] init];
    // 刷新
    UIBarButtonItem *barItem = [UIBarButtonItem itemWithNormalImageName:@"refreshIcon" clickedImageName:nil target:self action:@selector(settingClick) positionOffset:0];
    // 弹簧
//    UIBarButtonItem *barItem0 = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemFlexibleSpace target:nil action:nil];
    UIBarButtonItem *barItem0 = [UIBarButtonItem itemWithNormalImageName:nil clickedImageName:nil target:nil action:nil positionOffset:0];
    // 书签
    UIBarButtonItem *barItem1 = [UIBarButtonItem itemWithNormalImageName:@"favouriteIcon" clickedImageName:nil target:self action:@selector(settingClick) positionOffset:0];
    // 我的
    UIBarButtonItem *barItem2 = [UIBarButtonItem itemWithNormalImageName:@"settingIcon" clickedImageName:nil target:self action:@selector(settingClick) positionOffset:0];
    // 设置
    UIBarButtonItem *barItem3 = [UIBarButtonItem itemWithNormalImageName:@"settingIcon" clickedImageName:nil target:self action:@selector(settingClick) positionOffset:0];
    [toolbar setItems:@[barItem, barItem0, barItem1, barItem2, barItem3]];
    // 设置尺寸
    CGFloat barW = [UIScreen mainScreen].bounds.size.width;
    CGFloat barH = 0;
    CGFloat barX = 0;
    if ( CGSizeEqualToSize([UIScreen mainScreen].bounds.size, IPHONE4_SCREENSIZE) ) {
        barH = 44;
    }else {
        barH = 64;
    }
    CGFloat barY = [UIScreen mainScreen].bounds.size.height - barH;
    toolbar.frame = CGRectMake(barX, barY, barW, barH);

    UIView *separateLine = [[UIView alloc] initWithFrame:CGRectMake(0, 0, barW, 1)];
    [separateLine setBackgroundColor:[UIColor blackColor]];
    [toolbar addSubview:separateLine];
    [toolbar setBackgroundColor:[UIColor wy_randomColor]];
    [self.view addSubview:toolbar];
}

- (void)settingClick {

}

@end
