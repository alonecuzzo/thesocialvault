//
//  Tweet.m
//  TwitterTest
//
//  Created by cuzzo on 12/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "Tweet.h"


@implementation Tweet

-(id)initWithTweetDictionary:(NSDictionary*)_contents {
	
	if(self = [super init]) {
		
		contents = _contents;
		[contents retain];
	}
	
	return self;
}

-(NSString*)tweet {
	
	return [contents objectForKey:@"text"];
}

-(NSString*)author {
	
	return [[contents objectForKey:@"user"] objectForKey:@"screen_name"];
}
@end
