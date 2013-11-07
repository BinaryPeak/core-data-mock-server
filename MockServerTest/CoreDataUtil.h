//
//  CoreDataUtil.h
//  MockServerTest
//
//  Created by Dan Nilsson on 10/31/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>

@class NSManagedObject;
@class NSManagedObjectContext;

@interface CoreDataUtil : NSObject
#pragma mark - Utility functions


/**
 *  Return all entities of NSManagedObject subclass class in the supplied context.
 */
+(NSArray*) getAllOfClass:(Class) class inContext:(NSManagedObjectContext*) context;

/**
 *  Based on the key names in the objects entity description, create a dictionary
 *  filled with the properties of the object. Will only work for really simple use
 *  cases.
 * 
 *  Please note that this is just a basic example of how it could be done. If you
 *  use RestKit for example you should probably look into RKEntityMapping instead. 
 *  Sometimes it's hard to do a 1-1 mapping between a JSON response and the 
 *  NSManagedObject (even though it's desirable), particularly with nested objects.
 */
+(NSDictionary*) managedObjectToDictionary:(NSManagedObject*) object;

/**
 *  Really simple method for creating or updating an existing object of type class
 *  from a dictionary of attributes. Requires that class has has an indexed attribute
 *  in order to perform updates.
 */
+(NSManagedObject*) updateOrCreateObjectOfClass:(Class) class fromDictionary:(NSDictionary*) dictionary inContext:(NSManagedObjectContext*) context;

/**
 *   Removes all objects in a context except those listed in objects.
 */
+(void)deleteAllOfClass:(Class) class except:(NSArray*) objects inContext:(NSManagedObjectContext*) context;
    
@end
