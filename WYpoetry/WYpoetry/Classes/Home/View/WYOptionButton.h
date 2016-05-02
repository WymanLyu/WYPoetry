//
//  WYOptionButton.h
//  WYpoetry
//
//  Created by sialice on 16/5/2.
//  Copyright © 2016年 wyman. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface WYOptionButton : UIView

- (instancetype)initWithSaveClik:(void(^)(void))saveClickBlock shareClik:(void(^)(void))shareClickBlock;

+ (instancetype)optionButtonWithSaveClik:(void(^)(void))saveClickBlock shareClik:(void(^)(void))shareClickBlock;

@end
