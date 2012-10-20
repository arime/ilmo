//
//  EventCell.h
//  ilmo
//
//  Created by Antti Palola on 10/20/12.
//
//

#import <UIKit/UIKit.h>
#import "Event.h"

@interface EventCell : UITableViewCell

@property (strong, nonatomic) IBOutlet UILabel *title;
@property (nonatomic, strong) IBOutlet UILabel *location;
@property (nonatomic, strong) IBOutlet UILabel *date;
@property (nonatomic, strong) IBOutlet UILabel *time;
@property (nonatomic, strong) IBOutlet UILabel *attendees;
@property (nonatomic, strong) IBOutlet UILabel *mystatus;
@property (nonatomic, strong) IBOutlet UIImageView *attendingImageView;


- (void)setEvent:(Event*)event;

@end
