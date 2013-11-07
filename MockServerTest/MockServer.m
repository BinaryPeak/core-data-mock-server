//
//  MockServer.m
//  MockServerTest
//
//  Created by Dan Nilsson on 10/30/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import "MockServer.h"
#import <CoreData/CoreData.h>
#import "Account.h"
#import "Contact.h"
#import "CoreDataUtil.h"
#import "AFNetworking.h"

@interface MockServer()
@property (strong, nonatomic) NSManagedObjectContext* context;
@property (strong, nonatomic) Account* account;
@property (strong, nonatomic) Contact* contact;
@property (assign, nonatomic) int accountIDCounter;
@end

@implementation MockServer

+(MockServer*) instance {
    static MockServer* server = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        server = [[MockServer alloc] init];
    });
    
    return server;
}


#pragma mark - REST utils

-(void) createAndAddContactWithName:(NSString*) name {
    Contact* contact = [NSEntityDescription insertNewObjectForEntityForName:@"Contact" inManagedObjectContext:self.context];
    contact.name = name;
    contact.accountId = @(self.accountIDCounter++);
}

-(void) initMockData {
    self.account = [NSEntityDescription insertNewObjectForEntityForName:@"Account" inManagedObjectContext:self.context];
    self.account.name = @"Test Person";
    
    NSArray* names = @[@"John Doe", @"Jennifer Johnson", @"Jimmy Anderson", @"Test Person"];
    
    for(NSString* name in names) {
        [self createAndAddContactWithName:name];
    }
}

-(MockServerResponse*) GET_contacts {
    NSArray* contacts = [CoreDataUtil getAllOfClass:[Contact class] inContext:self.context];
    
    NSMutableArray* contactDictionaries = [NSMutableArray arrayWithCapacity:[contacts count]];
    
    for (Contact *contact in contacts) {
        [contactDictionaries addObject:[CoreDataUtil managedObjectToDictionary:contact]];
    }
    
    NSDictionary* response = @{@"contacts": contactDictionaries};

    return [MockServerResponse responseWithDictionary:response errorCode:0];
}


-(MockServerResponse*) POST_contacts_new:(NSURLRequest*) request {
    NSDictionary* parsedObject = [NSJSONSerialization
                                  JSONObjectWithData:request.HTTPBody
                                  options:0
                                  error:nil];

    [self createAndAddContactWithName:parsedObject[@"name"]];
    NSDictionary* response = @{};
    
    return [MockServerResponse responseWithDictionary:response errorCode:0];
}

-(id) init {
    self = [super init];
    
    if(self) {
        self.accountIDCounter = 0;
        self.context = [[NSManagedObjectContext alloc] initWithConcurrencyType:NSConfinementConcurrencyType];
        
        NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"Model" withExtension:@"momd"];
        NSManagedObjectModel* managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
        
        NSPersistentStoreCoordinator* coordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:managedObjectModel];
        
        [self.context setPersistentStoreCoordinator:coordinator];
        [self initMockData];
    }
    
    return self;
}

-(MockServerResponse*) handleRequest:(NSURLRequest*) request {
    NSString* requestString = request.URL.path;

    NSLog(@"Mock request: %@", request.URL);
    
    if([requestString isEqualToString:@"/contacts"]) {
        return [self GET_contacts];
    } else if([requestString isEqualToString:@"/contacts/new"]) {
        return [self POST_contacts_new:request];
    } else {
        MockServerResponse* ret = [[MockServerResponse alloc] init];
        ret.errorCode = 1;
        ret.response = @{};
        return ret;
    }
}

@end
