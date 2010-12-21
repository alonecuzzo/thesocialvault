//
//  DirectMessage.m
//  TwitterTabbedTest
//
//  Created by cuzzo on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import "DirectMessage.h"


@implementation DirectMessage

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
	return [contents objectForKey:@"sender_screen_name"];
}


-(NSString *)sentTo {
	return [contents objectForKey:@"recipient_screen_name"];
}

-(NSDictionary *)dict {
	return contents;
}


@end
