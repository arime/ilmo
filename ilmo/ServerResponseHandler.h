//
//  ServerResponseHandler.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/28/12.
//
//

#import <Foundation/Foundation.h>

@interface ServerResponseHandler : NSObject

@property (nonatomic, retain) id delegate;
@property (nonatomic, retain) NSMutableData *receivedData;

- (void)connection:(NSURLConnection *)connection didReceiveResponse:(NSURLResponse *)response;
- (void)connection:(NSURLConnection *)connection didReceiveData:(NSData *)data;
- (void)connection:(NSURLConnection *)connection didFailWithError:(NSError *)error;
- (void)connectionDidFinishLoading:(NSURLConnection *)connection;

@end
