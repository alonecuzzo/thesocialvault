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

@synthesize _authorList;
@synthesize _tableView;

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
	if(!dmsReceived) {
		//populate messages, and then send request for sent messages
		_messages = [[NSMutableArray alloc] init];
		
		for(NSDictionary *d in messages) {
			//NSLog(@"Direct Messages Received: %@", messages);
			DirectMessage *dm = [[DirectMessage alloc] initWithMessageDictionary:d];
			[_messages addObject:dm];
			[dm release];
		}
		
		dmsReceived = YES;
		
		//go grab sent messages
		[_engine getSentDirectMessagesSinceID:1 startingAtPage:1];
		
	} else {
		//populate the sent messages
		_sentMessages = [[NSMutableArray alloc] init];
		for(NSDictionary *d in messages) {
			//NSLog(@"Sent Messages Received: %@", messages);
			DirectMessage *dm = [[DirectMessage alloc] initWithMessageDictionary:d];
			[_sentMessages addObject:dm];
			[dm release];
		}
		[self sortMessages];
	}
}


-(void)sortMessages{
	NSLog(@"calling sorted messages!");
	//first need to make a list of unique id's that is in my box, on the sent messages and received messages side
	//mutable sets are apparently forced to contain all unique values so im using that
	NSMutableSet *interactedAuthors = [[NSMutableSet alloc] init];
	
	for(DirectMessage *dm in _messages) {
		[interactedAuthors addObject:[dm author]];
	}
	
	for(DirectMessage *dm in _sentMessages) {
		[interactedAuthors addObject:[dm sentTo]];
	}
	
	_messageDict = [[NSMutableDictionary alloc] init];
	
	for(NSString *author in interactedAuthors)
	{
		//compare the current author to authors in messages & sent messages arrays
		//go through messages array
		NSMutableArray *currentContents = [[NSMutableArray alloc] init];
		
		for(DirectMessage *dm in _messages)
		{
			if([author isEqualToString:[dm author]]){
				[currentContents addObject:dm];
			}
		}
		
		for(DirectMessage *dm in _sentMessages)
		{
			if([author isEqualToString:[dm sentTo]]){
				[currentContents addObject:dm];
			}
		}
		
		[_messageDict setValue:currentContents forKey:author];
		
		[currentContents release];
	}
	
	//NSLog(@"message dictionary: %@", _messageDict);
	
	NSArray *tmpArray = [[NSArray alloc] initWithArray:[[_messageDict allKeys] sortedArrayUsingSelector:@selector(compare:)]]; 
	self._authorList = [[NSArray alloc] initWithArray:tmpArray];
	[tmpArray release];
	
	//NSLog(@"author list: %d", [self._authorList count]);
	
	//we'll need to order the list by date as well...
	
	//this needs to scroll through both arrays and sort them properly for populating the main message table
	//NSLog(@"first author list item: %@", [_authorList objectAtIndex:1]);
	[_tableView reloadData];
}


- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
	NSString *messageSelected = [_messages objectAtIndex:indexPath.row];
	
	//NSString *msg = [NSString stringWithFormat:@"You have selected %@", messageSelected];
//	UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Message Selected"
//													message:msg delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
	
	//we want the detail table to show itself here with the items in the message dictionary, so it can populate with all of those items...
	
	
	//NSLog(@"message selected: %@", [(DirectMessage*)[_messages objectAtIndex:indexPath.row] message]);
	//[alert show];
	//[alert release];
}


- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
	//NSLog(@"header title: %@", [self._authorList objectAtIndex:section]);
	return [self._authorList objectAtIndex:section];
}

// Customize the number of sections in the table view.
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
	NSLog(@"authorlist count from number of sections: %d", [self._authorList count]);
	return [self._authorList count];
}

// Customize the number of rows in the table view.
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	NSString *aut = [_authorList objectAtIndex:section];
	NSMutableArray *messSection = [_messageDict objectForKey:aut];
	//NSLog(@"number of rows in section: %d", [messSection count]);
	return [messSection count];
}


-(NSString *)sendMessage:(id)sender {
	[_engine sendDirectMessage:textField.text to:userName.text];	
}


-(NSString *)refreshMessages:(id)sender {
	dmsReceived = NO;
	[_engine getDirectMessagesSinceID:1 startingAtPage:1];
}


#pragma mark UITableViewDataSource Methods 

//- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
//	
//	return [_messages count];
//}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *identifier = @"cell";
	UITableViewCell *cell = [_tableView dequeueReusableCellWithIdentifier:identifier];
	
	if(!cell) {
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:identifier];
		[cell setBackgroundColor:[UIColor clearColor]];
	}
	
	//NSString *year = [self.years objectAtIndex:[indexPath section]];
	//NSArray *movieSection = [self.movieTitles objectForKey:year];
	
	//NSLog(@"building table");
	
	//cell.textLabel.text = [movieSection objectAtIndex:[indexPath row]];
	//NSLog(@"dictionary: %@", _messageDict);
	NSString *athr = [[NSString alloc] initWithString:[_authorList objectAtIndex:indexPath.section]];
	NSArray *mssgSection = [[NSArray alloc] initWithArray:[_messageDict objectForKey:athr]];
	
	[cell.textLabel setNumberOfLines:7];
	
	NSString *myLabel = [[NSString alloc] initWithString:[[mssgSection objectAtIndex:indexPath.row] message]];
	
	//if ([[mssgSection objectAtIndex:indexPath.row] isSentMessage] == YES) {
//		myLabel = [[mssgSection objectAtIndex:indexPath.row] message];
//	} else {
//		myLabel = [[mssgSection objectAtIndex:indexPath.row] message];
//	}
	
	//NSLog(@"current message section: %@", mssgSection);
	//NSLog(@"writing to cell: %@", myLabel);
	
	[cell.textLabel setText:myLabel];
	[myLabel release];
	
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
