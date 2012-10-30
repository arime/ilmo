//
//  SignUpHandler.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/30/12.
//
//

#import "ServerResponseHandler.h"
#import <Foundation/Foundation.h>

@interface SignUpHandler : ServerResponseHandler

@end

@interface NSObject(SignUpHandlerDelegateMethods)

- (void)signUp:(SignUpHandler*)handler didCompleteWithResult:(BOOL)success;

@end
