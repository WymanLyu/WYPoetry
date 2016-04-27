//
//  WYHomeViewController.m
//  WYpoetry
//
//  Created by sialice on 16/4/26.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYHomeViewController.h"
#import "WYButtomBar.h"
#import "WYBaseNavViewController.h"
#import "WYSettingTableViewController.h"
#import "WYMineTableViewController.h"

@interface WYHomeViewController ()<UITableViewDataSource, UITableViewDelegate>
@property (nonatomic, weak) WYButtomBar *buttomBar;

@end

@implementation WYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置底部栏
    [self setupButtomBar];
    
    // 2.设置展示view
    [self setupTableView];

}

/** 设置底部栏 */
- (void)setupButtomBar {
 
    // 刷新
    WYButtomBarButton *refreshBtn = [[WYButtomBarButton alloc] initWithImageName:@"refreshIcon" style:WYButtomBarButtonStylePlain target:self action:@selector(refresh)];
    
    // 占位
    WYButtomBarButton *placeHoderBtn = [[WYButtomBarButton alloc] initWithImageName:@"" style:WYButtomBarButtonStylePlaceHolder target:nil action:nil];
    
    // 书签
    WYButtomBarButton *bookMarkBtn = [[WYButtomBarButton alloc] initWithImageName:@"favouritePoemIcon" selectedImageName:@"favouritePoemIconClick" style:WYButtomBarButtonStylePlain target:self action:@selector(favouritePoemIconClick:)];
            
    
    // 我的
    WYButtomBarButton *mineBtn = [[WYButtomBarButton alloc] initWithImageName:@"mineIcon" style:WYButtomBarButtonStylePlain target:self action:@selector(mine)];
    
    // 设置
    WYButtomBarButton *settingBtn = [[WYButtomBarButton alloc] initWithImageName:@"settingIcon" style:WYButtomBarButtonStylePlain target:self action:@selector(settingClick)];

   WYButtomBar *toolbar = [[WYButtomBar alloc] initWithButtomBarButtonArray:@[refreshBtn, placeHoderBtn, bookMarkBtn, mineBtn, settingBtn]];

    // 设置尺寸
    CGFloat barW = [UIScreen mainScreen].bounds.size.width;
    CGFloat barH = 0;
    CGFloat barX = 0;
    if ( CGSizeEqualToSize([UIScreen mainScreen].bounds.size, IPHONE4_SCREENSIZE) ) {
        barH = 44;
    }else {
        barH = 54;
    }
    CGFloat barY = [UIScreen mainScreen].bounds.size.height - barH;
    toolbar.frame = CGRectMake(barX, barY, barW, barH);


    [toolbar setBackgroundColor:BASECOLOR];
    [self.view addSubview:toolbar];
}

- (void)setupTableView {
    UITableView *showTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
//    NSLayoutConstraint *constraint = [NSLayoutConstraint constraintWithItem:showTableView attribute:NSLayoutAttributeCenterX relatedBy:<#(NSLayoutRelation)#> toItem:<#(nullable id)#> attribute:<#(NSLayoutAttribute)#> multiplier:<#(CGFloat)#> constant:<#(CGFloat)#>]
//    [self.view addConstraints:<#(nonnull NSArray<__kindof NSLayoutConstraint *> *)#>]
    showTableView.backgroundColor = [UIColor wy_randomColor];
    showTableView.dataSource = self;
    showTableView.delegate = self;
    [self.view addSubview:showTableView];
}

/** 设置点击 */
- (void)settingClick {
    WYLog(@"%s", __func__);
    WYSettingTableViewController *settingVc = [[WYSettingTableViewController alloc] init];
    WYBaseNavViewController *navVc = [[WYBaseNavViewController alloc] initWithRootViewController:settingVc];
    [self presentViewController:navVc animated:YES completion:nil];
}

/** 喜爱标签 */
- (void)favouritePoemIconClick:(WYButtomBarButton *)button {
    WYLog(@"%s", __func__);
    button.selected = !button.isSelected;
}

/** 刷新 */
- (void)refresh {
    WYLog(@"%s", __func__);
}

/** 我的 */
- (void)mine {
    WYLog(@"%s", __func__);
    WYMineTableViewController *settingVc = [[WYMineTableViewController alloc] init];
    WYBaseNavViewController *navVc = [[WYBaseNavViewController alloc] initWithRootViewController:settingVc];
    [self presentViewController:navVc animated:YES completion:nil];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"cell"];
    cell.textLabel.text = [NSString stringWithFormat:@"测试%zd", indexPath.row];
    return cell;
}
@end









