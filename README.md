# HLImagePicker


快速从相册选择一张图片，并可以按照尺寸压缩，压缩又分为像素压缩和非像素压缩

---


## 使用

![image](./Snap/0001.png)

### 调起ActionSheet

```
// 调用系统播放器页面，支持系统编辑
- (IBAction)imagePicker:(id)sender {
    __weak typeof(self) mySelf = self;
   HLImagePicker *picker = [HLImagePicker  showPickerImageBlock:^(UIImage *image, id picker) {
        mySelf.contentImageView.image = image;
    } dataBlock:^(NSData *data, id picker) {
        
    }];
    
}


// 调用自定义拍摄页面，不支持编辑
- (IBAction)avImagePicker:(id)sender {
 __weak typeof(self) mySelf = self;
    [[HLImagePicker shareInstanced] setUseAVSessionImagePiker:YES];
    [HLImagePicker  showPickerImageBlock:^(UIImage *image, id picker) {
        mySelf.contentImageView.image = image;
    } dataBlock:^(NSData *data, id picker) {
        
    }];
}

// 

```

### 直接调起相册或者相册

```

    HLImagePicker *picker = [HLImagePicker shareInstanced];
    __weak typeof(self) mySelf = self;
    picker setImageBlock:^(UIImage *image, id picker) {
        mySelf.contentImageView.image = image;
    };

    //[picker selectPhotoPickerType:HLImagePicker_Camera];
    [picker selectPhotoPickerType:HLImagePicker_Libray];


```


header.h 部分方法

```
/**
 *  选择图片回调代理，不进行压缩
 */
+ (HLImagePicker *)showPickerImageBlock:(PikerImageBlock)imageBlock
                              dataBlock:(PikerDataBlock)dataBlock;



/*
 *    @param     originImage        处理原始图片 默认为NO
 *    @param     jpegCompress       是否进行JPEG压缩,jpeg 压缩会更肖
 *    @param     max               图片最大体积，以字节为单位
 *
 */
+ (HLImagePicker *)showPickerJpegMaxSize:(CGFloat)maxSize
                               ImageBlock:(PikerImageBlock)imageBlock
                                dataBlock:(PikerDataBlock)dataBlock;

/*
 *    @param   maxPixel  最大宽或者高尺寸像素，如果宽长，则指的是宽，如果高长，则指的是高
 *
 */
+ (HLImagePicker *)showPickerMaxPixel:(CGFloat)maxPixel
                           ImageBlock:(PikerImageBlock)imageBlock
                            dataBlock:(PikerDataBlock)dataBlock;


/*
 *  @param       originImage    处理原始图片 默认为NO
 *    @param     pixelCompress  是否进行像素压缩
 *    @param     maxPixel       最大宽或者高尺寸像素，如果宽长，则指的是宽，如果高长，则指的是高；pixelCompress=NO时，此参数无效。
 *    @param     jpegCompress   是否进行JPEG压缩,jpeg 压缩会更肖
 *    @param     maxKB          图片最大体积，以KB为单位；jpegCompress=NO时，此参数无效。
 *
 */
+ (HLImagePicker *)showPickerOriginImage:(BOOL)originImage
                           pixelCompress:(BOOL)pixelCompress
                                maxPixel:(CGFloat)maxPixel
                            jpegCompress:(BOOL)jpegCompress
                                 maxSize:(CGFloat)maxSize
                              ImageBlock:(PikerImageBlock)imageBlock
                               dataBlock:(PikerDataBlock)dataBlock;

/*
 *    @brief    压缩图片 @Fire
 *
 *    @param     originImage       原始图片
 *    @param     pixelCompress     是否进行像素压缩
 *    @param     maxPixel          最大宽或者高尺寸像素，如果宽长，则指的是宽，如果高长，则指的是高；pixelCompress=NO时，此参数无效。
 *    @param     jpegCompress      是否进行JPEG压缩,jpeg 压缩会更肖
 *    @param     maxKB             图片最大体积，以KB为单位；jpegCompress=NO时，此参数无效。
 *
 *    @return    返回图片的NSData
 */
- (NSData*)compressImage:(UIImage*)originImage
           pixelCompress:(BOOL)pixelCompress
                maxPixel:(CGFloat)maxPixel
            jpegCompress:(BOOL)jpegCompress
              maxSize:(CGFloat)maxSize;


- (void)selectPhotoPickerType:(HLImagePickerType)imagePickerType;
- (void)showActionSheet;

```



