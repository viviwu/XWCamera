//
//  HomeViewController.m
//  XWCamera
//
//  Created by vivi wu on 2016/6/5.
//  Copyright © 2016 vivi wu. All rights reserved.
//

#import "HomeViewController.h"
#import "PHImageManager+CTAssetsPickerController.h"

#define tableViewRowHeight 80.0f

@interface HomeViewController ()

@end

@implementation HomeViewController

- (IBAction)pickAssets:(id)sender {
  [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status){
    dispatch_async(dispatch_get_main_queue(), ^{
      
      // init picker
      CTAssetsPickerController *picker = [[CTAssetsPickerController alloc] init];
      
      // set delegate
      picker.delegate = self;
      
      // to present picker as a form sheet in iPad
      if (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
        picker.modalPresentationStyle = UIModalPresentationFormSheet;
      
      // present picker
      [self presentViewController:picker animated:YES completion:nil];
      
    });
  }];
}
- (IBAction)openCamera:(id)sender {
  
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = NSLocalizedString(@"MENU", nil);
    // Do any additional setup after loading the view.
  
  // init properties
  self.assets = [[NSMutableArray alloc] init];
  
  self.dateFormatter = [[NSDateFormatter alloc] init];
  self.dateFormatter.dateStyle = NSDateFormatterMediumStyle;
  self.dateFormatter.timeStyle = NSDateFormatterMediumStyle;
  
  self.requestOptions = [[PHImageRequestOptions alloc] init];
  self.requestOptions.resizeMode   = PHImageRequestOptionsResizeModeExact;
  self.requestOptions.deliveryMode = PHImageRequestOptionsDeliveryModeHighQualityFormat;
  
}
- (void)viewWillAppear:(BOOL)animated
{
  [super viewWillAppear:animated];
  [self.navigationController setToolbarHidden:NO animated:YES];
}

- (void)viewWillDisappear:(BOOL)animated
{
  [super viewWillDisappear:animated];
  [self.navigationController setToolbarHidden:YES animated:YES];
}

#pragma mark - Assets Picker Delegate

- (void)assetsPickerController:(CTAssetsPickerController *)picker didFinishPickingAssets:(NSArray *)assets
{
  [picker dismissViewControllerAnimated:YES completion:nil];
  
  self.assets = [NSMutableArray arrayWithArray:assets];
  NSLog(@"self.assets : %@", self.assets);
}

// implement should select asset delegate
- (BOOL)assetsPickerController:(CTAssetsPickerController *)picker shouldSelectAsset:(PHAsset *)asset
{
  NSInteger max = 3;
  
  // show alert gracefully
  if (picker.selectedAssets.count >= max)
  {
    UIAlertController *alert =
    [UIAlertController alertControllerWithTitle:@"Attention"
                                        message:[NSString stringWithFormat:@"Please select not more than %ld assets", (long)max]
                                 preferredStyle:UIAlertControllerStyleAlert];
    
    UIAlertAction *action =
    [UIAlertAction actionWithTitle:@"OK"
                             style:UIAlertActionStyleDefault
                           handler:nil];
    
    [alert addAction:action];
    
    [picker presentViewController:alert animated:YES completion:nil];
  }
  
  // limit selection to max
  return (picker.selectedAssets.count < max);
}


@end
