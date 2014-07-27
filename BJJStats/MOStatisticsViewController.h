//
//  MOStatisticsViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-20.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "XYPieChart.h"
#import "MOSubmissionObject.h"
#import "MOObjectConverter.h"

@interface MOStatisticsViewController : UIViewController<XYPieChartDelegate, XYPieChartDataSource>

@property (strong, nonatomic) IBOutlet XYPieChart *pieChart;
@property (strong, nonatomic) IBOutlet UILabel *submissionSelectedLabel;
@property (strong, nonatomic) IBOutlet UILabel *submissionPositionLabel;
@property (strong, nonatomic) IBOutlet UILabel *topOrBottomLabel;
@property (strong, nonatomic) IBOutlet UILabel *percentageLabel;

@property (strong, nonatomic) IBOutlet UISegmentedControl *pieChartSegmentControl;

- (IBAction)segementControllerPressed:(UISegmentedControl *)sender;



@end
