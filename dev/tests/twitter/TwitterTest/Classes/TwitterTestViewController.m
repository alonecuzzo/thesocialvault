//
//  TwitterTestViewController.m
//  TwitterTest
//
//  Created by cuzzo on 12/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterTestViewController.h"

@implementation TwitterTestViewController


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


// Override to allow orientations other than the default portrait orientation.
- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    return YES;
}

-(void)viewDidAppear:(BOOL)animated{
	if(_engine) return;
	
	_engine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
	_engine.consumerKey = @"lF5Y33zY1JPGhDiM6RZJw";
	_engine.consumerSecret = @"XW46AO4cQ0qde6f8A9HyYqy1fAsVITBXINFFgMLVU";
	
	UIViewController *controller = [SA_OAuthTwitterController controllerToEnterCredentialsWithTwitterEngine: _engine delegate: self];
	
	if (controller)
		[self presentModalViewController: controller animated: YES];
	else {
		tweets = [[NSMutableArray alloc] init];
		[self updateStream:nil];
	}	
}


-(IBAction)updateStream:(id)sender {
	
}

-(IBAction)tweet:(id)sender {
	
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
