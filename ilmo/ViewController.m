//
//  ViewController.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "EventCell.h"
//#import "XMLServerConnector.h"
#import "JSONServerConnector.h"

@interface ViewController ()
@property (nonatomic, retain) JSONServerConnector *serverConnector;
@property (nonatomic, retain) NSMutableArray *events;
@end

@implementation ViewController

@synthesize eventTable = _eventTable;

@synthesize serverConnector = _serverConnector;
@synthesize events = _events;
@synthesize rightSwipeRecognizer = _rightSwipeRecognizer;
@synthesize leftSwipeRecognizer = _leftSwipeRecognizer;

@synthesize activity = _activity;

- (void)viewDidLoad
{
    [super viewDidLoad];

    _serverConnector = [JSONServerConnector sharedServerConnector];
    [_eventTable setDelegate:self];
    [_eventTable setDataSource:self];
    
    // Set table footer view to hide bottom cell separator for extra rows
    [_eventTable setTableFooterView:[[UIView alloc] initWithFrame:CGRectMake(0, 0, 1, 1)]];
    
    _rightSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [_rightSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionRight];
    
    _leftSwipeRecognizer = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(handleSwipe:)];
    [_leftSwipeRecognizer setDirection:UISwipeGestureRecognizerDirectionLeft];

    
    [_rightSwipeRecognizer setDelegate:self];
    [_leftSwipeRecognizer setDelegate:self];
    
    [self.view addGestureRecognizer:_rightSwipeRecognizer];
    [self.view addGestureRecognizer:_leftSwipeRecognizer];

    [[NSNotificationCenter defaultCenter]
        addObserver:self 
        selector:@selector(applicationDidBecomeActive:) 
        name:UIApplicationDidBecomeActiveNotification 
        object:nil];
    
    _activity = [[ActivityIndicatorView alloc] init];
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
}

- (void)viewDidUnload
{
    [self setEventTable:nil];
    [self setTitle:nil];
    [self setRightSwipeRecognizer:nil];
    [self setLeftSwipeRecognizer:nil];

    [[NSNotificationCenter defaultCenter]
        removeObserver:self
        name:UIApplicationDidBecomeActiveNotification
        object:nil];

    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)applicationDidBecomeActive:(UIApplication *)application
{
    [[NSUserDefaults standardUserDefaults] synchronize];
    NSString *user = [self userAccount];
    NSString *password = [self userPassword];
    [_serverConnector loginWithUser:user password:password andCallback:^(BOOL success){
        NSLog(@"Login result: %d", success);
        if (success)
        {
            [self loadEvents];
        }
    }];
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
    [_activity startAnimatingOverView:self.view];

    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        [_serverConnector loadEventsWithCallback:^(NSMutableArray *events){
            NSLog(@"Loaded events: %d", [events count]);
            _events = events;
            dispatch_async(dispatch_get_main_queue(), ^{
                [_eventTable reloadData];
                [_activity stopAnimating];
            });
        }];
    });
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
    
    return [_events count];
    
}

-(IBAction)handleSwipe:(UISwipeGestureRecognizer *)recognizer {
    //Get location of the swipe
    CGPoint location = [recognizer locationInView:self.eventTable];
    
    // if location > than the list last list item, do nothing.
    int lastRow = [self.eventTable numberOfRowsInSection:0];
    int rowheight = self.eventTable.rowHeight;
    if (location.y > lastRow * rowheight) {
        NSLog(@"Click past last item");
        return;
    }
    
    //Get the corresponding index path within the table view
    NSIndexPath *indexPath = [self.eventTable indexPathForRowAtPoint:location];

    Event *event = [_events objectAtIndex:indexPath.row];
    if( recognizer.direction == UISwipeGestureRecognizerDirectionRight) {
        NSLog(@"Swiped right at %@", event.title);
        [self setStatusForEvent:event status:ATTENDING_YES];
    }
    else if (recognizer.direction == UISwipeGestureRecognizerDirectionLeft) {
        NSLog(@"Swiped left at %@", event.title);
        [self setStatusForEvent:event status:ATTENDING_NO];
    }
}

- (void)setStatusForEvent:(Event *)event status:(Status) status {
    NSLog(@"Request set status for event %@ to %d", [event id], status);
    [_activity startAnimatingOverView:self.view];
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, 0), ^{
        
        [_serverConnector setStatusForEvent:event.id to:status withCallback:^(BOOL result) {
            NSLog(@"Set status result: %d", result);
        }];
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"Set status complete");
            [_activity stopAnimating];
        });
    });
}

@end
