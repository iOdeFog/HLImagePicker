//
//  HLImagePicker.h
//  LHL
//
//  Created by LHL on 15/9/6.
//  Copyright (c) 2015年 李红力. All rights reserved.
//

#import <UIKit/UIKit.h>

#define IMAGE_MAXIMUM_BYTES 1024000.0f   // 1024000 = 1000 * 1024 bytes

typedef enum : NSUInteger {
    HLImagePicker_Camera,
    HLImagePicker_Libray,
} HLImagePickerType;


typedef void(^mm)(NSString *s);
typedef void(^PikerImageBlock)(UIImage *image, id picker);
typedef void(^PikerDataBlock)(NSData *data, id picker);

@interface HLImagePicker : NSObject

@property (nonatomic, copy) PikerImageBlock imageBlock;
@property (nonatomic, copy) PikerDataBlock dataBlock;
@property (nonatomic, assign) BOOL operationOriginImage;
@property (nonatomic, assign) BOOL pixelCompress;
@property (nonatomic, assign) CGFloat maxPixel;
@property (nonatomic, assign) BOOL jpegCompress;
@property (nonatomic, assign) CGFloat maxSize_KB;

@property (nonatomic, assign) BOOL isShowing ;
@property (nonatomic, assign) BOOL allowsEditing;
// 使用自定义拍摄界面
/**
 * 建议pad 只支持 系统原生播放器。因为自定义图片会拉大。 也就是pad useAVSessionImagePiker=NO;
 */
@property (nonatomic, assign) BOOL useAVSessionImagePiker;

+ (instancetype)shareInstanced;




+ (UIViewController *)topViewController;

/**
 *  回调代理
 *  是否进行裁剪压缩
 *  最大像素尺寸。如果设置为0，则默认为maxPixel
 */
+ (HLImagePicker *)showPickerImageBlock:(PikerImageBlock)imageBlock
                              dataBlock:(PikerDataBlock)dataBlock;



/*
 *  @param  originImage    处理原始图片 默认为NO
 *    @param     pixelCompress     是否进行像素压缩
 *    @param     maxPixel     压缩后长和宽的最大像素；pixelCompress=NO时，此参数无效。
 *    @param     jpegCompress     是否进行JPEG压缩,jpeg 压缩会更肖
 *    @param     maxKB     图片最大体积，以KB为单位；jpegCompress=NO时，此参数无效。
 *
 */
+ (HLImagePicker *)showPickerOriginImage:(BOOL)originImage
                           pixelCompress:(BOOL)pixelCompress
                                maxPixel:(CGFloat)maxPixel
                            jpegCompress:(BOOL)jpegCompress
                              maxSize_KB:(CGFloat)maxSize_KB
                              ImageBlock:(PikerImageBlock)imageBlock
                               dataBlock:(PikerDataBlock)dataBlock;



/*
 *    @brief    压缩图片 @Fire
 *
 *    @param     originImage     原始图片
 *    @param     pixelCompress     是否进行像素压缩
 *    @param     maxPixel     压缩后长和宽的最大像素；pixelCompress=NO时，此参数无效。
 *    @param     jpegCompress     是否进行JPEG压缩,jpeg 压缩会更肖
 *    @param     maxKB     图片最大体积，以KB为单位；jpegCompress=NO时，此参数无效。
 *
 *    @return    返回图片的NSData
 */
- (NSData*)compressImage:(UIImage*)originImage
           pixelCompress:(BOOL)pixelCompress
                maxPixel:(CGFloat)maxPixel
            jpegCompress:(BOOL)jpegCompress
              maxSize_KB:(CGFloat)maxSize_KB;


- (void)selectPhotoPickerType:(HLImagePickerType)imagePickerType;
- (void)showActionSheet;


@end



