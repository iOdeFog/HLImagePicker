//
//  HLImagePicker.m
//  LHL
//
//  Created by LHL on 15/9/6.
//  Copyright (c) 2015年 李红力-易到用车iOS开发工程师. All rights reserved.
//

#import "HLImagePicker.h"
#import "EncodeUtil.h"


@implementation HLImagePicker
@synthesize toCut;

- (void)showActionSheet:(UIView *)view {
    UIActionSheet *action = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    action.actionSheetStyle = UIActionSheetStyleBlackTranslucent;
    //  action.alpha = 0.9;
    action.tag = 1;
    [action showInView: view];
}

- (void)tap:(id)delegate inView:(UIView *)view inController:(UIViewController *)controller toCut:(BOOL)to_Cut {
    self.toCut = to_Cut;     
    tapSender = delegate;
    pController = controller;
    [self showActionSheet: view];
}


- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex
{
    if (actionSheet.tag == 1) {
        if (buttonIndex == 0) {
            [self clickPhoto:0];
        } else if (buttonIndex == 1) {
            [self clickPhoto:1];
        }
    }
}

- (void)clickPhoto:(NSInteger)sender
{
    if (pickerController == nil) {
        pickerController = [[UIImagePickerController alloc] init];
        pickerController.delegate = self;
        pickerController.allowsEditing = YES;
    }
    
    if (sender == 0) {
        //先设定sourceType为相机，然后判断相机是否可用（ipod）没相机，不可用将sourceType设定为相片库
        if (![UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]) {
            pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        } else {
            pickerController.sourceType = UIImagePickerControllerSourceTypeCamera;
        }
    } else if (sender == 1) {
        pickerController.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
    }
    [pController presentViewController:pickerController animated:YES completion:nil];
}

- (NSData*) compressImage:(UIImage*)originImage PixelCompress:(BOOL)pc MaxPixel:(CGFloat)maxPixel JPEGCompress:(BOOL)jc MaxSize_KB: (CGFloat)maxKB
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
    NSData * data = nil;
    //CGFloat maxbytes = maxKB * 1024;

    if (originImage == nil) {
        return nil;
    }
    
    if ( pc == YES ) {    //像素压缩
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
    
    if ( jc == YES ) {     //JPEG压缩
        data = UIImageJPEGRepresentation(scopedImage, 0.8);
//        NSLog(@"data compress with ratio (0.9) : %d KB", data.length/1024);
    }
    else {
        data = UIImageJPEGRepresentation(scopedImage, 1.0);
//        NSLog(@"data compress : %d KB", data.length/1024);
    }
    
    return data;
}

- (void)addPhoto:(NSDictionary *)info
{    
    UIImage *pickedPhoto = nil;
    NSString *jpegScopedPhotoName = nil;
    NSString *jpegScopedPhotoPath = nil;
    NSData *data = nil;
    
    if (toCut) {
        pickedPhoto = [info objectForKey:UIImagePickerControllerEditedImage];
        // 640*640 头像 没有JPEG压缩
        data = [self compressImage:pickedPhoto PixelCompress:YES MaxPixel:640 JPEGCompress:YES MaxSize_KB:0];
    }else{
        pickedPhoto = [info objectForKey:UIImagePickerControllerOriginalImage];
        // 960*960 发布 双重压缩
        data = [self compressImage:pickedPhoto PixelCompress:YES MaxPixel:480 JPEGCompress:YES MaxSize_KB:1024];
    }
    
    if (data == nil) {
        NSLog(@"lobo image picker add photo error !");
    }
    else {   //写入文件
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init] ;
        [dateFormatter setDateFormat:@"yyyyMMddHHmmss"];
        NSString *date = [dateFormatter stringFromDate:[NSDate date]];
        NSFileManager *nfm = [NSFileManager defaultManager];
        
        jpegScopedPhotoName = [NSString stringWithFormat:@"%@.jpg", date];
        jpegScopedPhotoPath = [NSString stringWithFormat:@"%@/%@", [self getBasePath], jpegScopedPhotoName];
        [nfm createFileAtPath:jpegScopedPhotoPath contents:data attributes:nil];
        [self setViewPhoto: jpegScopedPhotoPath];
    }
}

- (NSString *)getBasePath
{
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    return [paths objectAtIndex:0];
}

- (void)setViewPhoto:(NSString *)path
{    
    //需要返回此图片是否是相机拍下的图片，如果是相机拍下的，并且被发布，则需要保存。
    NSString * sourceType;
    if (pickerController.sourceType == UIImagePickerControllerSourceTypeCamera) {
        sourceType = @"camera";
    }else{
        sourceType = @"library";
    }
    NSArray * infoValue = [NSArray arrayWithObjects:path, sourceType, nil];
    NSArray * infoKey = [NSArray arrayWithObjects: @"path", @"sourceType", nil];
    NSDictionary *info = [NSDictionary dictionaryWithObjects:infoValue forKeys:infoKey];
    
    if (self.delegate != nil && [self.delegate respondsToSelector: @selector(setViewPhoto:sender:)]) {    //不需要保存照片的类都相应此调用
        [self.delegate performSelector: @selector(setViewPhoto:sender:) withObject: path withObject: tapSender];
    }else if (self.delegate != nil && [self.delegate respondsToSelector: @selector(setViewPhotoInfo:sender:)]) { //需要保存照片的类都响应此调用
        [self.delegate performSelector: @selector(setViewPhotoInfo:sender:) withObject: info withObject: tapSender];
    }
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
//    NSLog(@"didFinishPickingMediaWithInfo %@", info);
    //
    [self addPhoto:info];
    //
    [picker dismissViewControllerAnimated:YES completion:nil];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    picker = nil;
    pickerController = nil;
}

@end
