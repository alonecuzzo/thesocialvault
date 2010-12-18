//
//  Tweet.h
//  TwitterTest
//
//  Created by cuzzo on 12/18/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>


@interface Tweet : NSObject {
	NSDictionary *contents;
}

-(NSString*)tweet;
-(NSString*)author;
@end
