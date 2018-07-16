//
//  ViewController.m
//  HLImagePickerExample
//
//  Created by LHL on 15/9/6.
//  Copyright (c) 2015年 李红力. All rights reserved.
//

#import "ViewController.h"
#import "HLImagePicker.h"
#import "HLAVImagePickerController.h"

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
    [[HLImagePicker shareInstanced] setUseAVSessionImagePiker:NO];
    
//    [HLImagePicker showPickerJpegMaxSize:200*1024 ImageBlock:^(UIImage *image, id picker) {
//
//    } dataBlock:^(NSData *data, id picker) {
//        NSLog(@"%@",@(data.length));
//
//    }];
    
    [HLImagePicker showPickerPixelMaxSize:320 ImageBlock:^(UIImage *image, id picker) {

    } dataBlock:^(NSData *data, id picker) {
        NSLog(@"%@",@(data.length));

    }];
    
//    [HLImagePicker  showPickerImageBlock:^(UIImage *image, id picker) {
//        mySelf.contentImageView.image = image;
//    } dataBlock:^(NSData *data, id picker) {
//        NSLog(@"%@",@(data.length));
//
//    }];
}

- (IBAction)avImagePicker:(id)sender {
//    __weak typeof(self) mySelf = self;
//    HLAVImagePickerController *pickerViewContorller = [[HLAVImagePickerController alloc] init];
//    [pickerViewContorller setImagePickerBlock:^(NSData *imageData ,UIImage *image) {
//        mySelf.contentImageView.image = image;
//    }];
//    [self presentViewController:pickerViewContorller animated:YES completion:nil];
    __weak typeof(self) mySelf = self;
    [[HLImagePicker shareInstanced] setUseAVSessionImagePiker:YES];
    [HLImagePicker  showPickerImageBlock:^(UIImage *image, id picker) {
        mySelf.contentImageView.image = image;
    } dataBlock:^(NSData *data, id picker) {
        NSLog(@"%@",@(data.length));

    }];

}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
