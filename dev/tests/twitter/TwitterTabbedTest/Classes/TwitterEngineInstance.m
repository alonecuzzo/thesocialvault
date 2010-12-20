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
static NSString *consumerKey = @"lF5Y33zY1JPGhDiM6RZJw";
static NSString *consumerSecret = @"XW46AO4cQ0qde6f8A9HyYqy1fAsVITBXINFFgMLVU";

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
		myEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:myDel];
		myEngine.consumerKey = consumerKey;
		myEngine.consumerSecret = consumerSecret;
		return self;
	}
}


-(SA_OAuthTwitterEngine*)getEngine:(NSObject *)myDelegate{
	@synchronized(self){
		NSLog(@"new delegate: %@", myDelegate);
		NSLog(@"old delegate: %@", myDel);
		
		[myDel release];
		myDel = myDelegate;
		[myEngine release];
		myEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:myDel];
		myEngine.consumerKey = consumerKey;
		myEngine.consumerSecret = consumerSecret;
		
		return myEngine;
	}
}

@end
