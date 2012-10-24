//
//  JSONServerConnector.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/24/12.
//
//

#import "JSONServerConnector.h"
#import "Utils.h"

@implementation JSONServerConnector

+(id) sharedServerConnector
{
    static JSONServerConnector *connector = nil;
    @synchronized (self)
    {
        if (connector == nil)
        {
            connector = [[self alloc] init];
        }
    }
    return connector;
}

-(id) init
{
    _loginHandler = [[LoginHandler alloc] init];
    [_loginHandler setDelegate:self];
    return self;
}

-(void) loginWithUser:(NSString *)user password:(NSString *)password andCallback:(void(^)(BOOL))handler
{
    NSLog(@"Request login");
    
    _callback = [handler copy];
    
    NSLog(@"Account: %@", user);
    NSString *passwordHash = [Utils sha1:password];
    NSLog(@"Password hash: %@", passwordHash);
    
    NSDictionary *loginData = [[NSDictionary alloc] initWithObjectsAndKeys:
                               user, @"username",
                               passwordHash, @"password",
                               nil];
    NSDictionary *jsonData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              @"symbian", @"agent",
                              loginData, @"loginData",
                              nil];
    
    NSData* postData = [self postDataWithJSONObject:jsonData];

    NSString *jsonString = [[NSString alloc] initWithData:postData
                                             encoding:NSUTF8StringEncoding];
    
    NSLog(@"POST data: %@", jsonString);
    
    NSMutableURLRequest *request =
        [[NSMutableURLRequest alloc] initWithURL:
         [NSURL URLWithString:@"http://www.osallistujat.com/api-1.0/getUser.php"]];
    
    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];
    
    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:_loginHandler];
    
    if (connection)
    {
        NSLog(@"Connection succeeded");
    }
    else
    {
        NSLog(@"Connection failed");
    }
}

- (void)didCompleteLogin:(LoginHandler*)handler withUser:(User*)user
{
    BOOL success = user != nil;
    
    NSLog(@"Login completed with result: %d", success);
    
    if (user != nil)
    {
        NSLog(@"Session id: %@", user.sessionId);
        _user = user;
    }
    
    _callback(success);
}

-(void) loadEventsWithCallback: (void(^)(NSMutableArray*)) handler;
{
    NSLog(@"Request load events");
}

-(void) setStatusForEvent: (NSString*) eventId to: (Status) status withCallback: (void(^)(BOOL)) handler;
{
    NSLog(@"Request set %@ to %d", eventId, (int)status);
}

- (NSData*)postDataWithJSONObject:(NSDictionary*)jsonData
{
    /*
    NSError *error;
    return [NSJSONSerialization
        dataWithJSONObject:jsonData
        options:NSJSONWritingPrettyPrinted
        error:&error];
    */

    // example post data:
    // agent=ios&loginData[username]=test&loginData[password]=hash
    NSMutableString* outputString = [[NSMutableString alloc] init];
    [self parse:jsonData into:outputString withPrefix:nil];
    [outputString deleteCharactersInRange:NSMakeRange([outputString length] - 1, 1)];
    return [outputString dataUsingEncoding:NSUTF8StringEncoding];
}

- (void)parse: (NSDictionary*) jsonData into: (NSMutableString*) output withPrefix: (NSString*) prefix
{
    NSEnumerator *enumerator = [jsonData keyEnumerator];
    id key;
    while ((key = [enumerator nextObject])) {
        id value = [jsonData valueForKey:key];
        if ([value isKindOfClass:[NSDictionary class]]) {
            [self parse:value into:output withPrefix:key];
        }
        else
        {
            if (prefix != nil)
            {
                [output appendFormat:@"%@[%@]", prefix, key];
            }
            else
            {
                [output appendFormat:@"%@", key];
            }
            [output appendFormat:@"=%@&", value];
        }
    }
}

@end
