//
//  MockServerURLProtocol.m
//  MockServerTest
//
//  Created by Dan Nilsson on 10/30/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import "MockServerURLProtocol.h"
#import "MockServer.h"

@implementation MockServerURLProtocol
static float MOCKDATA_RESPONSE_DELAY = 0.0;

+(void) setDelay:(CGFloat) delay;
{
    MOCKDATA_RESPONSE_DELAY = delay;
}

+ (BOOL)canInitWithRequest:(NSURLRequest *)request {
    NSString* scheme = [[request URL] scheme];
    return [scheme isEqualToString:@"mockserver"];
}

- (void) stopLoading
{
    
}

- (void)startLoading
{
    NSURLRequest *request = [self request];
    
    id client = [self client];
    
    NSHTTPURLResponse* response = [[NSHTTPURLResponse alloc] initWithURL:[request URL]
                                                              statusCode:200 HTTPVersion:@""
                                                            headerFields:@{@"content-type":@"application/json"}];
    
    MockServerResponse* serverResponse = [[MockServer instance] handleRequest:request];
    
    NSError *error;

    NSData *jsonData = [NSJSONSerialization dataWithJSONObject:serverResponse.response
                                                       options:NSJSONWritingPrettyPrinted // Pass 0 if you don't care about the readability of the generated string
                                                         error:&error];
    NSString* responseString = [[NSString alloc] initWithData:jsonData encoding:NSUTF8StringEncoding];
    
    
    if (serverResponse.errorCode != 0) {
        NSError* err = [NSError errorWithDomain:@"MockURLResponse"
                                           code:serverResponse.errorCode
                                       userInfo:serverResponse.response];
        
        [client URLProtocol:self didFailWithError:err];
    } else if ([[request HTTPMethod] isEqualToString:@"GET"] && [responseString length] == 0){
        // We expect a body in the response from a GET request.
        NSError* err = [NSError errorWithDomain:@"MockURLResponse"
                                           code:1
                                       userInfo:@{@"info":@"Found no response"}];
        
        [client URLProtocol:self didFailWithError:err];
    } else {
        [client URLProtocol:self didReceiveResponse:response cacheStoragePolicy:NSURLCacheStorageNotAllowed];
        [client URLProtocol:self didLoadData:[responseString dataUsingEncoding:NSUTF8StringEncoding]];
        [client performSelector:@selector(URLProtocolDidFinishLoading:) withObject:self afterDelay:MOCKDATA_RESPONSE_DELAY];
    }
}

+ (NSURLRequest *)canonicalRequestForRequest:(NSURLRequest *)request
{
    return request;
}

@end
