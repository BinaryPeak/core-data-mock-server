//
//  MockServerResponse.m
//  MockServerTest
//
//  Created by Dan Nilsson on 10/31/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import "MockServerResponse.h"

@implementation MockServerResponse

+(MockServerResponse*) responseWithDictionary:(NSDictionary*) dictionary errorCode:(int)errorCode {
    MockServerResponse* ret = [[MockServerResponse alloc] init];
    
    ret.response = dictionary;
    ret.errorCode = errorCode;
    
    return ret;
}

@end
