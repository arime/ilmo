//
//  ViewController.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "XMLEventParser.h"

@interface ViewController ()
@property (nonatomic, retain) XMLEventParser *eventParser;
@property (nonatomic, retain) NSMutableArray *events;
@end

@implementation ViewController

@synthesize eventParser = _eventParser;
@synthesize events = _events;

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.title = @"Tapahtumat";
	// Do any additional setup after loading the view, typically from a nib.
}

- (void)viewDidAppear:(BOOL)animated
{
    [self loadEvents];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    // Release any retained subviews of the main view.
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
}

- (void)loadEvents
{
    NSString *loginUrl = @"http://www.osallistujat.com/ext/Login-vrs1.php?u=ilmotesti&p=25978025e0899ffeece9b4d833298265f5c20689";
    NSURL *url = [NSURL URLWithString:loginUrl];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];

    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *components = [dataString componentsSeparatedByString:@":"];
    NSLog(@"Login output: %@", components);

    NSString *sessionId = [components objectAtIndex:1];
    NSString *eventsUrlPrefix = @"http://www.osallistujat.com/ext/Events-vrs1.php?session=";

    NSString *eventsUrl = [NSString stringWithFormat:@"%@%@", eventsUrlPrefix, sessionId];

    NSLog(@"Events URL: %@", eventsUrl);

    NSString *filePath = [[NSBundle mainBundle] pathForResource:@"events" ofType:@"xml"];
    NSLog(@"Events file: %@", filePath);

    _eventParser = [XMLEventParser alloc];

    //_events = [_eventParser loadFromURL:eventsUrl];
    _events = [_eventParser loadFromFile:filePath];

    for (id object in _events)
    {
        Event *event = (Event*)object;
        NSLog(@"Event: %@:%@", event.id, event.title);
    }
}

@end
