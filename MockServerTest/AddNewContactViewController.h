//
//  AddNewContactViewController.h
//  MockServerTest
//
//  Created by Dan Nilsson on 11/4/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import <UIKit/UIKit.h>

@class AFHTTPRequestOperationManager;

@interface AddNewContactViewController : UIViewController

@property(strong, nonatomic) AFHTTPRequestOperationManager* httpManager;
@end
