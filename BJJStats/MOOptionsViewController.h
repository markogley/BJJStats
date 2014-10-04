//
//  MOOptionsViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-10-03.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MOOptionsViewControllerSegueDelegate <NSObject>

-(void)updateOptions:(int)segmentViewSelected :(int)showPercentage;

@end

@interface MOOptionsViewController : UIViewController

@property (weak, nonatomic) id<MOOptionsViewControllerSegueDelegate> deleagate;
@property (strong, nonatomic) IBOutlet UISwitch *percentageSwitch;
@property (strong, nonatomic) IBOutlet UISegmentedControl *selectedViewSegmentController;

@end
