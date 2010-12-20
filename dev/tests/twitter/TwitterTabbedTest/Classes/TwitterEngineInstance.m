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
@synthesize myString;

static TwitterEngineInstance *myInstance = nil;

+(TwitterEngineInstance*)sharedInstance:(NSObject *)myDelegate {
	
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
		myString = @"hey there";
		NSLog(@"initializing");
		myEngine = [[SA_OAuthTwitterEngine alloc] initOAuthWithDelegate:self];
		myEngine.consumerKey = @"lF5Y33zY1JPGhDiM6RZJw";
		myEngine.consumerSecret = @"XW46AO4cQ0qde6f8A9HyYqy1fAsVITBXINFFgMLVU";
		return self;
	}
}

-(NSString*)getMyString{
	@synchronized(self){
		return myString;
	}
}

-(SA_OAuthTwitterEngine*)getEngine{
	@synchronized(self){
		return myEngine;
	}
}

@end
