//
//  XWPicEditViewController.h
//  XWCamera
//
//  Created by vivi wu on 2019/6/11.
//  Copyright © 2019 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CTAssetsPickerController/CTAssetsPickerController.h>
#import <CTAssetsPickerController/CTAssetsPageViewController.h>

NS_ASSUME_NONNULL_BEGIN

@interface XWPicEditViewController : UIViewController <CTAssetsPickerControllerDelegate>

@property (nonatomic, copy) NSArray *assets;
@property (nonatomic, strong) NSDateFormatter *dateFormatter;
@property (nonatomic, strong) PHImageRequestOptions *requestOptions;

@end

NS_ASSUME_NONNULL_END
