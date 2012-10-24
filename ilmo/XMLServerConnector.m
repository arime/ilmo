//
//  XMLServerConnector.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLServerConnector.h"
#import "XMLEventParser.h"
#import "Utils.h"

@interface XMLServerConnector ()
@property (nonatomic, retain) XMLEventParser *eventParser;
@end

@implementation XMLServerConnector

@synthesize sessionId = _sessionId;
@synthesize eventParser = _eventParser;

enum {
    LOGIN_RETURN_KEY,
    LOGIN_RETURN_VALUE,
    LOGIN_RETURN_NUM_FIELDS
};

+(id) sharedServerConnector
{
    static XMLServerConnector *connector = nil;
    @synchronized (self)
    {
        if (connector == nil)
        {
            connector = [[self alloc] init];
        }
    }
    return connector;
}

-(BOOL) loginWithUser:(NSString *)user andPassword:(NSString *)password withCallback:(void(^)(BOOL))handler
{
    NSLog(@"Account: %@", user);
    
    NSString *loginUrlPrefix = @"http://www.osallistujat.com/ext/Login-vrs1.php?";
    NSString *loginParamUser = [NSString stringWithFormat:@"%@%@", @"u=", user];
    NSString *passwordHash = [Utils sha1:password];
    
    NSLog(@"Password hash: %@", passwordHash);

    NSString *loginParamPassword = [NSString stringWithFormat:@"%@%@", @"&p=", passwordHash];
    NSString *loginUrl = [NSString stringWithFormat:@"%@%@%@", loginUrlPrefix, loginParamUser, loginParamPassword];

    NSLog(@"Login url: %@", loginUrl);

    NSURL *url = [NSURL URLWithString:loginUrl];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *components = [dataString componentsSeparatedByString:@":"];
    
    BOOL success = NO;
    
    if ([components count] == LOGIN_RETURN_NUM_FIELDS)
    {
        NSString *key = [components objectAtIndex:LOGIN_RETURN_KEY];
        NSString *value = [components objectAtIndex:LOGIN_RETURN_VALUE];

        if ([key isEqualToString:@"Session"])
        {
            NSLog(@"Session id: %@", value);
            _sessionId = value;
            _eventParser = [XMLEventParser alloc];
            success = YES;
        }
        else
        {
            NSLog(@"Login error: %@: %@", key, value);
        }
    }
    else
    {
        NSLog(@"Login error: No data received from server");
    }

    return success;
}

-(NSMutableArray*) loadEvents
{
    NSString *eventsUrlPrefix = @"http://www.osallistujat.com/ext/Events-vrs1.php?session=";
    NSString *eventsUrl = [NSString stringWithFormat:@"%@%@", eventsUrlPrefix, _sessionId];
    
    NSLog(@"Events url: %@", eventsUrl);

    NSMutableArray *events = [_eventParser loadFromURL:eventsUrl];
    return events;
}

-(BOOL) setMyStatusForEvent: (NSString*) eventId to: (Status) status
{
    NSLog(@"Request set %@ to %d", eventId, (int)status);

    NSString *enrolUrlPrefix = @"http://www.osallistujat.com/ext/Enrol-vrs1.php?";
    NSString *enrolParamSession = [NSString stringWithFormat:@"%@%@", @"session=", _sessionId];
    NSString *enrolParamEvent = [NSString stringWithFormat:@"%@%@", @"&eventid=", eventId];
    
    NSString* statusString = [self statusAsString:status];
    
    NSString *enrolParamStatus = [NSString stringWithFormat:@"%@%@", @"&tuleeko=", statusString];
    NSString *enrolUrl = [NSString stringWithFormat:@"%@%@%@%@", enrolUrlPrefix, enrolParamSession, enrolParamEvent, enrolParamStatus];
    
    NSLog(@"Enrol URL: %@", enrolUrl);
    
    NSURL *url = [NSURL URLWithString:enrolUrl];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    
    NSLog(@"Return value: %@", dataString);

    return TRUE;
}



-(NSString*) statusAsString:(Status) status
{
    switch (status) {
        case ATTENDING_YES:
            return @"0";
        case ATTENDING_UNDECIDED:
            return @"1";
        case ATTENDING_NO:
        default:
            return @"2";
    }
}

@end
