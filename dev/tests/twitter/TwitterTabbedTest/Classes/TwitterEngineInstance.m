//
//  TwitterEngineInstance.m
//  TwitterTabbedTest
//
//  Created by cuzzo on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "TwitterEngineInstance.h"


@implementation TwitterEngineInstance

@synthesize myEngine;

static TwitterEngineInstance *myInstance = nil;
static NSObject *myDel = nil;

+(TwitterEngineInstance*)sharedInstance:(NSObject *)myDelegate {
	
	myDel = myDelegate;
	
	@synchronized([TwitterEngineInstance class]){
		//check to see if there's already an instance
		if(!myInstance)
		{
			myInstance = [[self alloc] init];
		}
		return myInstance;
	}
}

-(id)init
{
	@synchronized(self) {
		[super init];	
		//currentStation = [[NSDecimalNumber alloc] initWithString:@"0.0"];
		NSLog(@"initializing");
		myEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:myDel];
		myEngine.consumerKey = @"lF5Y33zY1JPGhDiM6RZJw";
		myEngine.consumerSecret = @"XW46AO4cQ0qde6f8A9HyYqy1fAsVITBXINFFgMLVU";
		return self;
	}
}

-(SA_OAuthTwitterEngine*)getEngine{
	@synchronized(self){
		return myEngine;
	}
}

@end
