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
#import "WYPoetryModel.h"
#import "WYPoetrySentenceCell.h"

@interface WYHomeViewController ()<UITableViewDataSource, UITableViewDelegate>
/** 底部的bar */
@property (nonatomic, weak) WYButtomBar *buttomBar;

/** 播放tableView */
@property (nonatomic, weak) UITableView *showView;

/** 当前诗歌模型 */
@property (nonatomic, strong) WYPoetryModel *model;
@end

@implementation WYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    // 1.设置底部栏
    [self setupButtomBar];
    
    // 2.设置展示view
    [self setupTableView];
    
    // 3.网络数据
    [self loadData];

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

/** 设置展示的view */
- (void)setupTableView {
    UITableView *showTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    [showTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [showTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    showTableView.showsVerticalScrollIndicator = NO;
    self.showView = showTableView;
    self.showView.backgroundColor = BASECOLOR;
    [self.view addSubview:showTableView];
    NSLayoutConstraint *constraintCenterX = [NSLayoutConstraint constraintWithItem:showTableView
                                                                         attribute:NSLayoutAttributeCenterX
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.view
                                                                         attribute:NSLayoutAttributeCenterX
                                                                        multiplier:1.0f
                                                                          constant:0];
    NSLayoutConstraint *constraintCenterY = [NSLayoutConstraint constraintWithItem:showTableView
                                                                  attribute:NSLayoutAttributeCenterY
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.view
                                                                  attribute:NSLayoutAttributeCenterY
                                                                 multiplier:1.0f
                                                                   constant:-20];
    NSLayoutConstraint *contraintWidth = [NSLayoutConstraint constraintWithItem:showTableView
                                                                      attribute:NSLayoutAttributeWidth
                                                                      relatedBy:NSLayoutRelationEqual
                                                                         toItem:self.view
                                                                      attribute:NSLayoutAttributeWidth
                                                                     multiplier:0.75
                                                                       constant:0];
    NSLayoutConstraint *contraintHeight = [NSLayoutConstraint constraintWithItem:showTableView
                                                                 attribute:NSLayoutAttributeHeight
                                                                 relatedBy:NSLayoutRelationEqual
                                                                    toItem:self.view
                                                                 attribute:NSLayoutAttributeHeight
                                                                multiplier:0.5
                                                                  constant:0];
    
    [self.view addConstraints:@[constraintCenterX, constraintCenterY, contraintHeight, contraintWidth]];
    showTableView.backgroundColor = BASECOLOR;
    showTableView.dataSource = self;
    showTableView.delegate = self;
    
}

/** 网络请求 */
- (void)loadData {
    // 1.会话配置
    NSURLSessionConfiguration *configuration = [NSURLSessionConfiguration defaultSessionConfiguration];
    
    // 2.创建会话
    NSURLSession *session = [NSURLSession sessionWithConfiguration:configuration];
    
    // 3.创建请求
    NSInteger index = 34;
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL(index)];
    
    // 3.发起数据请求任务
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        if (connectionError) { // 连接网络失败
            NSLog(@"网络连接失败:%@", connectionError);
        }
        // 解析JSON数据
        NSError *error = nil;
        NSArray *contentArray = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingMutableContainers error:&error];
        if (error) {// 数据解析失败
            WYLog(@"数据解析失败:%@", error);
        }else { // 数据转模型
            WYLog(@"====");
            WYPoetryModel *model = [WYPoetryModel poetryModelWithDict:[contentArray firstObject]];
            self.model = model;
            dispatch_async(dispatch_get_main_queue(), ^{
                [self.showView reloadData];
            });
        }
    }];
    
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

#pragma mark - UITableViewDatatSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.model.contents.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建cell
    WYPoetrySentenceCell *cell = [WYPoetrySentenceCell poetrySentenceCellWithTableView:tableView];
    
    // 2.设置cell
    cell.sentence = self.model.contents[indexPath.row];
    
    // 3.返回cell
    return cell;
}


@end









