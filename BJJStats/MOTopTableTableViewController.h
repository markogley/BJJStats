//
//  MOVTopTableTableViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-09-21.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOMoreViewController.h"

@interface MOTopTableTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *submissions;
@property (strong, nonatomic) NSMutableArray *submitted;
@property int segmentIndex;

@end
