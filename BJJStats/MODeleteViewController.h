//
//  MODeleteViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-02.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOSubmissionObject.h"
#import "MOObjectConverter.h"

@interface MODeleteViewController : UIViewController

@property (strong, nonatomic) NSDictionary *submissionObject;


@property (strong, nonatomic) IBOutlet UILabel *submissionTypeLabel;
@property (strong, nonatomic) IBOutlet UILabel *submissionPositionLabel;
@property (strong, nonatomic) IBOutlet UILabel *topOrBottomLabel;
@property (strong, nonatomic) IBOutlet UILabel *counterLabel;



@end
