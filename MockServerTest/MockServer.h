//
//  MockServer.h
//  MockServerTest
//
//  Created by Dan Nilsson on 10/30/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MockServerResponse.h"

@interface MockServer : NSObject

+(MockServer*) instance;

-(MockServerResponse*) handleRequest:(NSURLRequest*) request;
   
@end
