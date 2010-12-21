//
//  DirectMessagesView.h
//  TwitterTabbedTest
//
//  Created by cuzzo on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"


@interface DirectMessagesView : UIViewController {
	IBOutlet UITableView *tableView;
	IBOutlet UITextField *textField;
	IBOutlet UITextField *userName;
	BOOL dmsReceived;
	
	SA_OAuthTwitterEngine *_engine;
	NSMutableArray *_messages;
	NSMutableArray *_sentMessages;
	NSMutableDictionary *_messageDict;
}

@property (nonatomic, retain) IBOutlet UITableView *tableView;
@property (nonatomic, retain) IBOutlet UITextField *textField;
@property (nonatomic, retain) IBOutlet UITextField *userName;

-(IBAction)sendMessage:(id)sender;
-(IBAction)refreshMessages:(id)sender;

@end
