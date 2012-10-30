//
//  EventsHandler.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/29/12.
//
//

#import "EventsHandler.h"

@implementation EventsHandler

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [super connection:connection didFailWithError:error];
    [[super delegate] loadEvents:self didCompleteWithEvents:nil];

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

    [[super delegate] loadEvents:self didCompleteWithEvents:nil];
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
*/
}

@end
