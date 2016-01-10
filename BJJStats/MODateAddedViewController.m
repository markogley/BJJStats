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

@property (weak, nonatomic) IBOutlet UIView *buttonView;
@property (weak, nonatomic) IBOutlet UIView *datePickerView;

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
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    [self setupView];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView{
    //self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [self addShadowForView:self.datePickerView];
    [self addShadowForView:self.buttonView];
    //do want to clip any subviews of the imageView
}


-(void)addShadowForView:(UIView *)view{
    
    //any subviews will be clipped
    view.layer.masksToBounds = NO;
    //rounds corners of the view
    view.layer.cornerRadius = 4;
    //size of shadow raidius
    view.layer.shadowRadius = 1;
    //tweak to allow iPhone 4 to load shadows without hindering performace of XYPieChart animations
    //view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
    //how the shadow is oriented to the view
    view.layer.shadowOffset = CGSizeMake(0, 1);
    //sets alpha for shadow
    view.layer.shadowOpacity = 0.25;
    
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
