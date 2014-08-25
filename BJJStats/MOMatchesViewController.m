//
//  MODrawViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-24.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOMatchesViewController.h"
#import "MOMatchObject.h"
#import "MOSubmissionsPersistenceManager.h"

@interface MOMatchesViewController ()
@property (strong, nonatomic) IBOutlet UIDatePicker *drawDatePicker;
@property (strong, nonatomic) MOMatchObject *matchObject;
@property (strong, nonatomic) IBOutlet UILabel *numberOfMatches;
@property int counter;


- (IBAction)changeNumberOfMatchesStepper:(UIStepper *)sender;

@end

@implementation MOMatchesViewController

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
    self.drawDatePicker.datePickerMode = UIDatePickerModeDate;
    
    
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
- (IBAction)addMatchesButtonPressed:(UIButton *)sender {
    
    MOMatchObject *newMatchObject = [self returnNewMatchObject];

    [self.delegate  addMatch:newMatchObject];

    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
}


- (IBAction)changeNumberOfMatchesStepper:(UIStepper *)sender {
    
    self.counter = [sender value];
    
    self.numberOfMatches.text = [NSString stringWithFormat:@"%d", self.counter];
    
}


-(MOMatchObject *)returnNewMatchObject{
    
    MOMatchObject *newMatchObject = [[MOMatchObject alloc] init];
    
    NSDate *date = self.drawDatePicker.date;
    NSDateFormatter *shortFormat = [[NSDateFormatter alloc] init];
    [shortFormat setDateFormat:@"yyyy-MM-dd"];
    NSString *todayAsString =[shortFormat stringFromDate:date];
    
    newMatchObject.matchDate = todayAsString;
    newMatchObject.numberOfMatches = self.counter;
    
    
    return newMatchObject;
}

@end
