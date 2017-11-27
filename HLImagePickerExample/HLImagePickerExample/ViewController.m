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
@property (nonatomic, strong) HLImagePicker *picker ;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (IBAction)imagePicker:(id)sender {
    self.picker = [[HLImagePicker alloc] init];
    self.picker.delegate = self;
    [self.picker tap:sender inView:self.view inController:self toCut:NO saveDocument:NO];
}

/*
 * 返回图片
 */
- (void)setViewPhoto:(NSString *)path sender:(id)sender{
    
}

- (void)setViewPhotoInfo:(NSDictionary *)path sender:(id)sender{
    
}

/*
 * 返回图片Data
 */
- (void)setViewImageData:(NSData *)imageData{
    
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
