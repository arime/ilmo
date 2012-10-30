//
//  JSONServerConnector.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/24/12.
//
//

#import "JSONServerConnector.h"
#import "LoginHandler.h"
#import "EventsHandler.h"
#import "SignUpHandler.h"
#import "Utils.h"

@interface JSONServerConnector () {
    LoginHandler* _loginHandler;
    EventsHandler* _eventsHandler;
    SignUpHandler* _signupHandler;
    User* _user;
    void (^_loginCallback)(BOOL success);
    void (^_loadEventsCallback)(NSMutableArray* events);
    void (^_setStatusCallback)(BOOL success);
}
@end

@implementation JSONServerConnector

NSString* LOGIN_URL = @"http://www.osallistujat.com/api-1.0/getUser.php";
NSString* EVENTS_URL = @"http://www.osallistujat.com/api-1.0/getEvents.php";
NSString* SIGNUP_URL = @"http://www.osallistujat.com/api-1.0/setSignUp.php";
NSString* AGENT_ID=@"ilmo-iOS";

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
    _eventsHandler = [[EventsHandler alloc] init];
    [_eventsHandler setDelegate:self];
    _signupHandler = [[SignUpHandler alloc] init];
    [_signupHandler setDelegate:self];
    return self;
}

-(void) loginWithUser:(NSString *)user password:(NSString *)password andCallback:(void(^)(BOOL))handler
{
    NSLog(@"Request login");

    _loginCallback = [handler copy];

    NSLog(@"Account: %@", user);
    NSString *passwordHash = [Utils sha1:password];
    NSLog(@"Password hash: %@", passwordHash);

    NSDictionary *loginData = [[NSDictionary alloc] initWithObjectsAndKeys:
                               user, @"username",
                               passwordHash, @"password",
                               nil];
    NSDictionary *jsonData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              AGENT_ID, @"agent",
                              loginData, @"loginData",
                              nil];

    if (![self sendPost:jsonData to:LOGIN_URL usingDelegate:_loginHandler])
    {
        _loginCallback(NO);
    }
}

- (void)login:(LoginHandler*)handler didCompleteWithUser:(User*)user
{
    BOOL success = user != nil;

    NSLog(@"Login completed with result: %d", success);

    if (user != nil)
    {
        NSLog(@"Session id: %@", user.sessionId);
        _user = user;
    }

    _loginCallback(success);
}

-(void) loadEventsWithCallback: (void(^)(NSMutableArray*)) handler;
{
    NSLog(@"Request load events");

    _loadEventsCallback = [handler copy];

    NSDictionary *loginData = [[NSDictionary alloc] initWithObjectsAndKeys:
                               _user.sessionId, @"sessionId",
                               nil];
    NSDictionary *jsonData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              AGENT_ID, @"agent",
                              loginData, @"loginData",
                              nil];

    if (![self sendPost: jsonData to:EVENTS_URL usingDelegate:_eventsHandler])
    {
        _loadEventsCallback(nil);
    }
}

- (void)loadEvents:(EventsHandler*)handler didCompleteWithEvents:(NSMutableArray*) events
{
    NSLog(@"Load events completed with events: %d", [events count]);
    _loadEventsCallback(events);
}

-(void) setStatusForEvent: (NSString*) eventId to: (Status) status withCallback: (void(^)(BOOL)) handler;
{
    NSLog(@"Request set %@ to %d", eventId, (int)status);
    _setStatusCallback = [handler copy];
    
    NSDictionary *loginData = [[NSDictionary alloc] initWithObjectsAndKeys:
                               _user.sessionId, @"sessionId",
                               nil];
    NSDictionary *data = [[NSDictionary alloc] initWithObjectsAndKeys:
                          eventId, @"eventId",
                          [self statusAsString:status], @"statusInt",
                          nil];
    NSDictionary *jsonData = [[NSDictionary alloc] initWithObjectsAndKeys:
                              AGENT_ID, @"agent",
                              loginData, @"loginData",
                              data, @"data",
                              nil];
    
    if (![self sendPost: jsonData to:SIGNUP_URL usingDelegate:_signupHandler])
    {
        _setStatusCallback(NO);
    }
}

- (void)signUp:(SignUpHandler*)handler didCompleteWithResult:(BOOL)success
{
    NSLog(@"Sign up completed with result %d", success);
    _setStatusCallback(success);
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
    NSLog(@"%@", jsonData);
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

- (BOOL) sendPost: (NSDictionary*) jsonData to: (NSString*) url usingDelegate: (id) delegate
{
    NSData* postData = [self postDataWithJSONObject:jsonData];

    NSString *jsonString =
        [[NSString alloc] initWithData:postData
        encoding:NSUTF8StringEncoding];

    NSLog(@"URL: %@", url);
    NSLog(@"POST: %@", jsonString);

    NSMutableURLRequest *request =
    [[NSMutableURLRequest alloc] initWithURL:
     [NSURL URLWithString:url]];

    [request setHTTPMethod:@"POST"];
    [request addValue:@"application/x-www-form-urlencoded" forHTTPHeaderField:@"Content-Type"];
    [request setHTTPBody:postData];

    NSURLConnection *connection = [[NSURLConnection alloc] initWithRequest:request delegate:delegate];

    if (connection)
    {
        NSLog(@"Connection succeeded");
        return YES;
    }
    else
    {
        NSLog(@"Connection failed");
        return NO;
    }

}

-(NSString*) statusAsString:(Status) status
{
    switch (status) {
        case ATTENDING_YES:
            return @"0";
        case ATTENDING_UNDECIDED:
            return @"1";
        case ATTENDING_NO:
        default:
            return @"2";
    }
}

@end
