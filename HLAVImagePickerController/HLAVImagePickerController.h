//
//  HLAVImagePickerController.h
//  HLImagePickerExample
//
//  Created by LHL on 2017/12/19.
//

#import <UIKit/UIKit.h>

typedef void(^HLAVImagePickerBlock)(NSData *imageData ,UIImage *image);

@interface HLAVImagePickerController : UIViewController

@property (nonatomic, copy) HLAVImagePickerBlock imagePickerBlock;

@end
