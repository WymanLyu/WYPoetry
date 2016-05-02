//
//  WYSettingTableViewController.m
//  WYpoetry
//
//  Created by sialice on 16/4/27.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYSettingTableViewController.h"

/** 蒙版截图样式 */
typedef NS_ENUM(NSUInteger, ClipStyle) {
    ClipStyleCoverStyle = 0,
    ClipStyleDashLineStyle = 1,
    ClipStyleStraightLineStyle = 2,
};

@interface WYSettingTableViewController ()

/** cell的描述数组 */
@property (nonatomic, strong) NSArray *textArray;

/** 选中的cell */
@property (nonatomic, weak) UITableViewCell *selectedCell;

/** 自动播放 */
@property (nonatomic, weak) UISwitch *autoPlay;

/** 夜间模式 */
@property (nonatomic, weak) UISwitch *moonState;

@end

@implementation WYSettingTableViewController

- (void)loadView {
    UITableView *tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
    self.view = tableView;
    tableView.delegate = self;
    tableView.dataSource = self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // 1.设置背景色
    [self.view setBackgroundColor:BASECOLOR];
    
    // 2.设置navBar
    self.title = @"设置";
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(dismissVc)];
    [self.navigationItem.leftBarButtonItem setTintColor:[UIColor blackColor]];
    
    // 3.设置分割线
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.sectionHeaderHeight = 0;
}

/** 懒加载 */
- (NSArray *)textArray {
    if (_textArray == nil) {
        _textArray = @[@[@"自动播放"], @[@"夜间模式"], @[@"灰色截图框", @"实线截图框", @"虚线截图框"]];
    }
    return _textArray;
}

/** 返回 */
- (void)dismissVc {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - Table view data source

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    if (section == (self.textArray.count - 1)) {
        return @"截图样式";
    }else {
        return nil;
    }
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.textArray.count;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    NSArray *contentArr = self.textArray[section];
    return contentArr.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 1.创建静态cell
    static NSString *ID = @"SettingCell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
        // 2.创建accessoryView
        if (indexPath.section == 0) { // 自动播放
            UISwitch *autoPlay = [[UISwitch alloc] init];
            [autoPlay addTarget:self action:@selector(autoPlay:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = autoPlay;
            self.autoPlay = autoPlay;
        }else if(indexPath.section == 1) { // 夜间模式
            UISwitch *moonState = [[UISwitch alloc] init];
            [moonState addTarget:self action:@selector(moonState:) forControlEvents:UIControlEventValueChanged];
            cell.accessoryView = moonState;
            self.moonState = moonState;
        }else { // 蒙版样式
            cell.accessoryView = nil;
        }
    }
    
    // 2.设置cell状态
    if (indexPath.section == 0) { // 自动播放
        BOOL autoPlay = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultKeyIsAutoScroll];
        self.autoPlay.on = autoPlay;
    }else if(indexPath.section == 1) { // 夜间模式
        BOOL moonState = [[NSUserDefaults standardUserDefaults] boolForKey:UserDefaultKeyIsMoonState];
        self.moonState.on = moonState;
    }else { // 蒙版样式
        NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
        NSInteger clipStyle = [defaults integerForKey:UserDefaultKeyClipStyle];
        if (indexPath.row == clipStyle) {
            cell.accessoryType = UITableViewCellAccessoryCheckmark;
        }else {
            cell.accessoryType = UITableViewCellAccessoryNone;
        }
    }
    
    // 3.设置cell内容
    NSArray *contentArr = self.textArray[indexPath.section];
    cell.textLabel.text = contentArr[indexPath.row];
    
    return cell;
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
    if (indexPath.section == (self.textArray.count - 1)) { // 蒙版样式选择
        // 1.标记选中
        self.selectedCell = cell;
        
        // 2.刷新表格
        [self.tableView reloadData];
    }
    
}

#pragma mark - 偏好设置按钮
/** 自动播放 */
- (void)autoPlay:(UISwitch *)autoPlay {
    // 记录状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:autoPlay.isOn forKey:UserDefaultKeyIsAutoScroll];
    [defaults synchronize];
}

/** 夜间模式 */
- (void)moonState:(UISwitch *)moonState {
    // 记录状态
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    [defaults setBool:moonState.isOn forKey:UserDefaultKeyIsMoonState];
    [defaults synchronize];
}

/** 设置选中cell */
- (void)setSelectedCell:(UITableViewCell *)selectedCell {
    if (_selectedCell == selectedCell) return; // 过滤相同的
    _selectedCell = selectedCell;
    
    // 3.记录偏好设置
    NSUserDefaults *defaults = [NSUserDefaults standardUserDefaults];
    NSIndexPath *indexPath = [self.tableView indexPathForCell:selectedCell];
    [defaults setInteger:indexPath.row forKey:UserDefaultKeyClipStyle];
    [defaults synchronize];
    
}



@end
