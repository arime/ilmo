//
//  EventCell.m
//  ilmo
//
//  Created by Antti Palola on 10/20/12.
//
//

#import "EventCell.h"

@implementation EventCell

@synthesize title;
@synthesize location;
@synthesize date;
@synthesize time;
@synthesize attendees;
@synthesize mystatus;
@synthesize attendingImageView;

static NSString *YES_STRING = @"yes";
static NSString *NO_STRING = @"no";
static NSString *UNCERTAIN_STRING = @"-";


- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setEvent:(Event*)event {
    // Set data for event
    [self.title setText:[NSString stringWithFormat:@"%@ - %@", event.title, event.location]];
    [self.location setText:event.location];
    [self.date setText:[NSString stringWithFormat:@"%@ @ %@", event.date, event.time]];
    [self.attendees setText:[NSString stringWithFormat:@"%@: %@", NSLocalizedString(@"Tulossa", nil), event.status]];
    
    if ([event.mystatus isEqualToString:YES_STRING]) {
        [self.attendingImageView setImage:[UIImage imageNamed:@"ball_green"]];
    }
    else if ([event.mystatus isEqualToString:NO_STRING]) {
        [self.attendingImageView setImage:[UIImage imageNamed:@"ball_red"]];
    }
    else if ([event.mystatus isEqualToString:UNCERTAIN_STRING]) {
        [self.attendingImageView setImage:[UIImage imageNamed:@"ball_grey"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
