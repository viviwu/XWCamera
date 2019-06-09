//
//  HomeViewController.h
//  XWCamera
//
//  Created by vivi wu on 2016/6/5.
//  Copyright © 2016 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <CTAssetsPickerController/CTAssetsPageViewController.h>

@interface HomeViewController : UIViewController<CTAssetsPickerControllerDelegate>

@property (nonatomic, copy) NSArray *assets;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;

@end

