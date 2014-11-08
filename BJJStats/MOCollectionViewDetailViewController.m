//
//  MOCollectionViewDetailViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-11-01.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOCollectionViewDetailViewController.h"
#import "UIViewController+MJPopupViewController.h"


@interface MOCollectionViewDetailViewController ()

@end

@implementation MOCollectionViewDetailViewController


-(NSDictionary *)transferedItem{
    
    if (!_transferedItem) {
        _transferedItem = [[NSDictionary alloc] init];
    }
    
    return _transferedItem;
    
}

- (IBAction)finishedButonPressed:(id)sender {
    
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];

}

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    NSLog(@"UIPopover: transferredItem %@", self.transferedItem);
    
    NSString *youTubeVideoLink = [NSString stringWithFormat:@"<iframe width= %d height= %d src=http://www.youtube.com/embed/%@ frameborder=0 allowfullscreen></iframe>",152, 152, self.transferedItem[@"id"][@"videoId"]];
    
    self.detailLabel.text = self.transferedItem[@"snippet"][@"title"];
    [[self.youtubeVideoWebView scrollView] setScrollEnabled:NO];
    [self.youtubeVideoWebView loadHTMLString:youTubeVideoLink baseURL:nil];

}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/



@end
