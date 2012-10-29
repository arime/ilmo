//
//  EventsHandler.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/29/12.
//
//

#import "ServerResponseHandler.h"
#import "User.h"
#import <Foundation/Foundation.h>

@interface EventsHandler : ServerResponseHandler

@end

@interface NSObject(EventsHandlerDelegateMethods)

- (void)didCompleteLoadEvents:(EventsHandler*)handler withEvents:(NSMutableArray*) events;

@end
