//
//  MOOptionsViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-10-03.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOOptionsViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface MOOptionsViewController ()

@end

@implementation MOOptionsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    self.view.backgroundColor = [UIColor clearColor];
    
    NSLog(@"Options: selectedsegement %ld and percentage %d", (long)self.selectedViewSegmentController.selectedSegmentIndex, self.percentageSwitch.isOn);
    [self prepViewForShow:self.optionsView];
    
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)prepViewForShow:(UIView *)view{
    
    //any subviews will be clipped
    view.layer.masksToBounds = NO;
    //rounds corners of the view
    view.layer.cornerRadius = 8;
    
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)finishedButtonPressed:(UIButton *)sender {
    
    NSLog(@"Options: showPercentageStat %d", self.percentageSwitch.isOn);
    [self hollerBack];
    //self.mj_popupBackgroundView.removeFromSuperview;
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];
}

-(void)hollerBack{
    
    [self.deleagate updateOptions:(int)self.selectedViewSegmentController.selectedSegmentIndex :(int)self.percentageSwitch.isOn];
    
}


@end
