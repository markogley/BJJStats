//
//  MOSubmissionsViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-19.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOSubmissionObject.h"

@protocol MOSubmissionsViewControllerDelegate <NSObject>

@required
-(void)addSubmission:(MOSubmissionObject *)newSubmissionObject;
-(void)didCancelSubmission;

@end

@interface MOSubmissionsViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate>

@property(weak, nonatomic) id <MOSubmissionsViewControllerDelegate> delegate;

@end
