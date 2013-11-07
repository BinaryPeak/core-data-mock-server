//
//  CoreDataUtil.m
//  MockServerTest
//
//  Created by Dan Nilsson on 10/31/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import "CoreDataUtil.h"
#import <CoreData/CoreData.h>

@implementation CoreDataUtil

#pragma mark - Utility functions

+(NSArray*) getAllOfClass:(Class) class inContext:(NSManagedObjectContext*) context {
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:NSStringFromClass(class) inManagedObjectContext:context];
    [fetchRequest setEntity:entity];
    return [context executeFetchRequest:fetchRequest error:nil];
}

+(void)deleteAllOfClass:(Class) class except:(NSArray*) objects inContext:(NSManagedObjectContext*) context {
    NSArray* allObjects = [self getAllOfClass:class inContext:context];
    NSMutableArray* filtered = [allObjects mutableCopy];
    [filtered removeObjectsInArray:objects];
    
    for(NSManagedObject* object in filtered) {
        [context deleteObject:object];
    }
}

+(NSDictionary*) managedObjectToDictionary:(NSManagedObject*) object {
    NSEntityDescription* descr = [object entity];
    
    NSDictionary* keys = [descr attributesByName];
    NSMutableDictionary* ret = [NSMutableDictionary dictionary];
    
    for(NSString* key in [keys allKeys]) {
        [ret setValue:[object valueForKey:key] forKey:key];
    }
    
    return ret;
}

+(NSString*) getIndexedPropertyWithDescription:(NSEntityDescription*) descr inContext:(NSManagedObjectContext*) context
{
    NSDictionary* attributes = [descr attributesByName];
    
    for(NSString* key in [attributes allKeys]) {
        NSAttributeDescription* descr = [attributes valueForKey:key];
        if([descr isIndexed]) {
            return key;
        }
    }
    
    return nil;
}

+(NSManagedObject*) updateOrCreateObjectOfClass:(Class) class
                                 fromDictionary:(NSDictionary*) dictionary
                                      inContext:(NSManagedObjectContext*) context
{
    NSString* className = NSStringFromClass(class);
    NSEntityDescription* descr = [NSEntityDescription entityForName:className inManagedObjectContext:context];

    NSString* indexedKey = [self getIndexedPropertyWithDescription:descr inContext:context];
    
    if(!indexedKey) {
        NSLog(@"Error: No indexed attribute for class %@", NSStringFromClass(class));
        return nil;
    }
    
    NSFetchRequest *request = [[NSFetchRequest alloc] init];

    NSPredicate *pred = [NSPredicate predicateWithFormat:@"%K == %@", indexedKey, [dictionary valueForKey:indexedKey]];

    [request setEntity:descr];
    [request setPredicate:pred];
    
    NSArray *objects = [context executeFetchRequest:request error:nil];
    NSManagedObject* object = nil;
    
    if([objects count] == 0) {
        object = [NSEntityDescription insertNewObjectForEntityForName:className inManagedObjectContext:context];
    } else {
        object = objects[0];
    }
    
    for(NSString* key in dictionary) {
        if([descr.attributesByName valueForKey:key]) {
            [object setValue:dictionary[key] forKey:key];
        } else {
            NSLog(@"WARNING: Unknown attribute \"%@\" for class \"%@\"", key, className);
        }
    }
    
    return object;
}

@end
