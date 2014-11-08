//
//  MOCollectionViewDetailViewController.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-11-01.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOCollectionViewDetailViewController : UIViewController
@property (strong, nonatomic) IBOutlet UIView *detailView;

@property (strong, nonatomic) IBOutlet UILabel *detailLabel;
@property (strong, nonatomic) IBOutlet UIWebView *youtubeVideoWebView;
@property (strong, nonatomic) NSDictionary *transferedItem;

- (IBAction)finishedButonPressed:(id)sender;

@end
