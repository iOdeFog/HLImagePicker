//
//  HLImagePicker.h
//  LHL
//
//  Created by LHL on 15/9/6.
//  Copyright (c) 2015年 李红力-易到用车iOS开发工程师. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_MAXIMUM_BYTES 1024000.0f   // 1024000 = 1000 * 1024 bytes

@protocol HLImagePickerDelegate <NSObject>

@optional

// saveDocument = YES 时生效
- (void)setViewPhoto:(NSString *)path sender:(id)sender;
- (void)setViewPhotoInfo:(NSDictionary *)path sender:(id)sender;


- (void)setViewImageData:(NSData *)imageData;

@end

@interface HLImagePicker : NSObject <UIImagePickerControllerDelegate, UIActionSheetDelegate, UINavigationControllerDelegate,UIPopoverControllerDelegate, HLImagePickerDelegate> {
    UIImagePickerController *pickerController;
    UIViewController *pController;
    id tapSender;
    BOOL toCut;
    BOOL saveDocument;
}

@property (nonatomic, weak) id delegate;
@property (nonatomic, assign) BOOL toCut;  
@property (strong,nonatomic) UIPopoverController * popoverViewControl;


- (void)reset;

- (void)tap:(id)delegate inView:(UIView *)view inController:(UIViewController *)controller toCut:(BOOL)to_Cut saveDocument:(BOOL)save;

/*
 *	@brief	压缩图片 @Fire
 *
 *	@param 	originImage 	原始图片
 *	@param 	pc 	是否进行像素压缩
 *	@param 	maxPixel 	压缩后长和宽的最大像素；pc=NO时，此参数无效。
 *	@param 	jc 	是否进行JPEG压缩
 *	@param 	maxKB 	图片最大体积，以KB为单位；jc=NO时，此参数无效。
 *
 *	@return	返回图片的NSData
 */
- (NSData*) compressImage:(UIImage*)originImage PixelCompress:(BOOL)pc MaxPixel:(CGFloat)maxPixel JPEGCompress:(BOOL)jc MaxSize_KB:(CGFloat)maxKB;

@end
