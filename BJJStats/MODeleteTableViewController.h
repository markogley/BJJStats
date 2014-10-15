//
//  MODeleteTableViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-02.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOSubmissionsPersistenceManager.h"
#import "MODeleteViewController.h"
#import "MOSubmissionObject.h"
#import "MOObjectConverter.h"
#import "MZFormSheetController.h"
#import "MZFormSheetSegue.h"
#import "MODeleteViewController.h"

@interface MODeleteTableViewController : UITableViewController <UITableViewDataSource, UITableViewDelegate, MODeleteViewControllerDelegate>

@end
