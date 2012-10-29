//
//  LoginHandler.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/27/12.
//
//

#import "ServerResponseHandler.h"
#import "User.h"
#import <Foundation/Foundation.h>

@interface LoginHandler : ServerResponseHandler

@end

@interface NSObject(LoginHandlerDelegateMethods)

- (void)didCompleteLogin:(LoginHandler*)handler withUser:(User*) user;

@end
