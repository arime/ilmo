//
//  ViewController.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ViewController.h"
#import "XMLEventParser.h"
#include <CommonCrypto/CommonDigest.h>

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

- (NSString*)userAccount
{
    NSString* userAccount = [[NSUserDefaults standardUserDefaults] stringForKey:@"account"];
    return userAccount;
}

- (NSString*)userPasswordHash
{
    NSString* password = [[NSUserDefaults standardUserDefaults] stringForKey:@"password"];
    NSString* hash = [self sha1:password];
    return hash;
}

-(NSString*) sha1:(NSString*)input
{
    const char *cstr = [input cStringUsingEncoding:NSUTF8StringEncoding];
    NSData *data = [NSData dataWithBytes:cstr length:input.length];
    
    uint8_t digest[CC_SHA1_DIGEST_LENGTH];
    
    CC_SHA1(data.bytes, data.length, digest);
    
    NSMutableString* output = [NSMutableString stringWithCapacity:CC_SHA1_DIGEST_LENGTH * 2];
    
    for(int i = 0; i < CC_SHA1_DIGEST_LENGTH; i++)
        [output appendFormat:@"%02x", digest[i]];
    
    return output;
    
}

- (void)loadEvents
{    
    NSString *user = [self userAccount];
    NSString *password = [self userPasswordHash];
    NSLog(@"Account: %@", user);
    NSLog(@"Password: %@", password);

    NSString *loginUrlPrefix = @"http://www.osallistujat.com/ext/Login-vrs1.php?";
    NSString *loginParamUser = [NSString stringWithFormat:@"%@%@", @"u=", user];
    NSString *loginParamPassword = [NSString stringWithFormat:@"%@%@", @"&p=", password];
    NSString *loginUrl = [NSString stringWithFormat:@"%@%@%@", loginUrlPrefix, loginParamUser, loginParamPassword];
    
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
