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
#import "MOObjectConverter.h"

@interface MOViewController : UIViewController <MOSubmissionsViewControllerDelegate, MOSubmittedViewControllerDelegate>

#define ADDED_SUBMISSION_OBJECTS_KEY @"Added Submission Objects Key"
#define ADDED_SUBMITTED_OBJECT_KEY @"Added Submitted Objects Key"


@end
