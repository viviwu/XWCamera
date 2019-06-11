//
//  XWImageFilterViewController.m
//  XWCamera
//
//  Created by vivi wu on 2019/6/11.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "XWImageFilterViewController.h"
#import <MobileCoreServices/MobileCoreServices.h>
//#import <CoreServices/CoreServices.h>

#import <GPUImage/GPUImageView.h>
#import <GPUImage/GPUImagePicture.h>
#import <GPUImage/GPUImageTiltShiftFilter.h>
#import <GPUImage/GPUImageWhiteBalanceFilter.h>
#import "GPUImageWaveFilter.h"

@interface XWImageFilterViewController ()<UINavigationControllerDelegate, UIImagePickerControllerDelegate>
{
    GPUImagePicture *sourcePicture;
    GPUImageOutput<GPUImageInput> *sepiaFilter, *sepiaFilter2;
}
@property (nonatomic, strong) UIImage *originImage;

@property (weak, nonatomic) IBOutlet UISlider *imageSlider;
//@property (weak, nonatomic) IBOutlet GPUImageView *primaryView;
@property (weak, nonatomic) IBOutlet UIImageView *showImageView;

@end

@implementation XWImageFilterViewController

- (IBAction)updateSliderValue:(UISlider *)slider {
    if (self.originImage) {
        GPUImageWaveFilter *filter = [[GPUImageWaveFilter alloc] init];
        filter.normalizedPhase = slider.value;
        self.showImageView.image = [filter imageByFilteringImage:self.originImage];
        self.showImageView.image = [filter imageByFilteringImage:self.originImage];
    }
}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}
- (IBAction)pickAssets:(id)sender {
    UIImagePickerController *vc = [[UIImagePickerController alloc] init];
    vc.delegate = self;
    vc.sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
    [self.navigationController presentViewController:vc animated:YES completion:NULL];
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
    if ([info[UIImagePickerControllerMediaType] isEqualToString:(NSString *)kUTTypeImage])
    {
        self.originImage = [self manageImage:info[UIImagePickerControllerOriginalImage]];
        self.showImageView.image = self.originImage;
        [self managerImageFrame];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [self.navigationController dismissViewControllerAnimated:YES completion:NULL];
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    if (interfaceOrientation == UIInterfaceOrientationPortrait)
    {
        return YES;
    }
    return NO;
}


#pragma mark - image manager

- (UIImage *)manageImage:(UIImage *)image {
    return image.size.width > image.size.height ? [self resizeImage:image toHeight:kScreenW] : [self resizeImage:image toWidth:kScreenW];
}

- (UIImage *)resizeImage:(UIImage *)image toHeight:(CGFloat)height {
    CGRect rect = CGRectMake(0, 0, image.size.width * height / image.size.height, height);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [image drawInRect:rect];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (UIImage *)resizeImage:(UIImage *)image toWidth:(CGFloat)width {
    CGRect rect = CGRectMake(0, 0, width, image.size.height * width / image.size.width);
    UIGraphicsBeginImageContextWithOptions(rect.size, NO, 0);
    [image drawInRect:rect];
    UIImage *resultImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    return resultImage;
}

- (void)managerImageFrame {
    CGSize imageSize = self.originImage.size;
    CGRect frame;
    if (imageSize.width > imageSize.height) {
        imageSize = CGSizeMake(kScreenW, imageSize.height * (kScreenW / imageSize.width));
        frame.size = imageSize;
        frame.origin = CGPointMake(0, 64 + (kScreenW - imageSize.height) / 2);
    } else {
        imageSize = CGSizeMake(imageSize.width * (kScreenW / imageSize.height), kScreenW);
        frame.size = imageSize;
        frame.origin = CGPointMake((kScreenW - imageSize.width) / 2, 64);
    }
    
    self.showImageView.frame = frame;
}


@end
