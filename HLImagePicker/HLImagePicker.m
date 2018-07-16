//
//  HLImagePicker.m
//  LHL
//
//  Created by LHL on 15/9/6.
//  Copyright (c) 2015年 李红力. All rights reserved.
//

#import "HLImagePicker.h"
#import "EncodeUtil.h"
#import "HLAVImagePickerController.h"


@interface HLImagePickerController : UIImagePickerController

@end


@implementation HLImagePickerController

-(BOOL)shouldAutorotate{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return NO;
    }
    return YES;
}

- (UIInterfaceOrientationMask)supportedInterfaceOrientations{
    if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
        return UIInterfaceOrientationMaskPortrait;
    }
    return UIInterfaceOrientationMaskAll;
}

-(UIInterfaceOrientation) preferredInterfaceOrientationForPresentation{
    return [self.topViewController preferredInterfaceOrientationForPresentation];
}


@end


#pragma mark ---



@interface HLImagePicker()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>

@end

@implementation HLImagePicker

static HLImagePicker *picker = nil;
static dispatch_once_t onceToken;

+ (instancetype)shareInstanced{
    dispatch_once(&onceToken, ^{
        if (!picker) {
            picker = [[[self class] alloc] init];
        }
    });
    return picker;
}

- (instancetype)init{
    if (self = [super init]) {
        self.operationOriginImage = NO;
    }
    return self;
}

- (void)showActionSheet{
    if (self.isShowing || [[self.class topViewController] isKindOfClass:[UIAlertController class]]) {
        return;
    }
    self.isShowing = YES;
    
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
    UIAlertAction *cameraAction = [UIAlertAction actionWithTitle:@"拍摄" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.isShowing = NO;
        [self selectPhotoPickerType:HLImagePicker_Camera];
    }];
    UIAlertAction *photoAction = [UIAlertAction actionWithTitle:@"手机相册选择" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        self.isShowing = NO;
        [self selectPhotoPickerType:HLImagePicker_Libray];
    }];
    UIAlertAction *cancelAction = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:^(UIAlertAction * _Nonnull action) {
        self.isShowing = NO;
    }];
    
    [alertController addAction:cameraAction];
    [alertController addAction:photoAction];
    [alertController addAction:cancelAction];
    
    UIPopoverPresentationController *popover = alertController.popoverPresentationController;
    if (popover) {
        popover.sourceView = [HLImagePicker topViewController].view;
        popover.sourceRect = CGRectMake(CGRectGetWidth([HLImagePicker topViewController].view.bounds)/2 - 200, CGRectGetHeight([HLImagePicker topViewController].view.bounds)/2 - 100, 100, 100);
        popover.permittedArrowDirections = UIPopoverArrowDirectionAny;
    }
    
    [[HLImagePicker topViewController] presentViewController:alertController animated:YES completion:nil];
}

+ (UIViewController *)topViewController {
    UIViewController *rootViewController = [UIApplication sharedApplication].keyWindow.rootViewController;
    return [self.class topViewController:rootViewController];
}

+ (UIViewController *)topViewController:(UIViewController *)viewController {
    if (viewController.presentedViewController) {
        return [self topViewController:viewController.presentedViewController];
        
    } else if([viewController isKindOfClass:UINavigationController.class]) {
        UINavigationController *navigationController = (UINavigationController *) viewController;
        return [self topViewController:navigationController.visibleViewController];
        
    } else if([viewController isKindOfClass:UITabBarController.class]) {
        UITabBarController *tabBarController = (UITabBarController *)viewController;
        return [self topViewController:tabBarController.selectedViewController];
        
    } else {
        return viewController;
    }
}


+ (HLImagePicker *)showPickerImageBlock:(PikerImageBlock)imageBlock
                              dataBlock:(PikerDataBlock)dataBlock
{
    return [HLImagePicker showPickerOriginImage:NO pixelCompress:NO maxPixel:MAXFLOAT jpegCompress:YES maxSize:MAXFLOAT ImageBlock:imageBlock dataBlock:dataBlock];
}

+ (HLImagePicker *)showPickerJpegMaxSize:(CGFloat)maxSize
                               ImageBlock:(PikerImageBlock)imageBlock
                                dataBlock:(PikerDataBlock)dataBlock
{
    return [HLImagePicker showPickerOriginImage:NO
                                  pixelCompress:NO
                                       maxPixel:0
                                   jpegCompress:YES
                                     maxSize:maxSize
                                     ImageBlock:imageBlock
                                      dataBlock:dataBlock];
}


+ (HLImagePicker *)showPickerMaxPixel:(CGFloat)maxPixel
                           ImageBlock:(PikerImageBlock)imageBlock
                            dataBlock:(PikerDataBlock)dataBlock
{
    return [HLImagePicker showPickerOriginImage:NO
                                  pixelCompress:YES
                                       maxPixel:maxPixel
                                   jpegCompress:NO
                                     maxSize:0
                                     ImageBlock:imageBlock
                                      dataBlock:dataBlock];
}


+ (HLImagePicker *)showPickerOriginImage:(BOOL)originImage
                           pixelCompress:(BOOL)pixelCompress
                                maxPixel:(CGFloat)maxPixel
                            jpegCompress:(BOOL)jpegCompress
                              maxSize:(CGFloat)maxSize
                              ImageBlock:(PikerImageBlock)imageBlock
                               dataBlock:(PikerDataBlock)dataBlock
{
    HLImagePicker *imagePicker = [HLImagePicker shareInstanced];
    
    if ([[self.class topViewController] isKindOfClass:[UIAlertController class]]) {
        return imagePicker;
    }
    
    [imagePicker showPickerOriginImage:originImage pixelCompress:pixelCompress maxPixel:maxPixel jpegCompress:jpegCompress maxSize:maxSize];
    imagePicker.imageBlock = imageBlock;
    imagePicker.dataBlock = dataBlock;
    return imagePicker;
}

- (void)showPickerOriginImage:(BOOL)originImage
                pixelCompress:(BOOL)pixelCompress
                     maxPixel:(CGFloat)maxPixel
                 jpegCompress:(BOOL)jpegCompress
                   maxSize:(CGFloat)maxSize
{
    self.pixelCompress = pixelCompress;
    self.maxPixel = maxPixel;
    self.jpegCompress = jpegCompress;
    self.maxSize = maxSize;
    [self showActionSheet];
}

- (void)selectPhotoPickerType:(HLImagePickerType)imagePickerType
{
    if (self.useAVSessionImagePiker && imagePickerType == HLImagePicker_Camera) {
        HLAVImagePickerController *pickerController = [[HLAVImagePickerController alloc] init];
        __unsafe_unretained typeof(self) weakself = self;
        [pickerController setImagePickerBlock:^(NSData *imageData ,UIImage *image) {
            if (weakself.imageBlock) {
                weakself.imageBlock(image, self);
            }
            
            if (self.dataBlock) {
                weakself.dataBlock(imageData, self);
            }
        }];
        [[[self class] topViewController] presentViewController:pickerController animated:YES completion:nil];
    }else {
        UIImagePickerController* pickerController = nil;;
        if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone) {
            pickerController = [[UIImagePickerController alloc] init];
        } else {
            pickerController = [[HLImagePickerController alloc] init];
        }
        
        pickerController.delegate = self;
        pickerController.allowsEditing = self.allowsEditing;
        
        if (imagePickerType == HLImagePicker_Camera) {
            //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
            if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
                pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            } else {
                pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
            }
        } else if (imagePickerType == HLImagePicker_Libray) {
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        }
        [[[self class] topViewController] presentViewController:pickerController animated:YES completion:nil];
    }
}

- (NSData*)compressImage:(UIImage*)originImage
           pixelCompress:(BOOL)pixelCompress
                maxPixel:(CGFloat)maxPixel
            jpegCompress:(BOOL)jpegCompress
              maxSize: (CGFloat)maxSize
{
    /*
     压缩策略： 支持最多921600个像素点
     像素压缩：（调整像素点个数）
     当图片长宽比小于3:1 or 1:3时，图片长和宽最多为maxPixel像素；
     当图片长宽比在3:1 和 1:3之间时，会保证图片像素压缩到921600像素以内；
     JPEG压缩：（调整每个像素点的存储体积）
     默认压缩比0.99;
     如果压缩后的数据仍大于IMAGE_MAX_BYTES，那么将调整压缩比将图片压缩至IMAGE_MAX_BYTES以下。
     策略调整：
     不进行像素压缩，或者增大maxPixel，像素损失越小。
     使用无损压缩，或者增大IMAGE_MAX_BYTES.
     注意：
     jepg压缩比为0.99时，图像体积就能压缩到原来的0.40倍了。
     */
    UIImage * scopedImage = nil;
    NSData * resultData = nil;
    //CGFloat maxbytes = maxKB * 1024;
    
    if (originImage == nil) {
        return nil;
    }
    
    if ( pixelCompress == YES ) {    //像素压缩
        // 像素数最多为maxPixel*maxPixel个
        CGFloat photoRatio = originImage.size.height / originImage.size.width;
        if ( photoRatio < 0.3333f )
        {                           //解决宽长图的问题
            CGFloat FinalWidth = sqrt ( maxPixel*maxPixel/photoRatio );
            scopedImage = [EncodeUtil convertImage:originImage scope:MAX(FinalWidth, maxPixel)];
        }
        else if ( photoRatio <= 3.0f )
        {                           //解决高长图问题
            scopedImage = [EncodeUtil convertImage:originImage scope: maxPixel];
        }
        else
        {                           //一般图片
            CGFloat FinalHeight = sqrt ( maxPixel*maxPixel*photoRatio );
            scopedImage = [EncodeUtil convertImage:originImage scope:MAX(FinalHeight, maxPixel)];
        }
    }
    else {          //不进行像素压缩
        scopedImage = originImage;
    }
    
    if ( jpegCompress == YES ) {     //JPEG压缩
        resultData = [HLImagePicker compressWithImage:scopedImage maxLength:maxSize];
    }
    else {
        resultData = UIImageJPEGRepresentation(scopedImage, 1.0);
    }
    
    return resultData;
}

- (void)operationImagePhotoInfo:(NSDictionary *)info
{
    
    UIImage *editedImage = [info objectForKey:UIImagePickerControllerEditedImage];
    UIImage *originalImage = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    NSData *resultData = nil;
    UIImage *resultImage = nil;
    if (!self.operationOriginImage) {
        resultImage = editedImage?:originalImage;
        resultData = [self compressImage:resultImage pixelCompress:self.pixelCompress maxPixel:self.maxPixel jpegCompress:self.jpegCompress maxSize:self.maxSize];
    }
    else{
        resultImage = originalImage;
        resultData = [self compressImage:resultImage pixelCompress:self.pixelCompress maxPixel:self.maxPixel jpegCompress:self.jpegCompress maxSize:self.maxSize];
    }
    if (self.imageBlock) {
        self.imageBlock(resultImage, self);
    }
    
    if (self.dataBlock) {
        self.dataBlock(resultData, self);
    }
}


- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self operationImagePhotoInfo:info];
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
}

#pragma mark -

+ (NSData *)compressWithImage:(UIImage *)image maxLength:(NSUInteger)maxLength{
    // Compress by quality
    CGFloat compression = 1;
    NSData *data = UIImageJPEGRepresentation(image, compression);
    //NSLog(@"Before compressing quality, image size = %ld KB",data.length/1024);
    if (data.length < maxLength) return data;
    
    CGFloat max = 1;
    CGFloat min = 0;
    for (int i = 0; i < 6; ++i) {
        compression = (max + min) / 2;
        data = UIImageJPEGRepresentation(image, compression);
        //NSLog(@"Compression = %.1f", compression);
        //NSLog(@"In compressing quality loop, image size = %ld KB", data.length / 1024);
        if (data.length < maxLength * 0.9) {
            min = compression;
        } else if (data.length > maxLength) {
            max = compression;
        } else {
            break;
        }
    }
    //NSLog(@"After compressing quality, image size = %ld KB", data.length / 1024);
    if (data.length < maxLength) return data;
    UIImage *resultImage = [UIImage imageWithData:data];
    // Compress by size
    NSUInteger lastDataLength = 0;
    while (data.length > maxLength && data.length != lastDataLength) {
        lastDataLength = data.length;
        CGFloat ratio = (CGFloat)maxLength / data.length;
        //NSLog(@"Ratio = %.1f", ratio);
        CGSize size = CGSizeMake((NSUInteger)(resultImage.size.width * sqrtf(ratio)),
                                 (NSUInteger)(resultImage.size.height * sqrtf(ratio))); // Use NSUInteger to prevent white blank
        UIGraphicsBeginImageContext(size);
        [resultImage drawInRect:CGRectMake(0, 0, size.width, size.height)];
        resultImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        data = UIImageJPEGRepresentation(resultImage, compression);
        //NSLog(@"In compressing size loop, image size = %ld KB", data.length / 1024);
    }
    //NSLog(@"After compressing size loop, image size = %ld KB", data.length / 1024);
    return data;
}

@end


