//
//  NSString+Extension.m
//  03-25WYSlideView
//
//  Created by sialice on 16/4/1.
//  Copyright © 2016年 sialice. All rights reserved.
//

#import "NSString+WY.h"


@implementation NSString (WY)

- (CGRect)wy_getSize {
    CGSize textMaxSize = CGSizeMake([UIScreen mainScreen].bounds.size.width, MAXFLOAT);
    NSDictionary *textFontDict = @{NSFontAttributeName:[UIFont systemFontOfSize:17.0f]};
    CGRect textContentRect = [self boundingRectWithSize:textMaxSize options:NSStringDrawingUsesLineFragmentOrigin attributes:textFontDict context:nil];
    return textContentRect;
}

// 给定文件路径判断文件类型
- (NSString *)wy_getMIMEType
{
    NSURLRequest *request = [NSURLRequest requestWithURL:[NSURL fileURLWithPath:self]];
    NSURLResponse *response = nil;
    [NSURLConnection sendSynchronousRequest:request returningResponse:&response error:nil];
    return response.MIMEType;
}

@end
