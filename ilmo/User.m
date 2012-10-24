//
//  User.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/28/12.
//
//

#import "User.h"

@implementation User

@synthesize sessionId = _sessionId;

-(id) initWithJSON: (NSDictionary*) data
{
    NSString* sessionId = [data objectForKey:@"sessionId"];

    if (sessionId != nil)
    {
        _sessionId = sessionId;
        return self;
    }
    else
    {
        return nil;
    }
}

@end
