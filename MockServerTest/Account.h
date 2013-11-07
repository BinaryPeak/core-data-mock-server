//
//  Account.h
//  MockServerTest
//
//  Created by Dan Nilsson on 10/30/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>


@interface Account : NSManagedObject

@property (nonatomic, retain) NSString * name;
@property (nonatomic, retain) NSString * status;
@property (nonatomic, retain) NSNumber * accountId;

@end
