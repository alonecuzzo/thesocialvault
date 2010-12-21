    //
//  DirectMessagesView.m
//  TwitterTabbedTest
//
//  Created by cuzzo on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DirectMessagesView.h"
#import "TwitterEngineInstance.h"
#import "DirectMessage.h"

@implementation DirectMessagesView

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.
/*
- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization.
    }
    return self;
}
*/


// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
//- (void)viewDidLoad {
//	
//    [super viewDidLoad];
//}


-(void)viewDidAppear:(BOOL)animated {
	
	//NSLog(@"%@",[[TwitterEngineInstance sharedInstance:self] getEngine:self]);
	
	if(_engine){
		[_engine setDelegate:self];
		return;
	}	
	_engine = [[TwitterEngineInstance sharedInstance:self] getEngine:self];
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller){
		[self presentModalViewController: controller animated: YES];
	} else {
		_messages = [[NSMutableArray alloc] init];
		[self refreshMessages:nil];
	}	
}


- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
	_messages = [[NSMutableArray alloc] init];
	
	for(NSDictionary *d in messages) {
		//NSLog(@"Direct Messages Received: %@", messages);
		DirectMessage *dm = [[DirectMessage alloc] initWithMessageDictionary:d];
		[_messages addObject:dm];
		[dm release];
		//NSLog(@"number of messages: %d", [_messages count]);
	}

	[tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *messageSelected = [_messages objectAtIndex:indexPath.row];
	
	NSString *msg = [NSString stringWithFormat:@"You have selected %@", messageSelected];
	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Selected"
													message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	NSLog(@"message selected: %@", [(DirectMessage*)[_messages objectAtIndex:indexPath.row] message]);
	[alert show];
	[alert release];
}


-(NSString *)sendMessage:(id)sender {
	[_engine sendDirectMessage:textField.text to:userName.text];	
}


-(NSString *)refreshMessages:(id)sender {
	[_engine getDirectMessagesSinceID:1 startingAtPage:1];
	//NSLog(@"number of messages: %d", [_messages count]);
}


#pragma mark UITableViewDataSource Methods 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [_messages count];
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *identifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if(!cell) {
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:identifier];
		[cell setBackgroundColor:[UIColor clearColor]];
	}
	
	[cell.textLabel setNumberOfLines:7];
	[cell.textLabel setText:[(DirectMessage*)[_messages objectAtIndex:indexPath.row] message]];
	
	//NSLog(@"message: %@", [(DirectMessage*)[_messages objectAtIndex:indexPath.row] message]);
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 150;
}


- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


- (void)didReceiveMemoryWarning {
    // Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
    
    // Release any cached data, images, etc. that aren't in use.
}


- (void)viewDidUnload {
    [super viewDidUnload];
    // Release any retained subviews of the main view.
    // e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}


@end
