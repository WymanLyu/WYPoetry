//
//  WYPoetrySentenceCell.m
//  WYpoetry
//
//  Created by sialice on 16/4/29.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYPoetrySentenceCell.h"

@interface WYPoetrySentenceCell ()

/** 显示诗句label */
@property (nonatomic, weak) UILabel *sentenceLabel;

@end

@implementation WYPoetrySentenceCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier {
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self.backgroundColor = BASECOLOR;
        
        // 1.初始化子控件
        [self setupSubs];
        
        // 2.布局子控件
        [self layoutSubs];
    }
    return self;
}

+ (instancetype)poetrySentenceCellWithTableView:(UITableView *)tableView {
    static NSString *ID = @"CELL";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ID];
    if (!cell) {
        cell = [[WYPoetrySentenceCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:ID];
        cell.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return cell;
}

/** 初始化子控件 */
- (void)setupSubs {
    // 初始化Lable
    UILabel *label = [[UILabel alloc] init];
    self.sentenceLabel = label;
    [self.contentView addSubview:self.sentenceLabel];
    
    // 基本设置
    label.textAlignment = NSTextAlignmentCenter;
    label.textColor = [UIColor grayColor];
}

/** 布局子控件 */
- (void)layoutSubs {
    [self.sentenceLabel setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraintL = [NSLayoutConstraint constraintWithItem:self.sentenceLabel
                                                                         attribute:NSLayoutAttributeLeading
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeLeading
                                                                        multiplier:1.0f
                                                                          constant:0];
    NSLayoutConstraint *constraintR = [NSLayoutConstraint constraintWithItem:self.sentenceLabel
                                                                         attribute:NSLayoutAttributeTrailing
                                                                         relatedBy:NSLayoutRelationEqual
                                                                            toItem:self.contentView
                                                                         attribute:NSLayoutAttributeTrailing
                                                                        multiplier:1.0f
                                                                          constant:0];
    NSLayoutConstraint *constraintT = [NSLayoutConstraint constraintWithItem:self.sentenceLabel
                                                                  attribute:NSLayoutAttributeTop
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.contentView
                                                                  attribute:NSLayoutAttributeTop
                                                                 multiplier:1.0f
                                                                   constant:0];
    NSLayoutConstraint *constraintB = [NSLayoutConstraint constraintWithItem:self.sentenceLabel
                                                                  attribute:NSLayoutAttributeBottom
                                                                  relatedBy:NSLayoutRelationEqual
                                                                     toItem:self.contentView
                                                                  attribute:NSLayoutAttributeBottom
                                                                 multiplier:1.0f
                                                                   constant:0];
    [self.contentView addConstraints:@[constraintL, constraintR, constraintT, constraintB]];
}

/** 诗句set方法 */
- (void)setSentence:(NSString *)sentence {
    _sentence = sentence;
    self.sentenceLabel.text = sentence;
}

@end
