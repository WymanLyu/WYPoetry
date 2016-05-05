//
//  WYTableHeadView.m
//  WYpoetry
//
//  Created by sialice on 16/5/4.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYTableHeadView.h"
#import "WYPoetryModel.h"

@interface WYTableHeadView ()

/** 诗名 */
@property (nonatomic, weak) UILabel *titleLbl;

/** 作者 */
@property (nonatomic, weak) UILabel *artistLbl;

@end

@implementation WYTableHeadView

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        [self setupSubs];
    }
    return self;
}

- (void)setupSubs {
    // lable
    UILabel *titleLbl = [[UILabel alloc] init];
    self.titleLbl = titleLbl;
    titleLbl.font = [UIFont boldSystemFontOfSize:20.0f];
    titleLbl.textColor = [[UIColor blackColor] colorWithAlphaComponent:0.6];
    titleLbl.textAlignment = NSTextAlignmentCenter;
    [self addSubview:titleLbl];
    titleLbl.backgroundColor = BASECOLOR;
    
    // lable
    UILabel *artistLbl = [[UILabel alloc] init];
    self.artistLbl = artistLbl;
    artistLbl.font = [UIFont italicSystemFontOfSize:12.0f];
    [artistLbl setTextColor:[[UIColor grayColor] colorWithAlphaComponent:0.6]];
    artistLbl.textAlignment = NSTextAlignmentRight;
    [self addSubview:artistLbl];
    artistLbl.backgroundColor = BASECOLOR;
}

- (void)layoutSubviews {
    [super layoutSubviews];
    CGSize size = self.frame.size;
    self.titleLbl.frame = CGRectMake(0, 0, size.width, size.height * 0.75);
    self.artistLbl.frame = CGRectMake(0, size.height * 0.75, size.width, size.height * 0.25);
    
}

- (void)setModel:(WYPoetryModel *)model {
    _model = model;
    self.titleLbl.text = model.title;
    self.artistLbl.text = [NSString stringWithFormat:@"By  %@", model.artist];
}

@end
