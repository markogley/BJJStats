//
//  MODateAddedViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-30.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MODateAddedViewController.h"

@interface MODateAddedViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *datePicker;
@property (strong, nonatomic) IBOutlet UILabel *objectDate;

@end

@implementation MODateAddedViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)setCurrentDateButtonPressed:(UIButton *)sender {
}


- (IBAction)doneButtonPressed:(UIButton *)sender {
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
