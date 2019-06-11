//
//  XWPicEditViewController.m
//  XWCamera
//
//  Created by vivi wu on 2019/6/11.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import "XWPicEditViewController.h"
#import <CTAssetsPickerController/PHImageManager+CTAssetsPickerController.h>

#import <GPUImage/GPUImageView.h>
#import <GPUImage/GPUImagePicture.h>
#import <GPUImage/GPUImageTiltShiftFilter.h>
#import <GPUImage/GPUImageWhiteBalanceFilter.h>

@interface XWPicEditViewController ()
{
    UIImage * inputImage, * outputImage;
    GPUImageWhiteBalanceFilter *WhiteBalanceFilter;
    GPUImagePicture *gpuPicture;
}
@property (weak, nonatomic) IBOutlet UIImageView *imageView;

@property (strong, nonatomic) IBOutletCollection(UISlider) NSArray *sliders;
@property (strong, nonatomic) IBOutletCollection(UILabel) NSArray *labels;

@end

@implementation XWPicEditViewController

- (IBAction)pickAssets:(id)sender
{
    [PHPhotoLibrary requestAuthorization: ^(PHAuthorizationStatus status)
    {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
            picker.delegate = self;
            // to present picker as a form sheet in iPad
            if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
                picker.modalPresentationStyle = UIModalPresentationFormSheet;
            
            // present picker
            [self presentViewController:picker animated:YES completion:nil];
        });
    }];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // init properties
    self.assets = [[NSMutableArray alloc] init];
    
    self.dateFormatter = [[NSDateFormatter alloc] init];
    self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
    self.dateFormatter.timeStyle = NSDateFormatterMediumStyle;
    
    self.requestOptions = [[PHImageRequestOptions alloc] init];
    self.requestOptions.resizeMode = PHImageRequestOptionsResizeModeExact;
    self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
    
    // Do any additional setup after loading the view.
}

- (void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
//    [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
    [super viewWillDisappear:animated];
//    [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - Assets Picker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    
    self.assets = [NSMutableArray arrayWithArray:assets];
    NSLog(@"self.assets : %@", self.assets);
    PHAsset *asset = self.assets.lastObject;
    
    PHImageManager *manager = [PHImageManager defaultManager];
    CGFloat scale = UIScreen.mainScreen.scale;
    CGSize targetSize = CGSizeMake(_imageView.bounds.size.width * scale, _imageView.bounds.size.height * scale);
//    UISlider * slider = self.sliders.firstObject;
    __weak typeof(self) weakSelf = self;
    [manager ctassetsPickerRequestImageForAsset:asset
                                     targetSize:targetSize
                                    contentMode:PHImageContentModeAspectFill
                                        options:self.requestOptions
                                  resultHandler:^(UIImage *image, NSDictionary *info){
                                      self->inputImage = image;
                                      weakSelf.imageView.image = self->inputImage;
   }];
}

// implement should select asset delegate
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
    NSInteger max = 1;  //限定一次可以选取的数量 1
    // show alert gracefully
    if (picker.selectedAssets.count >= max)
    {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Attention"  message:[NSString stringWithFormat:@"Please select not more than %ld assets", (long)max] preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *action = [UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil];
        
        [alert addAction:action];
        
        [picker presentViewController:alert animated:YES completion:nil];
    }
    
    // limit selection to max
    return (picker.selectedAssets.count < max);
}


- (IBAction)sliderValueChanged:(UISlider *)slider
{
    NSString * info = [NSString stringWithFormat: @"Slider[%ld]:%.1f", (long)slider.tag, slider.value];
    UILabel * label = _labels[slider.tag];
    label.text = info;
    if (!inputImage) {
        NSLog(@"inputImage is nil %@", inputImage);
        return;
    }
    switch (slider.tag) {
        case 0:{//色温(白平衡)
            if (!WhiteBalanceFilter) {
                WhiteBalanceFilter = [[GPUImageWhiteBalanceFilter alloc] init];
                //设置要渲染的区域
                [WhiteBalanceFilter forceProcessingAtSize:inputImage.size];
            }
            WhiteBalanceFilter.temperature = slider.value/10;
            WhiteBalanceFilter.tint = 0.0;
            
            if (!gpuPicture) {//获取 GPU 图片
                gpuPicture = [[GPUImagePicture alloc]initWithImage:inputImage];
            }
            //添加滤镜
            [gpuPicture addTarget:WhiteBalanceFilter];
            //(需要调用一下? why?)
            [WhiteBalanceFilter useNextFrameForImageCapture];
            //开始渲染
            [gpuPicture processImage];
            //获取渲染后的图片
            outputImage = [WhiteBalanceFilter imageFromCurrentFramebuffer];
            
            self.imageView.image = outputImage;
            
        } break;
            
        case 1:{
 
        }break;
            
        case 2:{
 
        }break;
            
        case 3:{
            
        }break;
            
        default:
            break;
    }
    
    
    
}

- (IBAction)exportAssets:(id)sender
{
    NSLog(@"%s", __func__);
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
