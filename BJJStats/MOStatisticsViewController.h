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
#import "MOViewController.h"
#import "MOTopTableTableViewController.h"
#import "MOAppDelegate.h" 
#import "MOOptionsViewController.h"
#import "MOStatisticsCollectionViewCell.h"
//#import "WYPopoverController.h"
//#import "WYStoryboardPopoverSegue.h"

@interface MOStatisticsViewController : UIViewController <XYPieChartDelegate, XYPieChartDataSource, UICollectionViewDataSource, UICollectionViewDelegate, MOOptionsViewControllerSegueDelegate>


@property (strong, nonatomic) IBOutlet XYPieChart *pieChart;



@property (strong, nonatomic) IBOutlet UICollectionView *pieChartKey;

@property int selectedView;
@property int showPercentageCurrent;




@end
