//
//  FetchedResultsTableUpdater.h
//  MockServerTest
//
//  Created by Dan Nilsson on 11/7/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import <Foundation/Foundation.h>

// Based on http://www.fruitstandsoftware.com/blog/2013/02/uitableview-and-nsfetchedresultscontroller-updates-done-right/
@interface FetchedResultsTableUpdater : NSObject<NSFetchedResultsControllerDelegate>

@property(weak, nonatomic) UITableView* tableView;


@end
