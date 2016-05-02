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
#import "WYOptionButton.h"
#import "WYPoemHUD.h"

@interface WYHomeViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate>
/** 底部的bar */
@property (nonatomic, weak) WYButtomBar *buttomBar;

/** 播放tableView */
@property (nonatomic, weak) UITableView *showView;

/** 当前诗歌模型 */
@property (nonatomic, strong) WYPoetryModel *model;

/** 定时器 */
@property (nonatomic, strong) NSTimer *timer;

/** 截图蒙版 */
@property (nonatomic, weak) UIView *clipCoverView;

/** 截图起始位置 */
@property (nonatomic, assign) CGPoint originLocation;

/** 截图图标 */
@property (nonatomic, weak) UIImageView *clipImageView;

/** 选项按钮 */
@property (nonatomic, weak) WYOptionButton *optionBtn;
@end

@implementation WYHomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.设置底部栏
    [self setupButtomBar];
    
    // 2.设置展示view
    [self setupTableView];
    
    // 3.网络数据
    NSInteger index = 34;
    [self loadDataWithIndex:index];
    
    // 4.添加手势
    UILongPressGestureRecognizer *longPressRecognizer = [[UILongPressGestureRecognizer alloc] initWithTarget:self action:@selector(longPress:)];
    [self.view addGestureRecognizer:longPressRecognizer];

    UITapGestureRecognizer *tapRecognizer = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(tap:)];
    [self.view addGestureRecognizer:tapRecognizer];

}

#pragma mark - 懒加载
- (UIView *)clipCoverView{
    if (!_clipCoverView) {
        UIView *clipCoverView = [[UIView alloc] init];
        clipCoverView.backgroundColor = [UIColor blackColor];
        clipCoverView.alpha = 0.15;
        [self.view addSubview:clipCoverView];
        _clipCoverView = clipCoverView;
    }
    return _clipCoverView;
}

- (UIImageView *)clipImageView {
    if (!_clipCoverView) {
        UIImage *clipImage = [UIImage imageNamed:@"Snip20160425_3"];
        UIImageView *clipImageView = [[UIImageView alloc] initWithImage:clipImage];
        [self.view addSubview:clipImageView];
        _clipImageView = clipImageView;
    }
    return _clipImageView;
}

- (WYOptionButton *)optionBtn {
    if (!_optionBtn) {
        WYOptionButton *optionBtn = [WYOptionButton optionButtonWithSaveClik:^{
            WYLog(@"保存...");
            [self saveClipImage];
        } shareClik:^{
            WYLog(@"分享...");
            [self shareClipImage];
        }];
        // 设置宽高
        optionBtn.wy_size = CGSizeMake(50, 20);
        // 设置圆角
        optionBtn.layer.cornerRadius = 5;
        // 设置背景色
        optionBtn.backgroundColor = [UIColor grayColor];
        _optionBtn = optionBtn;
        [self.view addSubview:optionBtn];
        [self.view bringSubviewToFront:optionBtn];
    }
    return _optionBtn;
}

#pragma mark - 设置底部栏
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

#pragma mark - 设置展示的view
- (void)setupTableView {
    // 1.创建view
    UITableView *showTableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStylePlain];
    showTableView.contentInset = UIEdgeInsetsMake(self.view.wy_height * 0.25, 0, 0, 0);
    [showTableView setSeparatorStyle:UITableViewCellSeparatorStyleNone];
    [showTableView setTranslatesAutoresizingMaskIntoConstraints:NO];
    showTableView.showsVerticalScrollIndicator = NO;
    self.showView = showTableView;
    self.showView.backgroundColor = BASECOLOR;
    [self.view addSubview:showTableView];
    
    // 2.布局view
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

#pragma mark -  网络请求
- (void)loadDataWithIndex:(NSInteger)index {
    [WYPoemHUD show];
    // 0.关闭定时器
    [self stopTimer];
    [self.showView setContentOffset:CGPointMake(0, - self.view.wy_height * 0.25)];
    
    // 1.创建请求
    NSURLRequest *request = [[NSURLRequest alloc] initWithURL:URL(index)];
    
    // 2.发起数据请求任务
    [NSURLConnection sendAsynchronousRequest:request queue:[[NSOperationQueue alloc] init] completionHandler:^(NSURLResponse * _Nullable response, NSData * _Nullable data, NSError * _Nullable connectionError) {
        [WYPoemHUD dismiss];
        if (connectionError) { // 连接网络失败
            NSLog(@"网络连接失败:%@", connectionError);
            return ;
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
                dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.0f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                    // 1.开启自动滚动
                    [self startTimer];
                });
            });
        }
    }];
    
}

#pragma mark - 滚动展示视图

/** 开启定时器 */
- (void)startTimer {
    NSTimer *timer = [NSTimer scheduledTimerWithTimeInterval:0.25f target:self selector:@selector(startAutoScroll) userInfo:nil repeats:YES];
    self.timer = timer;
}

/** 关闭定时器 */
- (void)stopTimer {
    [self.timer invalidate];
    self.timer = nil;
}

/** 滚动视图 */
- (void)startAutoScroll {
    BOOL isAutoScroll = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultKeyIsAutoScroll];
    if (!isAutoScroll) return;
    CGFloat offsetY = self.showView.contentOffset.y;
    CGFloat offset = 8;
    if (offsetY > self.showView.contentSize.height) { // 到顶了再重复
        offsetY = 0 - self.view.wy_height * 0.25;
        offset = 0;
        [self.showView setContentOffset:CGPointMake(0, offsetY + offset) animated:NO];
    }else { // 没到顶部则继续滚
        [self.showView setContentOffset:CGPointMake(0, offsetY + offset) animated:YES];
    }
}

#pragma mark - 底部bar的按钮点击

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
    NSInteger index = arc4random_uniform(100);
    [self loadDataWithIndex:index];
}

/** 我的 */
- (void)mine {
    WYLog(@"%s", __func__);
    WYMineTableViewController *settingVc = [[WYMineTableViewController alloc] init];
    WYBaseNavViewController *navVc = [[WYBaseNavViewController alloc] initWithRootViewController:settingVc];
    [self presentViewController:navVc animated:YES completion:nil];

}

#pragma mark - 手势处理
- (void)longPress:(UILongPressGestureRecognizer *)longPressRecognizer {
    WYLog(@"%s==%@", __func__, longPressRecognizer);
    // 1.关闭定时器
    [self stopTimer];
    // 1.1.停止tableview的交互
    [self.showView setUserInteractionEnabled:NO];
    
    // 2.处理手势状态
    switch (longPressRecognizer.state) {
        case UIGestureRecognizerStateBegan:{ // 开始
            // 1.获取位置并记录
            CGPoint location = [longPressRecognizer locationInView:self.view];
            self.originLocation = location;
            
            // 2.添加截图标志
            [self.clipImageView setFrame:CGRectMake(location.x, location.y, 15, 15)];
            break;
        }
        case UIGestureRecognizerStateChanged:{ // 拖拽
            // 1.获取新位置
            CGPoint location = [longPressRecognizer locationInView:self.view];
            
            // 2.设置蒙版
            // 计算frame
            CGFloat w = location.x - self.originLocation.x;
            CGFloat h = location.y - self.originLocation.y;
            self.clipCoverView.frame = CGRectMake(self.originLocation.x, self.originLocation.y, w, h);
            
            // 2.1.设置蒙版样式
            NSInteger row = [[NSUserDefaults standardUserDefaults] integerForKey:UserDefaultKeyClipStyle];
            switch (row) {
                case 0:{ // 蒙版
                    [self.clipCoverView setBackgroundColor:[UIColor blackColor]];
                    break;
                }
                case 1:{ // 实线
                    [self.clipCoverView setBackgroundColor:[UIColor clearColor]];
                    // 1.移除上次蒙版
                    CALayer *lastLayer = [self.clipCoverView.layer.sublayers lastObject];
                    [lastLayer removeFromSuperlayer];
                    // 2.添加线框蒙版
                    [self.clipCoverView addBorderLayerWithColor:[UIColor blackColor] dashDotted:NO];
                    break;
                }
                case 2:{ // 虚线
                    [self.clipCoverView setBackgroundColor:[UIColor clearColor]];
                    // 1.移除上次蒙版
                    CALayer *lastLayer = [self.clipCoverView.layer.sublayers lastObject];
                    [lastLayer removeFromSuperlayer];
                    // 2.添加线框蒙版
                    [self.clipCoverView addBorderLayerWithColor:[UIColor blackColor] dashDotted:YES];
                    break;
                }
            }
            
            // 3.移动截图
            CGRect clipImageViewFrame  = self.clipImageView.frame;
            clipImageViewFrame.origin.x = location.x;
            clipImageViewFrame.origin.y = location.y;
            self.clipImageView.frame = clipImageViewFrame;
            break;
        }
        case UIGestureRecognizerStateEnded:{ // 结束
            // 1.弹出选项
            // 获取结束位置
            CGPoint location = [longPressRecognizer locationInView:self.view];
            self.optionBtn.wy_origin = CGPointMake(location.x - 20, location.y);
            break;
        }
    }
    
    
}

- (void)tap:(UIGestureRecognizer *)pan {
    // 移除截图
    [self.optionBtn removeFromSuperview];
    [self.clipCoverView removeFromSuperview];
    [self.clipImageView removeFromSuperview];
    
    // 开启tableview的交互
    [self.showView setUserInteractionEnabled:YES];
    
    // 开启定时器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startTimer];
    });
}

#pragma mark - 截图和分享
- (void)saveClipImage {
    // 1.关闭定时器
    [self stopTimer];
    // 1.1.停止tableview的交互
    [self.showView setUserInteractionEnabled:NO];
    
    // 1.获取截图
    UIImage *image = [self.view getImageInRect:self.clipCoverView.frame];
    
    // 2.添加水印
    CGFloat x = self.clipCoverView.wy_bottomRight.x - 50;
    CGFloat y = self.clipCoverView.wy_bottomRight.y - 20;
    CGFloat w = 50;
    CGFloat h = 20;
    CGRect rect = CGRectMake(x, y, w, h);
    UIImage *newImage =[image addWaterMark:@"By_暖诗" inRect:rect];
    
    // 2.保存至相册
    UIImageWriteToSavedPhotosAlbum(newImage, self, @selector(imageSavedToPhotosAlbum:didFinishSavingWithError:contextInfo:), nil);
}

- (void)shareClipImage {
    
}

/** 保存相册信息 */
- (void)imageSavedToPhotosAlbum:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo { 
    NSString *message = nil;
    // 开启定时器
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self startTimer];
    });
    
    if (!error) {
        message = @"成功保存到相册";
        [WYPoemHUD showSuccess];
    }else
    {
        [WYPoemHUD showFail];
        message = [error description];
    }
    // 移除截图
    [self.optionBtn removeFromSuperview];
    [self.clipCoverView removeFromSuperview];
    [self.clipImageView removeFromSuperview];
    WYprintf(@"message is %@",message);
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


#pragma mark - UIScrollViewDelegate

/** 停止拖拽 */
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate {
    // 开启定时器
    [self startTimer];
}

/** 即将开始拖拽 */
- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView {
    // 停止定时器
    [self stopTimer];
}



@end









