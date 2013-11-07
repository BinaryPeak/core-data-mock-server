//
//  MockServerResponse.h
//  MockServerTest
//
//  Created by Dan Nilsson on 10/31/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MockServerResponse : NSObject
@property(assign, nonatomic) int errorCode;
@property(strong, nonatomic) NSDictionary* response;

+(MockServerResponse*) responseWithDictionary:(NSDictionary*) dictionary errorCode:(int) errorCode;

@end
