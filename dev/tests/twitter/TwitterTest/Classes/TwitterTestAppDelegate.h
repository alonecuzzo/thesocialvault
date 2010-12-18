//
//  TwitterTestAppDelegate.h
//  TwitterTest
//
//  Created by cuzzo on 12/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>

@class TwitterTestViewController;

@interface TwitterTestAppDelegate : NSObject <UIApplicationDelegate> {
    UIWindow *window;
    TwitterTestViewController *viewController;
}

@property (nonatomic, retain) IBOutlet UIWindow *window;
@property (nonatomic, retain) IBOutlet TwitterTestViewController *viewController;

@end

