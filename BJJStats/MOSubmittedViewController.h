//
//  MOSubmittedViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-19.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOSubmissionObject.h"
#import "MODateAddedViewController.h"

@protocol MOSubmittedViewControllerDelegate <NSObject>

@required
-(void)addSubmitted:(MOSubmissionObject *)newSubmittedObject;
-(void)didCancelSubmitted;

@end

@interface MOSubmittedViewController : UIViewController <UIPickerViewDataSource, UIPickerViewDelegate, MODateAddedViewControllerDelegate>

@property (weak, nonatomic) id <MOSubmittedViewControllerDelegate> delegate;


@end
