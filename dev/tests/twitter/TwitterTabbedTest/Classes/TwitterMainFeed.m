    //
//  TwitterMainFeed.m
//  TwitterTabbedTest
//
//  Created by cuzzo on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterMainFeed.h"
#import "Tweet.h"
#import "TwitterEngineInstance.h"

@implementation TwitterMainFeed

/*
 // The designated initializer. Override to perform setup that is required before the view is loaded.
 - (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
 self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
 if (self) {
 // Custom initialization
 }
 return self;
 }
 */

/*
 // Implement loadView to create a view hierarchy programmatically, without using a nib.
 - (void)loadView {
 }
 */


/*
 // Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
 - (void)viewDidLoad {
 [super viewDidLoad];
 }
 */
#pragma mark MGTwitterEngineDelegate Methods

- (void)requestSucceeded:(NSString *)connectionIdentifier {
	
	NSLog(@"Request Suceeded: %@", connectionIdentifier);
}

- (void)statusesReceived:(NSArray *)statuses forRequest:(NSString *)connectionIdentifier {
	
	tweets = [[NSMutableArray alloc] init];
	
	for(NSDictionary *d in statuses) {
		
		//NSLog(@"See dictionary: %@", d);
		
		Tweet *tweet = [[Tweet alloc] initWithTweetDictionary:d];
		[tweets addObject:tweet];
		[tweet release];
	}
	
	[tableView reloadData];
}

- (void)receivedObject:(NSDictionary *)dictionary forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"Recieved Object: %@", dictionary);
}

- (void)directMessagesReceived:(NSArray *)messages forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"Direct Messages Received: %@", messages);
}

- (void)userInfoReceived:(NSArray *)userInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"User Info Received: %@", userInfo);
}

- (void)miscInfoReceived:(NSArray *)miscInfo forRequest:(NSString *)connectionIdentifier {
	
	NSLog(@"Misc Info Received: %@", miscInfo);
}

// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
	if(_engine) return;
	
	_engine = [[TwitterEngineInstance sharedInstance:self] myEngine];
	
	//_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
//	_engine.consumerKey = @"lF5Y33zY1JPGhDiM6RZJw";
//	_engine.consumerSecret = @"XW46AO4cQ0qde6f8A9HyYqy1fAsVITBXINFFgMLVU";
	
	//NSLog(@"my engine from the feed is: %@", _engine);
	//NSLog(@"my string is: %@", [[TwitterEngineInstance sharedInstance:self] myString]);
	NSLog(@"my engine from the feed is: %@", _engine);
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller){
		NSLog(@"calling the modal view");
		[self presentModalViewController: controller animated: YES];
	} else {
		tweets = [[NSMutableArray alloc] init];
		[self updateStream:nil];
	}	
}

#pragma mark UITableViewDataSource Methods 

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
	
	return [tweets count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	NSString *identifier = @"cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identifier];
	
	if(!cell) {
		
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewStyleGrouped reuseIdentifier:identifier];
		[cell setBackgroundColor:[UIColor clearColor]];
	}
	
	[cell.textLabel setNumberOfLines:7];
	[cell.textLabel setText:[(Tweet*)[tweets objectAtIndex:indexPath.row] tweet]];
	
	return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
	
	return 150;
}


#pragma mark IBActions

-(IBAction)updateStream:(id)sender {
	
	[_engine getFollowedTimelineSinceID:1 startingAtPage:1 count:100];
}

-(IBAction)tweet:(id)sender {
	
	[textField resignFirstResponder];
	[_engine sendUpdate:[textField text]];
	[self updateStream:nil];
}

#pragma mark SA_OAuthTwitterEngineDelegate

- (void) storeCachedTwitterOAuthData: (NSString *) data forUsername: (NSString *) username {
	
	NSUserDefaults	*defaults = [NSUserDefaults standardUserDefaults];
	
	[defaults setObject: data forKey: @"authData"];
	[defaults synchronize];
}

- (NSString *) cachedTwitterOAuthDataForUsername: (NSString *) username {
	
	return [[NSUserDefaults standardUserDefaults] objectForKey: @"authData"];
}

#pragma mark SA_OAuthTwitterController Delegate

- (void) OAuthTwitterController: (SA_OAuthTwitterController *) controller authenticatedWithUsername: (NSString *) username {
	
	NSLog(@"Authenticated with user %@", username);
	
	tweets = [[NSMutableArray alloc] init];
	[self updateStream:nil];
}

- (void) OAuthTwitterControllerFailed: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Failure");
}

- (void) OAuthTwitterControllerCanceled: (SA_OAuthTwitterController *) controller {
	
	NSLog(@"Authentication Canceled");
}




- (void)didReceiveMemoryWarning {
	// Releases the view if it doesn't have a superview.
    [super didReceiveMemoryWarning];
	
	// Release any cached data, images, etc that aren't in use.
}

- (void)viewDidUnload {
	// Release any retained subviews of the main view.
	// e.g. self.myOutlet = nil;
}


- (void)dealloc {
    [super dealloc];
}

@end
