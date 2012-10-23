//
//  EventCell.m
//  ilmo
//
//  Created by Antti Palola on 10/20/12.
//
//

#import "EventCell.h"

@interface UIColor (HexColor)
+ (UIColor *)colorWithHex:(unsigned int)hex;
@end

@implementation UIColor (HexColor)
+ (UIColor *)colorWithHex:(unsigned int)hex
{
    unsigned int redHex = (hex >> 16) & 0xFF;
    unsigned int greenHex = (hex >> 8) & 0xFF;
    unsigned int blueHex = hex & 0xFF;
    
    CGFloat redValue = (CGFloat)redHex / (CGFloat)0xFF;
    CGFloat greenValue = (CGFloat)greenHex / (CGFloat)0xFF;
    CGFloat blueValue = (CGFloat)blueHex / (CGFloat)0xFF;
    
    return [UIColor colorWithRed:redValue green:greenValue blue:blueValue alpha:1];
}
@end

@implementation EventCell

@synthesize title;
@synthesize location;
@synthesize date;
@synthesize time;
@synthesize attendees;
@synthesize mystatus;
@synthesize attendingImageView;

const unsigned int CELL_COLOR_DEFAULT = 0xFDFDFD;
const unsigned int CELL_COLOR_POSITIVE = 0xFBFFF4;
const unsigned int CELL_COLOR_NEGATIVE = 0xFFFAFB;
const unsigned int CELL_COLOR_QUESTION = 0xF9FEFF;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    return [super initWithStyle:style reuseIdentifier:reuseIdentifier];
}

- (void)setEvent:(Event*)event {
    // Set data for event
    [self.title setText:event.title];
    [self.location setText:event.location];
    [self.date setText:[NSString stringWithFormat:@"%@ %@", event.date, event.time]];
    [self.attendees setText:event.status];
    
    if (event.mystatus == ATTENDING_YES) {
        [self.attendingImageView setImage:[UIImage imageNamed:@"positive"]];
        [self.contentView setBackgroundColor:[UIColor colorWithHex:CELL_COLOR_POSITIVE]];
    }
    else if (event.mystatus == ATTENDING_NO) {
        [self.attendingImageView setImage:[UIImage imageNamed:@"negative"]];
        [self.contentView setBackgroundColor:[UIColor colorWithHex:CELL_COLOR_NEGATIVE]];
    }
    else if (event.mystatus == ATTENDING_UNDECIDED) {
        [self.attendingImageView setImage:[UIImage imageNamed:@"question"]];
        [self.contentView setBackgroundColor:[UIColor colorWithHex:CELL_COLOR_QUESTION]];
    }
    else if (event.mystatus == ATTENDING_NO_ANSWER) {
        [self.attendingImageView setImage:[UIImage imageNamed:@"default"]];
        [self.contentView setBackgroundColor:[UIColor colorWithHex:CELL_COLOR_DEFAULT]];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
