//
//  Event.m
//  ilmo
//
//  Created by Ari Metsähalme on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "Event.h"

@interface Event ()
{
    NSDateFormatter* _dateFormatter;
    NSDateFormatter* _timeFormatter;
}
@end

@implementation Event

@synthesize id = _id;
@synthesize title = _title;
@synthesize team = _team;
@synthesize date = _date;
@synthesize time = _time;
@synthesize location = _location;
@synthesize additional_info = _additional_info;
@synthesize status = _status;
@synthesize mystatus = _mystatus;
@synthesize mymessage = _mymessage;

-(id) initWithJSON: (NSDictionary*) data
{
    _dateFormatter = [[NSDateFormatter alloc] init];
    [_dateFormatter setTimeStyle:NSDateFormatterNoStyle];
    [_dateFormatter setDateStyle:NSDateFormatterMediumStyle];
    [_dateFormatter setLocale:[NSLocale currentLocale]];
    _timeFormatter = [[NSDateFormatter alloc] init];
    [_timeFormatter setTimeStyle:NSDateFormatterShortStyle];
    [_timeFormatter setDateStyle:NSDateFormatterNoStyle];
    [_timeFormatter setLocale:[NSLocale currentLocale]];

    _id = [data objectForKey:@"eventId"];
    _title = [data objectForKey:@"title"];
    _location = [data objectForKey:@"location"];
    _status = [data objectForKey:@"signUps"];
    _mystatus = [[data objectForKey:@"myStatusInt"] intValue];
    NSString* startTimeString = [data objectForKey:@"startTs"];
    int startTimeInt = [startTimeString intValue];
    NSDate *date = [NSDate dateWithTimeIntervalSince1970:startTimeInt];
    _date = [_dateFormatter stringFromDate:date];
    _time = [_timeFormatter stringFromDate:date];;
    return self;
}
@end
