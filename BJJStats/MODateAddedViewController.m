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
    self.datePicker.datePickerMode = UIDatePickerModeDate;
    NSDate *todaysDate = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    NSString *dateAsString = [dateFormatter stringFromDate:todaysDate];
    
    self.objectDate.text = dateAsString;
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

- (IBAction)doneButtonPressed:(UIButton *)sender {
    
    
    [self.delegate setDate:(self.datePicker.date)];
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}



@end
