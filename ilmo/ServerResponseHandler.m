//
//  ServerResponseHandler.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/28/12.
//
//

#import "ServerResponseHandler.h"

@implementation ServerResponseHandler

@synthesize delegate = _delegate;
@synthesize receivedData = _receivedData;

-(id) init
{
    _receivedData = [NSMutableData alloc];
    return self;
}

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response
{
    NSLog(@"Received response");
    [_receivedData setLength:0];
}

- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data
{
    NSLog(@"Received data");
    [_receivedData appendData:data];
}

- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error
{
    NSLog(@"Connection failed! Error - %@ %@",
        [error localizedDescription],
        [[error userInfo] objectForKey:NSURLErrorFailingURLStringErrorKey]);
    [_receivedData setLength:0];
}

- (void)connectionDidFinishLoading:(NSURLConnection *)connection
{
    NSLog(@"Succeeded! Received %d bytes of data",[_receivedData length]);
}


@end
