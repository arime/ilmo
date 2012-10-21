//
//  XMLServerConnector.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLServerConnector.h"
#import "XMLEventParser.h"
#include <CommonCrypto/CommonDigest.h>

@interface XMLServerConnector ()
@property (nonatomic, retain) XMLEventParser *eventParser;
@end

@implementation XMLServerConnector

@synthesize sessionId = _sessionId;
@synthesize eventParser = _eventParser;

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

-(BOOL) loginWithUser:(NSString *)user andPassword:(NSString *)password
{
    NSLog(@"Request login with credentials");
    NSLog(@"Account: %@", user);
    
    NSString *loginUrlPrefix = @"http://www.osallistujat.com/ext/Login-vrs1.php?";
    NSString *loginParamUser = [NSString stringWithFormat:@"%@%@", @"u=", user];
    NSString *passwordHash = [self sha1:password];
    
    NSLog(@"Password: %@", passwordHash);

    NSString *loginParamPassword = [NSString stringWithFormat:@"%@%@", @"&p=", passwordHash];
    NSString *loginUrl = [NSString stringWithFormat:@"%@%@%@", loginUrlPrefix, loginParamUser, loginParamPassword];

    NSURL *url = [NSURL URLWithString:loginUrl];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    
    NSString *dataString = [[NSString alloc] initWithData:data encoding:NSUTF8StringEncoding];
    NSArray *components = [dataString componentsSeparatedByString:@":"];
    NSString *status = [components objectAtIndex:0];
    
    _sessionId = [components objectAtIndex:1];

    NSLog(@"Session ID: %@", _sessionId);
    
    _eventParser = [XMLEventParser alloc];

    // On error, components at 1 is error
    return [status isEqualToString:@"Session"];

}

-(NSMutableArray*) loadEvents
{
    NSString *eventsUrlPrefix = @"http://www.osallistujat.com/ext/Events-vrs1.php?session=";
    NSString *eventsUrl = [NSString stringWithFormat:@"%@%@", eventsUrlPrefix, _sessionId];
    
    NSLog(@"Events URL: %@", eventsUrl);
        
    return [_eventParser loadFromURL:eventsUrl];
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
