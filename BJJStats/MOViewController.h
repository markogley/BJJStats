//
//  MOViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-19.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOSubmissionsViewController.h"
#import "MOSubmittedViewController.h"
#import "MOMatchesViewController.h"
#import "MOObjectConverter.h"
#import "MOSubmissionsPersistenceManager.h"

@interface MOViewController : UIViewController <MOSubmissionsViewControllerDelegate, MOSubmittedViewControllerDelegate, MOMatchesViewControllerDelegate>


@end
