//
//  EncodeUtil.h
//  mcare-core
//
//  Created by sam on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface EncodeUtil : NSObject

+ (NSString *)getMD5ForStr:(NSString *)str;
+ (UIImage *)convertImage:(UIImage *)origImage scope:(CGFloat)scope;

@end
