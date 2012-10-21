//
//  XMLServerConnector.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerConnector.h"

@implementation ServerConnector

+(id) sharedServerConnector
{
    static ServerConnector *connector = nil;
    @synchronized (self)
    {
        if (connector == nil)
        {
            connector = [[self alloc] init];
        }
    }
    return connector;
}

-(BOOL) loginWithUser: (NSString*) user andPassword: (NSString*) password
{
    return FALSE;
}

-(NSMutableArray*) loadEvents
{
    return nil;
}

-(BOOL) setMyStatusForEvent: (NSString*) eventId to: (Status) status
{
    return FALSE;
}

@end
