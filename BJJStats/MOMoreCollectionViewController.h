//
//  MOMoreCollectionViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-09-23.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>


@interface MOMoreCollectionViewController : UICollectionViewController <UIWebViewDelegate>



@property (strong, nonatomic) NSString *labelFromCell;
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationTitle;
@property int segmentIndexCollectionView;
//@property  (strong, nonatomic) UIPopoverController *cellSelectedPopover;
@property (strong, nonatomic) NSDictionary *itemToTransfer;

@end
