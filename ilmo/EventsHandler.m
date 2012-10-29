//
//  EventsHandler.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/29/12.
//
//

#import "EventsHandler.h"

//
//  LoginHandler.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/27/12.
//
//

#import "LoginHandler.h"
#import "User.h"

@implementation EventsHandler

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [super connection:connection didFailWithError:error];
    [[super delegate] didCompleteLoadEvents:self withEvents:nil];
    
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    [super connectionDidFinishLoading:connection];

    NSError* error;
    NSDictionary* json = [NSJSONSerialization
                          JSONObjectWithData:[super receivedData]
                          options:kNilOptions
                          error:&error];
    
    NSLog(@"%@", json);

    [[super delegate] didCompleteLoadEvents:self withEvents:nil];
/*
    NSNumber* status = [json objectForKey:@"status"];
    User* user = nil;
    
    if ([status intValue] == 1)
    {
        NSDictionary* userData = [json objectForKey:@"data"];
        user = [[User alloc] initWithJSON:userData];
    }
    else
    {
    }
    
    [[super delegate] didCompleteLogin:self withUser:user];
*/
}

@end

