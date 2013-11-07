//
//  MockServerURLProtocol.h
//  MockServerTest
//
//  Created by Dan Nilsson on 10/30/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class MockServer;

@interface MockServerURLProtocol : NSURLProtocol
+(void) setDelay:(CGFloat) delay;
@end
