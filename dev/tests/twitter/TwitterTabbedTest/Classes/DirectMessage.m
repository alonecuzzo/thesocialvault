//
//  DirectMessage.m
//  TwitterTabbedTest
//
//  Created by cuzzo on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DirectMessage.h"


@implementation DirectMessage

@synthesize isSentMessage;

-(id) initWithMessageDictionary:(NSDictionary *)_contents {
	if(self = [super init]) {
		contents = _contents;
		[contents retain];
	}
	
	return self;
}


-(NSString *)message {
	return [contents objectForKey:@"text"];
}


-(NSString *)author {
	isSentMessage = NO;
	return [contents objectForKey:@"sender_screen_name"];
}


-(NSString *)sentTo {
	isSentMessage = YES;
	return [contents objectForKey:@"recipient_screen_name"];
}

-(NSDictionary *)dict {
	return contents;
}


@end
