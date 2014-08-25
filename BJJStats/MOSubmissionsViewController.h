//
//  MOSubmissionsViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-19.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOSubmissionObject.h"
#import "MODateAddedViewController.h"

@protocol MOSubmissionsViewControllerDelegate <NSObject>

@required
-(void)addSubmission:(MOSubmissionObject *)newSubmissionObject;


@end

@interface MOSubmissionsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, MODateAddedViewControllerDelegate>

@property(weak, nonatomic) id <MOSubmissionsViewControllerDelegate> delegate;

@end
