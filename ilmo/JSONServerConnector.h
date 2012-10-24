//
//  JSONServerConnector.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/24/12.
//
//

#import <Foundation/Foundation.h>
#import "Event.h"
#import "LoginHandler.h"

@interface JSONServerConnector : NSObject {
    NSString* _sessionId;
    LoginHandler* _loginHandler;
    User* _user;
    void (^_callback)(BOOL success);
}

+(id) sharedServerConnector;
-(void) loginWithUser: (NSString*) user password: (NSString*) password andCallback: (void(^)(BOOL)) handler;
-(void) loadEventsWithCallback: (void(^)(NSMutableArray*)) handler;
-(void) setStatusForEvent: (NSString*) eventId to: (Status) status withCallback: (void(^)(BOOL)) handler;

@end
