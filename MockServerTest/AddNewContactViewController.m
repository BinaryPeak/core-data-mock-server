//
//  AddNewContactViewController.m
//  MockServerTest
//
//  Created by Dan Nilsson on 11/4/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import "AddNewContactViewController.h"
#import "AFNetworking.h"

@interface AddNewContactViewController () <UITextFieldDelegate>
@property (weak, nonatomic) IBOutlet UITextField *textField;
@property (weak, nonatomic) IBOutlet UIActivityIndicatorView *activityIndicator;
@end

@implementation AddNewContactViewController

- (void) requestDone {
    self.navigationController.view.userInteractionEnabled = YES;
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)createContact {
    [self.activityIndicator startAnimating];
    self.navigationController.view.userInteractionEnabled = NO;
    
    NSDictionary* parameters = @{@"name": self.textField.text};

    [self.httpManager POST:@"contacts/new" parameters:parameters success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
     {
         [self requestDone];
     } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
         NSLog(@"Error: %@", error);
         [self requestDone];
     }];
}

- (void) viewWillAppear:(BOOL)animated {
    [self.textField becomeFirstResponder];
    [super viewWillAppear:animated];
}

- (IBAction)cancelTapped:(id)sender {
    [self dismissViewControllerAnimated:YES completion:nil];
}

- (IBAction)viewTapped:(id)sender {
    [self.textField resignFirstResponder];
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {
    [textField resignFirstResponder];
    
    [self createContact];
    
    return NO;
}

@end
