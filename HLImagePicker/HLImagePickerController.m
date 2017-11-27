//
//  HLImagePickerController.m
//  ZCZouCai
//
//  Created by LHL on 2017/11/7.
//  Copyright © 2017年 ZouCai. All rights reserved.
//

#import "HLImagePickerController.h"

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
