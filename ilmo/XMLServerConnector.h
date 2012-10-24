//
//  XMLServerConnector.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "ServerConnector.h"

@interface XMLServerConnector: ServerConnector

@property (nonatomic, retain) NSString *sessionId;

+(id) sharedServerConnector;
-(BOOL) loginWithUser: (NSString*) user andPassword: (NSString*) password withCallback:(void(^)(BOOL))handler;
-(NSMutableArray*) loadEvents;
-(BOOL) setMyStatusForEvent: (NSString*) eventId to: (Status) status;

@end
