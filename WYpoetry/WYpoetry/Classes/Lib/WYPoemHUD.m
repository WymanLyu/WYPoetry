//
//  WYPoemHUD.m
//  WYpoetry
//
//  Created by sialice on 16/5/2.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYPoemHUD.h"
#import "WYProgressView.h"
#import "WYSuccessView.h"
#import "WYFailView.h"

@interface WYPoemHUD ()

/** 图片 */
@property (nonatomic, weak) WYProgressView *progressView;

/** 定时器 */
@property (nonatomic, strong) CADisplayLink *link;
@end

@implementation WYPoemHUD

+ (instancetype)shareView {
    static dispatch_once_t once;
    static WYPoemHUD *sharedView;
    dispatch_once(&once, ^{
        // 创建Hud
        sharedView = [[self alloc] initWithFrame:[[[UIApplication sharedApplication] delegate] window].bounds];
      
        // 2.设置背景色
        [sharedView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
//        [sharedView setBackgroundColor:[UIColor colorWithRed:166/255.0 green:166/255.0 blue:166/255.0 alpha:0.5]];
        
    });

    return sharedView;
}

+ (void)show {
    WYPoemHUD *hud = [self shareView];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    hud.alpha = 0.8;
    dispatch_async(dispatch_get_main_queue(), ^{
        [window addSubview:hud];
        // 2.创建progressView
        WYProgressView *progressView = [[WYProgressView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        progressView.center = hud.center;
        [hud addSubview:progressView];
        progressView.backgroundColor = [UIColor clearColor];
        hud.progressView = progressView;
        hud.progressView.progress = 3.0; // 不进行重绘动画
#warning 不进行重绘动画
//        CADisplayLink *link = [CADisplayLink displayLinkWithTarget:hud selector:@selector(addProgress)];
//        hud.link = link;
//        [link addToRunLoop:[NSRunLoop currentRunLoop] forMode:NSDefaultRunLoopMode];
        // 旋转动画
        CABasicAnimation *baseAnimation = [CABasicAnimation animation];
        baseAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        baseAnimation.duration = 1.0f;        
        baseAnimation.repeatCount = MAXFLOAT;
        [hud.progressView.layer addAnimation:baseAnimation forKey:@"transform.rotation.z"];
     
    });

}

/* 重绘动画 */
static BOOL isAnimating = NO;
- (void)addProgress {
//    self.progress += 0.001;
    self.progressView.progress = self.progressView.progress + 0.1;
    if (self.progressView.progress > 3) {
        if (isAnimating) return;
        isAnimating = YES;
        CABasicAnimation *baseAnimation = [CABasicAnimation animation];
        baseAnimation.toValue = [NSNumber numberWithFloat: M_PI * 2.0 ];
        baseAnimation.duration = 1.0f;

        baseAnimation.repeatCount = MAXFLOAT;
        [self.progressView.layer addAnimation:baseAnimation forKey:@"transform.rotation.z"];
    }
}

+ (void)dismiss {
    WYPoemHUD *hud = [self shareView];
   
    dispatch_async(dispatch_get_main_queue(), ^{
        [UIView animateWithDuration:0.05 animations:^{
            hud.alpha = 0;
        }completion:^(BOOL finished) {
            [hud.progressView.layer removeAllAnimations];
            [hud.subviews makeObjectsPerformSelector:@selector(removeFromSuperview)];
//            [hud.progressView removeFromSuperview];
            hud.progressView = nil;
            [hud removeFromSuperview];
        }];
    });
}

+ (void)showSuccess {
    WYPoemHUD *hud = [self shareView];
    hud.alpha = 1.0;
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
    dispatch_async(dispatch_get_main_queue(), ^{
        [window addSubview:hud];
        // 创建successView
        WYSuccessView *successView = [[WYSuccessView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        successView.center = hud.center;
        [hud addSubview:successView];
        [successView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
        successView.layer.cornerRadius = 8;
        successView.layer.masksToBounds = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
        
    });
}

+ (void)showFail {
    WYPoemHUD *hud = [self shareView];
    UIWindow *window = [[[UIApplication sharedApplication] delegate] window];
     hud.alpha = 1.0;
    dispatch_async(dispatch_get_main_queue(), ^{
         [window addSubview:hud];
        // 创建successView
        WYFailView *failView = [[WYFailView alloc] initWithFrame:CGRectMake(0, 0, 100, 100)];
        failView.center = hud.center;
        [hud addSubview:failView];
        [failView setBackgroundColor:[[UIColor grayColor] colorWithAlphaComponent:0.5]];
        failView.layer.cornerRadius = 8;
        failView.layer.masksToBounds = YES;
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1.25f * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self dismiss];
        });
        
    });

}


@end
