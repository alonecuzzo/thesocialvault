//
//  DirectMessage.h
//  TwitterTabbedTest
//
//  Created by cuzzo on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface DirectMessage : NSObject {
	NSDictionary *contents;
	BOOL isSentMessage;
}

@property BOOL isSentMessage;

-(NSString*)message;
-(NSString*)author;
-(NSString*)sentTo;
-(NSDictionary*)dict;

@end
