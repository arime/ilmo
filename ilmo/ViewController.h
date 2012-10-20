//
//  ViewController.h
//  ilmo
//
//  Created by Ari Metsähalme on 10/20/12.
//  Copyright (c) 2012 __MyCompanyName__. All rights reserved.
//

#import "ServerConnector.h"
#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate,
    UIGestureRecognizerDelegate>

@property (strong, nonatomic) IBOutlet UITableView *eventTable;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *rightSwipeRecognizer;
@property (strong, nonatomic) IBOutlet UISwipeGestureRecognizer *leftSwipeRecognizer;

@property (strong, nonatomic) IBOutlet UIActivityIndicatorView *activity;

@end
