//
//  SignUpHandler.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/30/12.
//
//

#import "SignUpHandler.h"

@implementation SignUpHandler

- (void)connection:(NSURLConnection *)connection
  didFailWithError:(NSError *)error
{
    [super connection:connection didFailWithError:error];
    [[super delegate] signUp:self didCompleteWithResult:NO];
    
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
    [[super delegate] signUp:self didCompleteWithResult:[status intValue] == 1];
}

@end
