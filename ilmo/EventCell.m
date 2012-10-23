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

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
    }
    return self;
}

- (void)setEvent:(Event*)event {
    // Set data for event
    [self.title setText:event.title];
    [self.location setText:event.location];
    [self.date setText:[NSString stringWithFormat:@"%@ %@", event.date, event.time]];
    [self.attendees setText:event.status];
    
    if (event.mystatus == ATTENDING_YES) {
        [self.attendingImageView setImage:[UIImage imageNamed:@"positive"]];
    }
    else if (event.mystatus == ATTENDING_NO) {
        [self.attendingImageView setImage:[UIImage imageNamed:@"negative"]];
    }
    else if (event.mystatus == ATTENDING_UNDECIDED) {
        [self.attendingImageView setImage:[UIImage imageNamed:@"question"]];
    }
    else if (event.mystatus == ATTENDING_NO_ANSWER) {
        [self.attendingImageView setImage:[UIImage imageNamed:@"default"]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
