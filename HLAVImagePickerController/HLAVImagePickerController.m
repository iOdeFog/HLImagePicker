//
//  HLAVImagePickerController.m
//  HLImagePickerExample
//
//  Created by LHL on 2017/12/19.
//

#import "HLAVImagePickerController.h"
#import <AVFoundation/AVFoundation.h>

@interface HLAVImagePickerController ()
{
    AVCaptureSession *session;
    AVCaptureStillImageOutput *imageOutput;
}
@end


@implementation HLAVImagePickerController

- (void)dealloc{

}

- (void)viewDidLoad{
    [super viewDidLoad];
    
    [self installSession];
    [self createCoverUI];
}


- (void)installSession{
    session = [[AVCaptureSession alloc]init];
    
    //判断分辨率是否支持1280*720，支持就设置为1280*720
    if( [session canSetSessionPreset:AVCaptureSessionPreset1280x720] ) {
        session.sessionPreset = AVCaptureSessionPreset1280x720;
    }
    
    AVCaptureDevice *device =nil;
    NSArray *cameras = [AVCaptureDevice devicesWithMediaType:AVMediaTypeVideo];
    
    for(AVCaptureDevice *camera in cameras) {
        if(camera.position == AVCaptureDevicePositionBack) {//取得后置摄像头
            device = camera;
        }
    }
    
    if(!device) {
        NSLog(@"取得后置摄像头错误");
        return;
    }
    
    //3.创建输入数据对象
    NSError *error = nil;
    AVCaptureDeviceInput * captureInput = [[AVCaptureDeviceInput alloc] initWithDevice:device error:&error];
    
    if(error) {
        NSLog(@"创建输入数据对象错误");
        return;
    }
    
    //4.创建输出数据对象
    imageOutput = [[AVCaptureStillImageOutput alloc] init];
    NSDictionary *setting =@{AVVideoCodecKey:AVVideoCodecJPEG};
    [imageOutput setOutputSettings:setting];
    
    //5.添加输入数据对象和输出对象到会话中
    if([session canAddInput:captureInput]) {
        [session addInput:captureInput];
    }
    
    if([session canAddOutput:imageOutput]) {
        [session addOutput:imageOutput];
    }
    
    //6.创建视频预览图层
    AVCaptureVideoPreviewLayer *videoLayer =
    [[AVCaptureVideoPreviewLayer alloc] initWithSession:session];
    self.view.layer.masksToBounds=YES;
    videoLayer.frame = self.view.bounds;
    videoLayer.videoGravity = AVLayerVideoGravityResizeAspectFill;
    [self.view.layer addSublayer:videoLayer];
    
    //这里需要设置相机开始捕捉画面
    [session startRunning];//开始捕捉

}


- (void)createCoverUI{
    UIView *contentView = [[UIView alloc]initWithFrame:CGRectMake(0, self.view.frame.size.height-100, self.view.frame.size.width, 100)];
    contentView.backgroundColor = [UIColor clearColor];
    UIButton* cancel = [UIButton buttonWithType:UIButtonTypeCustom];
    cancel.frame = CGRectMake(20, 0, 44, 44);
    cancel.center = CGPointMake(40, CGRectGetHeight(contentView.frame)/2);
    [cancel setImage:[UIImage imageNamed:@"closecamera"]  forState:UIControlStateNormal];
    [cancel addTarget:self action:@selector(cancelCamera:) forControlEvents:UIControlEventTouchUpInside];
    
    UIButton* takePicture = [UIButton buttonWithType:UIButtonTypeCustom];
    takePicture.frame = CGRectMake(0, 0, 80, 80);
    takePicture.center = CGPointMake(CGRectGetWidth(contentView.frame)/2, CGRectGetHeight(contentView.frame)/2);
    [takePicture setImage:[UIImage imageNamed:@"takepicture"]  forState:UIControlStateNormal];
    [takePicture addTarget:self action:@selector(cameraPhoto:) forControlEvents:UIControlEventTouchUpInside];
    
    [contentView addSubview:cancel];
    [contentView addSubview:takePicture];
    [self.view addSubview:contentView];
}

- (void)cameraPhoto:(UIButton *)sender{
    
    // 输出图片
    AVCaptureConnection *connection = [imageOutput connectionWithMediaType:AVMediaTypeVideo];
    if (connection.isVideoOrientationSupported) {
        UIInterfaceOrientation orientation = [UIApplication sharedApplication].statusBarOrientation;
        connection.videoOrientation = (AVCaptureVideoOrientation)orientation;
    }
    id takePictureSuccess = ^(CMSampleBufferRef sampleBuffer,NSError *error){
        if (sampleBuffer == NULL) {
            NSLog(@"获取捕获图片对象错误");
            return ;
        }
        NSData *imageData = [AVCaptureStillImageOutput jpegStillImageNSDataRepresentation:sampleBuffer];
        UIImage *image = [[UIImage alloc]initWithData:imageData];
        if (self.imagePickerBlock) {
            self.imagePickerBlock(imageData ,image);
        }
        [self cancelCamera:sender];
    };
    if (!connection || !connection.enabled || !connection.active) {
        // Raise error here / warn user...
        return;
    }
    [imageOutput captureStillImageAsynchronouslyFromConnection:connection completionHandler:takePictureSuccess];
    
}

- (void)cancelCamera:(UIButton *)sender{
    [session stopRunning];
    
    if (![self.navigationController popViewControllerAnimated:YES]) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }
}


@end
