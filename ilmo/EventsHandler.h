//
//  EventsHandler.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/29/12.
//
//

#import "ServerResponseHandler.h"
#import <Foundation/Foundation.h>

@interface EventsHandler : ServerResponseHandler

@end

@interface NSObject(EventsHandlerDelegateMethods)

- (void)loadEvents:(EventsHandler*)handler didCompleteWithEvents:(NSMutableArray*)events;

@end
