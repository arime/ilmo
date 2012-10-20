//
//  XMLServerConnector.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerConnector.h"

@implementation ServerConnector

-(BOOL) loginWithUser: (NSString*) user andPassword: (NSString*) password
{
    return FALSE;
}

-(NSMutableArray*) loadEvents
{
    return nil;
}

-(BOOL) setMyStatusForEvent: (NSString*) eventId to: (NSString*) status
{
    return FALSE;
}

@end
