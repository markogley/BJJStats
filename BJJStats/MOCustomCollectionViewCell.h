//
//  MOCustomCollectionViewCell.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-09-07.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface MOCustomCollectionViewCell : UICollectionViewCell

@property (strong, nonatomic) IBOutlet UILabel *videoTitleLabel;

@property (strong, nonatomic) IBOutlet UIWebView *youtubeVideoWebView;

@property (weak, nonatomic) IBOutlet UIImageView *youtubeImageView;



@end
