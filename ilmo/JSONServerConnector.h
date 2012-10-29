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
#import "EventsHandler.h"

@interface JSONServerConnector : NSObject {
    LoginHandler* _loginHandler;
    EventsHandler* _eventsHandler;
    User* _user;
    void (^_loginCallback)(BOOL success);
    void (^_loadEventsCallback)(NSMutableArray* events);
}

+(id) sharedServerConnector;
-(void) loginWithUser: (NSString*) user password: (NSString*) password andCallback: (void(^)(BOOL)) handler;
-(void) loadEventsWithCallback: (void(^)(NSMutableArray*)) handler;
-(void) setStatusForEvent: (NSString*) eventId to: (Status) status withCallback: (void(^)(BOOL)) handler;

@end
