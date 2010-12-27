    //
//  MainFeedViewController.m
//  FacebookTabbedTest
//
//  Created by cuzzo on 12/27/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "MainFeedViewController.h"
#import "FBConnect.h"


static NSString* kAppId = @"121041231296367";

@implementation MainFeedViewController

@synthesize label = _label, facebook = _facebook;

 // The designated initializer.  Override if you create the controller programmatically and want to perform customization that is not appropriate for viewDidLoad.

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    if (!kAppId) {
		NSLog(@"missing app id!");
		exit(1);
		return nil;
	}
	
	
	if ((self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil])) {
		_permissions =  [[NSArray arrayWithObjects:
						  @"read_stream", @"offline_access",nil] retain];
	}
    return self;
}



// Implement viewDidLoad to do additional setup after loading the view, typically from a nib.
- (void)viewDidLoad {
	_facebook = [[Facebook alloc] initWithAppId:kAppId];
	[self.label setText:@"Login mah dude"];
	_fbButton.isLoggedIn = NO;
	[_fbButton updateImage];
   // [super viewDidLoad];
}


- (IBAction)fbButtonClick:(id)sender {
	if (_fbButton.isLoggedIn) {
		[self logout];
	} else {
		[self login];
	}
}

/**
 * Show the authorization dialog.
 */
- (void)login {
	[_facebook authorize:_permissions delegate:self];
	NSLog(@"should be trying to log asfdsin");
}

/**
 * Invalidate the access token and clear the cookie.
 */
- (void)logout {
	[_facebook logout:self];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation {
    // Overriden to allow any orientation.
    return YES;
}


/**
 * Called when the user has logged in successfully.
 */
- (void)fbDidLogin {
	NSLog(@"logged in");
	[self.label setText:@"logged in"];
	_fbButton.isLoggedIn = YES;
	[_fbButton updateImage];
}

/**
 * Called when the user canceled the authorization dialog.
 */
-(void)fbDidNotLogin:(BOOL)cancelled {
	NSLog(@"did not login");
}

- (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response {
	NSLog(@"received response");
};


/**
 * Called when a request returns and its response has been parsed into an object.
 * The resulting object may be a dictionary, an array, a string, or a number, depending
 * on the format of the API response.
 * If you need access to the raw response, use
 * (void)request:(FBRequest *)request didReceiveResponse:(NSURLResponse *)response.
 */
- (void)request:(FBRequest *)request didLoad:(id)result {
	if ([result isKindOfClass:[NSArray class]]) {
		result = [result objectAtIndex:0];
	}
	if ([result objectForKey:@"owner"]) {
		[self.label setText:@"Photo upload Success"];
	} else {
		[self.label setText:[result objectForKey:@"name"]];
		NSLog(@"here's the me response: %@", result);
	}
};

/**
 * Called when an error prevents the Facebook API request from completing successfully.
 */
- (void)request:(FBRequest *)request didFailWithError:(NSError *)error {
	[self.label setText:[error localizedDescription]];
};


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
