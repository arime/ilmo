//
//  ServerConnector.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface ServerConnector : NSObject

-(BOOL) loginWithUser: (NSString*) user andPassword: (NSString*) password;
-(NSMutableArray*) loadEvents;
-(BOOL) setMyStatusForEvent: (NSString*) eventId to: (NSString*) status;

@end
