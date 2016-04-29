//
//  WYPoetrySentenceCell.h
//  WYpoetry
//
//  Created by sialice on 16/4/29.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@class WYPoetryModel;
@interface WYPoetrySentenceCell : UITableViewCell

/** 诗句 */
@property (nonatomic, strong) NSString *sentence;

+ (instancetype)poetrySentenceCellWithTableView:(UITableView *)tableView;
@end
