//
//  EventReader.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@interface XMLEventParser : NSObject <NSXMLParserDelegate>

@property (nonatomic, retain) NSMutableArray *events;

-(NSMutableArray*) loadFromURL:(NSString *)urlString;
-(NSMutableArray*) loadFromFile:(NSString *)fileString;

@end
