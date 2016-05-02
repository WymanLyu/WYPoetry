//
//  WYOptionButton.m
//  WYpoetry
//
//  Created by sialice on 16/5/2.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYOptionButton.h"

@interface WYOptionButton ()

/** 分享按钮 */
@property (nonatomic, weak) UIButton *shareBtn;

/** 保存按钮 */
@property (nonatomic, weak) UIButton *saveBtn;

/** 保存block */
@property (nonatomic, copy) void(^saveClickBlock)(void);
/** 分享block */
@property (nonatomic, copy) void(^shareClickBlock)(void);


@end

@implementation WYOptionButton

- (instancetype)initWithFrame:(CGRect)frame {
    if (self = [super initWithFrame:frame]) {
        // 1.初始化子控件
        [self setupSubs];
        
        // 2.布局子控件
        [self layoutSubs];
    }
    return self;
}

#pragma mark - 初始化方法
- (instancetype)initWithSaveClik:(void(^)(void))saveClickBlock shareClik:(void(^)(void))shareClickBlock {
    if (self = [super init]) {
        self.saveClickBlock = saveClickBlock;
        self.shareClickBlock = shareClickBlock;
    }
    return self;
}

+ (instancetype)optionButtonWithSaveClik:(void(^)(void))saveClickBlock shareClik:(void(^)(void))shareClickBlock {
    return [[self alloc] initWithSaveClik:saveClickBlock shareClik:shareClickBlock];
}


/** 初始化子控件 */
- (void)setupSubs {
    // 1.保存按钮
    UIButton *saveBtn = [[UIButton alloc] init];
    [saveBtn setTitle:@"保存" forState:UIControlStateNormal];
    [saveBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [saveBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [saveBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [saveBtn addTarget:self action:@selector(saveBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:saveBtn];
    self.saveBtn = saveBtn;
//    [saveBtn setBackgroundColor:[UIColor wy_randomColor]];
    
    // 2.分享按钮
    UIButton *shareBtn = [[UIButton alloc] init];
    [shareBtn setTitle:@"分享" forState:UIControlStateNormal];
    [shareBtn.titleLabel setFont:[UIFont systemFontOfSize:10.0f]];
    [shareBtn setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [shareBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateHighlighted];
    [shareBtn addTarget:self action:@selector(shareBtnClick:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:shareBtn];
    self.shareBtn = shareBtn;
//     [saveBtn setBackgroundColor:[UIColor wy_randomColor]];
}

/** 布局子控件 */
- (void)layoutSubs {
    // 保存按钮
    [self.saveBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    [self.shareBtn setTranslatesAutoresizingMaskIntoConstraints:NO];
    NSLayoutConstraint *constraintSaveL = [NSLayoutConstraint constraintWithItem:self.saveBtn
                                                                       attribute:NSLayoutAttributeLeft
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeLeft
                                                                      multiplier:1.0f
                                                                        constant:0];
    NSLayoutConstraint *constraintSaveR = [NSLayoutConstraint constraintWithItem:self.saveBtn
                                                                       attribute:NSLayoutAttributeRight
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeRight
                                                                      multiplier:0.5f
                                                                        constant:0];
    NSLayoutConstraint *constraintSaveT = [NSLayoutConstraint constraintWithItem:self.saveBtn
                                                                       attribute:NSLayoutAttributeTop
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeTop
                                                                      multiplier:1.0f
                                                                        constant:0];
    NSLayoutConstraint *constraintSaveB = [NSLayoutConstraint constraintWithItem:self.saveBtn
                                                                       attribute:NSLayoutAttributeBottom
                                                                       relatedBy:NSLayoutRelationEqual
                                                                          toItem:self
                                                                       attribute:NSLayoutAttributeBottom
                                                                      multiplier:1.0f
                                                                        constant:0];
    
    // 分享按钮
    NSLayoutConstraint *constraintShareL = [NSLayoutConstraint constraintWithItem:self.shareBtn
                                                                        attribute:NSLayoutAttributeLeading
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self.saveBtn
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:1.0f
                                                                         constant:0];
    NSLayoutConstraint *constraintShareR = [NSLayoutConstraint constraintWithItem:self.shareBtn
                                                                        attribute:NSLayoutAttributeTrailing
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeTrailing
                                                                       multiplier:1.0f
                                                                    constant:0];
    NSLayoutConstraint *constraintShareT = [NSLayoutConstraint constraintWithItem:self.shareBtn
                                                                        attribute:NSLayoutAttributeTop
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeTop
                                                                       multiplier:1.0f
                                                                         constant:0];
    NSLayoutConstraint *constraintShareB = [NSLayoutConstraint constraintWithItem:self.shareBtn
                                                                        attribute:NSLayoutAttributeBottom
                                                                        relatedBy:NSLayoutRelationEqual
                                                                           toItem:self
                                                                        attribute:NSLayoutAttributeBottom
                                                                       multiplier:1.0f
                                                                         constant:0];

//    [NSLayoutConstraint activateConstraints:@[constraintSaveL, constraintSaveR, constraintSaveT, constraintSaveB, constraintShareL, constraintShareR, constraintShareT, constraintShareB]];
//    constraintSaveB.active = YES;
//    constraintSaveR.active = YES;
//    constraintSaveT.active = YES;
//    constraintSaveL.active = YES;
//    
//    constraintShareB.active = YES;
//    constraintShareR.active = YES;
//    constraintShareT.active = YES;
//    constraintShareL.active = YES;
    [self addConstraints:@[constraintSaveL, constraintSaveR, constraintSaveT, constraintSaveB, constraintShareL, constraintShareR, constraintShareT, constraintShareB]];
    
}

#pragma mark - 按钮点击事件
- (void)saveBtnClick:(UIButton *)btn {
    if (self.saveClickBlock) {
        self.saveClickBlock();
    }
}

- (void)shareBtnClick:(UIButton *)btn {
    if (self.shareClickBlock) {
        self.shareClickBlock();
    }
    
}


@end
