//
//  EventsHandler.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/29/12.
//
//

#import "EventsHandler.h"
#import "Event.h"

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

    NSNumber* status = [json objectForKey:@"status"];
    NSMutableArray* events = nil;

    if ([status intValue] == 1)
    {
        events = [[NSMutableArray alloc] init];
        NSArray* eventsData = [json objectForKey:@"data"];
        NSEnumerator *e = [eventsData objectEnumerator];
        id object;
        while (object = [e nextObject])
        {
            NSDictionary* eventData = (NSDictionary*)object;
            Event* event = [[Event alloc] initWithJSON:eventData];
            [events addObject:event];
        }
    }

    [[super delegate] loadEvents:self didCompleteWithEvents:events];

}

@end
