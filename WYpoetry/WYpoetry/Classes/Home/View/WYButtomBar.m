//
//  WYButtomBar.m
//  WYpoetry
//
//  Created by sialice on 16/4/26.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYButtomBar.h"

@interface WYButtomBar ()
/** 按钮数组 */
@property (nonatomic, strong) NSArray <WYButtomBarButton *>*btnArrM;
/** 分割线 */
@property (nonatomic, weak) UIView *separateLine;

@end

@implementation WYButtomBar

- (instancetype)initWithFrame:(CGRect)frame {
    if (self =[super initWithFrame:frame]) {
        
        // 分割线
        UIView *separateLine = [[UIView alloc] init];
        [separateLine setBackgroundColor:[UIColor blackColor]];
        [separateLine setAlpha:0.2f];
        self.separateLine = separateLine;
        [self addSubview:separateLine];
 
    }
    return self;
}

/** 初始化 */
- (instancetype)initWithButtomBarButtonArray:(NSArray<WYButtomBarButton *> *)btnArray {
    if (self = [super init]) {
        self.btnArrM = btnArray;
    }
    return self;
}

+ (instancetype)buttomBarWithButtomBarButtonArray:(NSArray<WYButtomBarButton *> *)btnArray {
    return [[self alloc] initWithButtomBarButtonArray:btnArray];
}


/** 布局子控件 */
- (void)layoutSubviews {
    [super layoutSubviews];
    
    // 1.布局子按钮
    NSInteger btnCount = self.btnArrM.count;
    for (int i; i < btnCount; i++) {
        WYButtomBarButton *btn = self.btnArrM[i];
        CGFloat btnW = self.wy_width / btnCount;
        CGFloat btnH = self.wy_height;
        CGFloat btnX = btnW * i;
        CGFloat btnY = 0;
        [btn setFrame:CGRectMake(btnX, btnY, btnW, btnH)];
    }
    
    // 2.布局分割线
    [self.separateLine setFrame:CGRectMake(0, 0, self.wy_width, 1)];

    
}

- (void)setBtnArrM:(NSArray<WYButtomBarButton *> *)btnArrM {
    _btnArrM = btnArrM;
    for (WYButtomBarButton *btn in btnArrM) {
        [self addSubview:btn];
    }
    [self setNeedsLayout];
}

@end



@interface WYButtomBarButton ()
/** 按钮 */
@property (nonatomic, weak) UIButton *subBtn;
@end
@implementation WYButtomBarButton

- (instancetype)init {
    if (self = [super init]) {
//        NSAssert(NO, @"请调用initWithImageName:style:target:action:方法创建!");
        // 1.创建异常
        NSException *exc = [NSException exceptionWithName:@"初始化错误" reason:@"请使用initWithImageName:style:target:action:方法创建,需要指定style." userInfo:nil];
        // 2.抛出异常
        [exc raise];
    }
    return self;
}

- (instancetype)initWithImageName:(NSString *)imageName style:(WYButtomBarButtonStyle)style target:(id)target action:(SEL)action {
    return [self initWithImageName:imageName selectedImageName:imageName style:style target:target action:action] ;
}

- (instancetype)initWithImageName:(nullable NSString *)imageName selectedImageName:(nullable NSString *)selectedImageName style:(WYButtomBarButtonStyle)style target:(nullable id)target action:(nullable SEL)action {
    if (self = [super initWithFrame:CGRectZero]) {
        switch (style) {
            case WYButtomBarButtonStylePlaceHolder: { // 占位view
                self.userInteractionEnabled = NO;
            }
            case WYButtomBarButtonStylePlain: { // 普通按钮
                UIButton *btn = [[UIButton alloc] init];
                [btn setBackgroundImage:[UIImage imageNamed:imageName] forState:UIControlStateNormal];
                [btn setBackgroundImage:[UIImage imageNamed:selectedImageName] forState:UIControlStateSelected];
                // 设置监听
                [btn addTarget:target action:action forControlEvents:UIControlEventTouchUpInside];
                // 设置在中心
                btn.autoresizingMask = UIViewAutoresizingFlexibleLeftMargin | UIViewAutoresizingFlexibleRightMargin | UIViewAutoresizingFlexibleTopMargin | UIViewAutoresizingFlexibleBottomMargin;
                [btn sizeToFit];
                [self addSubview:btn];
                self.subBtn = btn;
            }
        }
    }
    return self;
}


- (void)setSelected:(BOOL)selected {
    _selected = selected;
    self.subBtn.selected = selected;
}


@end

























