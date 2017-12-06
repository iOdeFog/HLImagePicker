//
//  ViewController.m
//  HLImagePickerExample
//
//  Created by LHL on 15/9/6.
//  Copyright (c) 2015年 李红力. All rights reserved.
//

#import "ViewController.h"
#import "HLImagePicker.h"

@interface ViewController ()
@property (weak, nonatomic) IBOutlet UIImageView *contentImageView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)imagePicker:(id)sender {
    __weak typeof(self) mySelf = self;
   HLImagePicker *picker = [HLImagePicker  showPickerImageBlock:^(UIImage *image, id picker) {
        mySelf.contentImageView.image = image;
    } dataBlock:^(NSData *data, id picker) {
        
    }];
    
//
//    HLImagePicker *picker = [HLImagePicker shareInstanced];
//    __weak typeof(self) mySelf = self;
//    picker setImageBlock:^(UIImage *image, id picker) {
//        mySelf.contentImageView.image = image;
//    };
//    [picker selectPhotoPickerType:HLImagePicker_Camera];
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
