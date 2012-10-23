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
    }
}

- (void) parser:(NSXMLParser *)parser didEndElement:(NSString *)elementname namespaceURI:(NSString *)namespaceURI qualifiedName:(NSString *)qName
{
    if ([elementname isEqualToString:@"id"])
    {
        currentEvent.id = currentNodeContent;
    }
    if ([elementname isEqualToString:@"title"])
    {
        currentEvent.title = currentNodeContent;
    }
    if ([elementname isEqualToString:@"team"])
    {
        currentEvent.team = currentNodeContent;
    }
    if ([elementname isEqualToString:@"date"])
    {
        currentEvent.date = currentNodeContent;
    }
    if ([elementname isEqualToString:@"time"])
    {
        currentEvent.time = currentNodeContent;
    }
    if ([elementname isEqualToString:@"location"])
    {
        currentEvent.location = currentNodeContent;
    }
    if ([elementname isEqualToString:@"additional_info"])
    {
        currentEvent.additional_info = currentNodeContent;
    }
    if ([elementname isEqualToString:@"status"])
    {
        currentEvent.status = currentNodeContent;
    }
    if ([elementname isEqualToString:@"mystatus"])
    {
        currentEvent.mystatus = [self convertToStatus: currentNodeContent];
    }
    if ([elementname isEqualToString:@"mymessage"])
    {
        currentEvent.mymessage = currentNodeContent;
    }
    if ([elementname isEqualToString:@"event"])
    {
        [_events addObject:currentEvent];
    }
}

- (void) parser:(NSXMLParser *)parser foundCharacters:(NSString *)string
{
    currentNodeContent = (NSMutableString *) [string stringByTrimmingCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
}

- (Status) convertToStatus: (NSMutableString*) string
{
    Status status = ATTENDING_NO;
    if ([string isEqualToString: @"yes"])
    {
        status = ATTENDING_YES;
    }
    else if ([string isEqualToString:@"maybe"])
    {
        status = ATTENDING_UNDECIDED;
    }
    else if ([string isEqualToString:@"no"])
    {
        status = ATTENDING_NO;
    }
    else
    {
        status = ATTENDING_NO_ANSWER;
    }
    return status;
}

@end
