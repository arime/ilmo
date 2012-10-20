//
//  Event.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/17/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Event : NSObject

typedef enum Status : NSInteger Status;
enum Status : NSInteger {
    ATTENDING_YES,
    ATTENDING_UNDECIDED,
    ATTENDING_NO,
    ATTENDING_NO_ANSWER
};

@property (nonatomic, retain) NSString *id;
@property (nonatomic, retain) NSString *title;
@property (nonatomic, retain) NSString *team;
@property (nonatomic, retain) NSString *date;
@property (nonatomic, retain) NSString *time;
@property (nonatomic, retain) NSString *location;
@property (nonatomic, retain) NSString *additional_info;
@property (nonatomic, retain) NSString *status;
@property (nonatomic) Status mystatus;
@property (nonatomic, retain) NSString *mymessage;

@end
