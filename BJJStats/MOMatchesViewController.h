//
//  MODrawViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-24.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOMatchObject.h"

@protocol MOMatchesViewControllerDelegate <NSObject>

@required
-(void)addMatch:(MOMatchObject *)newMatchObject;

@end

@interface MOMatchesViewController : UIViewController

@property(weak, nonatomic) id <MOMatchesViewControllerDelegate> delegate;





@end
