//
//  WYButtomBar.m
//  WYpoetry
//
//  Created by sialice on 16/4/26.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import "WYButtomBar.h"

@interface WYButtomBar ()

@property (nonatomic, copy) void(^clickBlok)(NSInteger);

@end

@implementation WYButtomBar



- (void)layoutSubviews {
    [super layoutSubviews];
    WYLog(@"%d", self.items.count);
    CGFloat itemWidth = self.wy_width / self.items.count;
    for (int i = 0; i < self.items.count; i++) {
        UIBarButtonItem *subItem = self.items[i];
        [subItem setWidth:itemWidth];
    }
    
}

@end







