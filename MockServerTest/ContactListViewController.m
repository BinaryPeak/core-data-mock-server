//
//  ViewController.m
//  MockServerTest
//
//  Created by Dan Nilsson on 10/30/13.
//  Copyright (c) 2013 Dan Nilsson. All rights reserved.
//

#import "ContactListViewController.h"
#import "AFNetworking.h"
#import "AppDelegate.h"
#import "CoreDataUtil.h"
#import "Contact.h"
#import "AddNewContactViewController.h"
#import "FetchedResultsTableUpdater.h"

//#define BASE_URL @"http://realserver.com"
#define BASE_URL @"mockserver://"

@interface ContactListViewController () <UITableViewDataSource, NSFetchedResultsControllerDelegate>
@property (nonatomic, strong) AFHTTPRequestOperationManager* httpManager;
@property (nonatomic, strong) NSManagedObjectContext* managedObjectContext;
@property (nonatomic, strong) NSFetchedResultsController* fetchedResultsController;
@property (weak, nonatomic) IBOutlet UITableView *tableView;
@property (nonatomic, strong) FetchedResultsTableUpdater* tableUpdater;
@end

@implementation ContactListViewController

static NSString* kCellID = @"TableCell";


#pragma mark - UITableViewDataSource

-(UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:kCellID];
    
    if(!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:kCellID];
    }
    
    [self updateCell:cell atIndexPath:indexPath];
    return cell;
}

-(NSString*) tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section {
    return @"Contacts";
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    id sectionInfo = [[self.fetchedResultsController sections] objectAtIndex:section];
    return [sectionInfo numberOfObjects];
}

-(void) updateCell:(UITableViewCell*) cell atIndexPath:(NSIndexPath*) indexPath {
    Contact* contact = [self.fetchedResultsController objectAtIndexPath:indexPath];
    cell.textLabel.text = contact.name;
}

#pragma mark - Contact handling

- (void) updateContacts {
    [self.httpManager GET:@"contacts" parameters:nil success:^(AFHTTPRequestOperation *operation, NSDictionary* responseObject)
    {
        // AFNetworking is kind enough to parse the JSON response for us
        NSArray* contacts = [responseObject valueForKey:@"contacts"];
        
        NSMutableArray* activeContacts = [NSMutableArray array];
        for(NSDictionary* dict in contacts) {
            [activeContacts addObject:[CoreDataUtil updateOrCreateObjectOfClass:[Contact class] fromDictionary:dict inContext:self.managedObjectContext]];
        }

        // Since this is a simple example and the mock server creates new ID:s for the
        // objects on each launch we remove "stale" entries from old sessions.
        [CoreDataUtil deleteAllOfClass:[Contact class] except:activeContacts inContext:self.managedObjectContext];

        [self.managedObjectContext save:nil];
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
    }];
}

- (IBAction)addContact:(id)sender {
    AddNewContactViewController
    *controller = [self.storyboard instantiateViewControllerWithIdentifier:@"AddNewContactViewController"];

    controller.httpManager = self.httpManager;
    
    UINavigationController* container = [[UINavigationController alloc] initWithRootViewController:controller];
    
    [self presentViewController:container animated:YES completion:nil];
}

#pragma mark - View life cycle

-(void) viewWillAppear:(BOOL)animated {
    [self updateContacts];
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    self.httpManager = [[AFHTTPRequestOperationManager alloc] initWithBaseURL:[NSURL URLWithString:BASE_URL]];
    [self.httpManager setRequestSerializer:[[AFJSONRequestSerializer alloc] init]];

    // Access to context left simple and slightly inelegant for demonstration purposes
    AppDelegate* appDelegate = [[UIApplication sharedApplication] delegate];
    self.managedObjectContext = [appDelegate managedObjectContext];
    
    NSFetchRequest *fetchRequest = [[NSFetchRequest alloc] init];
    NSEntityDescription *entity = [NSEntityDescription
                                   entityForName:@"Contact" inManagedObjectContext:self.managedObjectContext];

    NSSortDescriptor *sort = [[NSSortDescriptor alloc] initWithKey:@"name" ascending:YES];
    [fetchRequest setSortDescriptors:[NSArray arrayWithObject:sort]];
    [fetchRequest setEntity:entity];
    
    self.tableUpdater = [[FetchedResultsTableUpdater alloc] init];
    self.tableUpdater.tableView = self.tableView;
    self.fetchedResultsController = [[NSFetchedResultsController alloc] initWithFetchRequest:fetchRequest
                                                                        managedObjectContext:self.managedObjectContext sectionNameKeyPath:nil
                                                                                   cacheName:@"Root"];
    self.fetchedResultsController.delegate = self.tableUpdater;
	[self.fetchedResultsController performFetch:nil];
}


@end
