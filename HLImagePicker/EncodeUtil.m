//
//  EncodeUtil.m
//  mcare-core
//
//  Created by sam on 12-9-25.
//  Copyright (c) 2012年 __MyCompanyName__. All rights reserved.
//

#import "EncodeUtil.h"
#import <CommonCrypto/CommonDigest.h>

@implementation EncodeUtil

+ (NSString *)getMD5ForStr:(NSString *)str
{
    const char *ptr = [str UTF8String];
    // Create byte array of unsigned chars
    unsigned char md5Buffer[CC_MD5_DIGEST_LENGTH];
    
    // Create 16 byte MD5 hash value, store in buffer
    CC_MD5(ptr, strlen(ptr), md5Buffer);
    
    // Convert MD5 value in the buffer to NSString of hex values
    NSMutableString *output = [NSMutableString stringWithCapacity:CC_MD5_DIGEST_LENGTH * 2];
    for(int i = 0; i < CC_MD5_DIGEST_LENGTH; i++) 
        [output appendFormat:@"%02x",md5Buffer[i]];
    return output;
}

+ (UIImage *)convertImage:(UIImage *)origImage scope:(CGFloat)scope
{
    UIImage *image = nil;
    CGSize size = origImage.size;
    if (size.width < scope && size.height < scope) {
        // do nothing
        image = origImage;
    } else {
        CGFloat length = size.width;
        if (size.width < size.height) {
            length = size.height;
        }
        CGFloat f = scope/length;
        NSInteger nw = size.width * f;
        NSInteger nh = size.height * f;
        if (nw > scope) {
            nw = scope;
        }
        if (nh > scope) {
            nh = scope;
        }

        CGSize newSize = CGSizeMake(nw, nh);
//        CGSize newSize = CGSizeMake(size.width*f, size.height*f);
        
        //
        UIGraphicsBeginImageContext(newSize);
        //UIGraphicsBeginImageContextWithOptions(newSize, NO, 0.0f);
        // Tell the old image to draw in this new context, with the desired
        // new size 
        [origImage drawInRect:CGRectMake(0, 0, newSize.width, newSize.height)]; 
        // Get the new image from the context 
        image = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext(); 
    }
    return image;
}

@end
