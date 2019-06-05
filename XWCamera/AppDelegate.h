//
//  AppDelegate.h
//  XWCamera
//
//  Created by vivi wu on 2016/6/5.
//  Copyright © 2016 vivi wu. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

