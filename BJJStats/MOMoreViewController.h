//
//  MOMoreViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-24.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MOUICollectionResuableViewHeader.h"



@interface MOMoreViewController : UIViewController <UICollectionViewDataSource, UICollectionViewDelegate>
@property (strong, nonatomic) IBOutlet UILabel *strongestSubmissionLabel;
@property (strong, nonatomic) IBOutlet UILabel *mostSubmittedByLabel;
@property (strong, nonatomic) IBOutlet UICollectionView *collectionView;
@property (strong, nonatomic) NSString *labelFromCell;


@end
