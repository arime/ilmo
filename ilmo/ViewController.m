//
//  ViewController.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "EventCell.h"
#import "XMLServerConnector.h"

@interface ViewController ()
@property (nonatomic, retain) ServerConnector *serverConnector;
@property (nonatomic, retain) NSMutableArray *events;
@end

@implementation ViewController

@synthesize eventTable = _eventTable;

@synthesize serverConnector = _serverConnector;
@synthesize events = _events;

- (void)viewDidLoad
{
    [super viewDidLoad];

    _serverConnector = [XMLServerConnector alloc];
    [_eventTable setDelegate:self];
    [_eventTable setDataSource:self];
    
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadEvents];
}

- (void)viewDidUnload
{
    [self setEventTable:nil];
    [self setTitle:nil];
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (NSString*)userAccount
{
    NSString* userAccount = [[NSUserDefaults standardUserDefaults] stringForKey:@"account"];
    return userAccount;
}

- (NSString*)userPassword
{
    NSString* password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    return password;
}


- (void)loadEvents
{    
    NSString *user = [self userAccount];
    NSString *password = [self userPassword];
    
    if ([_serverConnector loginWithUser:user andPassword:password])
    {
        NSLog(@"Login succesful.");
        _events = [_serverConnector loadEvents];
    }
    else
    {
        NSLog(@"Login failed.");
    }
    
    [_eventTable reloadData];
}

#pragma mark - Tableview Delegate methods
-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *eventCellIdentifier = @"EventCell";
    EventCell *cell = (EventCell*)[_eventTable dequeueReusableCellWithIdentifier:eventCellIdentifier];
    
    if (cell == nil) {
        cell = [[EventCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:eventCellIdentifier];
        
    }
     
    [cell setEvent:[_events objectAtIndex:indexPath.row]];
    
    [cell setBackgroundColor:[UIColor brownColor]];
    
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    
    NSLog(@"Objects at list %u", [_events count]);
    return [_events count];
    
}

@end
