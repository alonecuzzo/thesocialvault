//
//  TwitterFeedView.h
//  TwitterTabbedTest
//
//  Created by cuzzo on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"

@interface TwitterFeedView : UIViewController {
	IBOutlet UITableView *tableView;
	IBOutlet UITextField *textField;
	
	SA_OAuthTwitterEngine *_engine;
	NSMutableArray *tweets;

}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *textField;

-(IBAction)updateStream:(id)sender;
-(IBAction)tweet:(id)sender;

@end
