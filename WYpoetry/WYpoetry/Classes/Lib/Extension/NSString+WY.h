//
//  NSString+Extension.h
//  03-25WYSlideView
//
//  Created by sialice on 16/4/1.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>

@interface NSString (WY)

/** 获取自适应宽度 */
- (CGRect)wy_getSize;

/** 获取文件类型 */
- (NSString *)wy_getMIMEType;
@end
