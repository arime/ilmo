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
    
    _sessionId = [components objectAtIndex:1];

    NSLog(@"Session ID: %@", _sessionId);
    
    _eventParser = [XMLEventParser alloc];
    return TRUE;
}

-(NSMutableArray*) loadEvents
{
    NSString *eventsUrlPrefix = @"http://www.osallistujat.com/ext/Events-vrs1.php?session=";
    NSString *eventsUrl = [NSString stringWithFormat:@"%@%@", eventsUrlPrefix, _sessionId];
    
    NSLog(@"Events URL: %@", eventsUrl);
        
    return [_eventParser loadFromURL:eventsUrl];
}

-(BOOL) setMyStatusForEvent: (NSString*) eventId to: (NSString*) status
{
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

@end
