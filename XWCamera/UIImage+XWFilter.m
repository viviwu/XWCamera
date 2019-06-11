//
//  UIImage+XWFilter.m
//  XWCamera
//
//  Created by vivi wu on 2019/6/11.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "UIImage+XWFilter.h"

#import <GPUImage/GPUImagePicture.h>
#import <GPUImage/GPUImageFilter.h>
#import <GPUImage/GPUImageWhiteBalanceFilter.h>

@implementation UIImage (XWFilter)

+ (UIImage *)changeValueForWhiteBalanceFilter:(float)value image:(UIImage *)image
{
    GPUImageWhiteBalanceFilter *filter = [[GPUImageWhiteBalanceFilter alloc] init];
    filter.temperature = value;
    filter.tint = 0.0;
    [filter forceProcessingAtSize:image.size];
    GPUImagePicture *pic = [[GPUImagePicture alloc] initWithImage:image];
    [pic addTarget:filter];
    
    [pic processImage];
    [filter useNextFrameForImageCapture];
    return [filter imageFromCurrentFramebuffer];
}

@end
