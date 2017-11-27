//
//  EncodeUtil.h
//  LHL
//
//  Created by LHL on 15/9/6.
//  Copyright (c) 2015年 李红力-易到用车iOS开发工程师. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface EncodeUtil : NSObject

+ (NSString *)getMD5ForStr:(NSString *)str;
+ (UIImage *)convertImage:(UIImage *)origImage scope:(CGFloat)scope;

@end
