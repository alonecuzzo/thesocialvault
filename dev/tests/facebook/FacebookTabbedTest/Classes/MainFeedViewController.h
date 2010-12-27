//
//  MainFeedViewController.h
//  FacebookTabbedTest
//
//  Created by cuzzo on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "FBConnect.h"
#import "FBLoginButton.h"


@interface MainFeedViewController : UIViewController
<FBRequestDelegate,
FBDialogDelegate,
FBSessionDelegate>{
	IBOutlet UILabel *_label;
	IBOutlet FBLoginButton *_fbButton;
	Facebook *_facebook;
	NSArray *_permissions;
}

@property(nonatomic, retain) UILabel* label;
@property(readonly) Facebook *facebook;

-(IBAction)fbButtonClick:(id)sender;

@end
