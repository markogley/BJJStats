//
//  MODateAddedViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-30.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol MODateAddedViewControllerDelegate <NSObject>

-(void)setDate:(NSDate *)datePicked;

@end

@interface MODateAddedViewController : UIViewController

@property (strong, nonatomic) NSDate *datePicked;
@property (weak, nonatomic) id <MODateAddedViewControllerDelegate> delegate;

@end
