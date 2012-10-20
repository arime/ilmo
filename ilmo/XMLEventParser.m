//
//  EventReader.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "XMLEventParser.h"

@implementation XMLEventParser

@synthesize events = _events;

NSXMLParser *parser;
NSMutableString	*currentNodeContent;
Event *currentEvent;

-(NSMutableArray*) loadFromURL:(NSString *)urlString
{
    _events = [[NSMutableArray alloc] init];
    NSURL *url = [NSURL URLWithString:urlString];
    NSData *data = [[NSData alloc] initWithContentsOfURL:url];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return _events;
}

-(NSMutableArray*) loadFromFile:(NSString *)fileString
{
    _events = [[NSMutableArray alloc] init];
    NSData *data = [[NSData alloc] initWithContentsOfFile:fileString];
    parser = [[NSXMLParser alloc] initWithData:data];
    parser.delegate = self;
    [parser parse];
    return _events;
}

- (void) parser:(NSXMLParser *)parser didStartElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName attributes:(NSDictionary *)attributeDict
{
    if ([elementname isEqualToString:@"event"])
    {
        currentEvent = [Event alloc];
        NSLog(@"<event>");
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementname isEqualToString:@"id"])
    {
        currentEvent.id = currentNodeContent;
        NSLog(@"id = %@", currentNodeContent);
    }
    if ([elementname isEqualToString:@"title"])
    {
        currentEvent.title = currentNodeContent;
        NSLog(@"title = %@", currentNodeContent);
    }
    if ([elementname isEqualToString:@"team"])
    {
        currentEvent.team = currentNodeContent;
        NSLog(@"team = %@", currentNodeContent);
    }
    if ([elementname isEqualToString:@"date"])
    {
        currentEvent.date = currentNodeContent;
        NSLog(@"date = %@", currentNodeContent);
    }
    if ([elementname isEqualToString:@"time"])
    {
        currentEvent.time = currentNodeContent;
        NSLog(@"time = %@", currentNodeContent);
    }
    if ([elementname isEqualToString:@"location"])
    {
        currentEvent.location = currentNodeContent;
        NSLog(@"location = %@", currentNodeContent);
    }
    if ([elementname isEqualToString:@"additional_info"])
    {
        currentEvent.additional_info = currentNodeContent;
        NSLog(@"additional_info = %@", currentNodeContent);
    }
    if ([elementname isEqualToString:@"status"])
    {
        currentEvent.status = currentNodeContent;
        NSLog(@"status = %@", currentNodeContent);
    }
    if ([elementname isEqualToString:@"mystatus"])
    {
        currentEvent.mystatus = [self convertToStatus: currentNodeContent];
        NSLog(@"mystatus = %@", currentNodeContent);
    }
    if ([elementname isEqualToString:@"mymessage"])
    {
        currentEvent.mymessage = currentNodeContent;
        NSLog(@"mymessage = %@", currentNodeContent);
    }
    if ([elementname isEqualToString:@"event"])
    {
        [_events addObject:currentEvent];
        NSLog(@"</event>");
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (Status) convertToStatus: (NSMutableString*) string
{
    if (string == @"0")
    {
        return ATTENDING_YES;
    }
    else if (string == @"1")
    {
        return ATTENDING_UNDECIDED;
    }
    else
    {
        return ATTENDING_NO;
    }
}

@end
