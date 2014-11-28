//
//  MOVTopTableTableViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-09-21.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>
//#import "MOMoreViewController.h"
#import "MOMoreCollectionViewController.h"

@interface MOTopTableTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) NSMutableArray *submissions;
@property (strong, nonatomic) NSMutableArray *submitted;
@property (strong, nonatomic) NSString *position;
@property int segmentIndex;
@property (strong, nonatomic) IBOutlet UINavigationItem *tableViewTitle;

@property (strong, nonatomic) NSMutableArray *topArray;
@property (strong, nonatomic) NSMutableArray *bottomArray;

@end
