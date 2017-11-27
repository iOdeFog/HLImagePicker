# HLImagePicker


快速从相册选择一张图片，并可以按照尺寸压缩，压缩又分为像素压缩和非像素压缩

---

![image](./Snap/0001.png)

```
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


```