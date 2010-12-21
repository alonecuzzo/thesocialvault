//
//  TwitterEngineInstance.h
//  TwitterTabbedTest
//
//  Created by cuzzo on 12/20/10.
//  Copyright 2010 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "SA_OAuthTwitterEngine.h"
#import "SA_OAuthTwitterController.h"


@interface TwitterEngineInstance : NSObject {
	SA_OAuthTwitterEngine *myEngine;
}

@property (nonatomic, retain) SA_OAuthTwitterEngine *myEngine;

+(TwitterEngineInstance*)sharedInstance:(NSObject*)myDelegate;
-(void)setDelegate:(id)delegate;

@end
