//
//  MOMoreViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-24.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOMoreViewController.h"
#import "MOSubmissionsPersistenceManager.h"
#import "MOSubmissionObject.h"

@interface MOMoreViewController ()

@property (strong, nonatomic) NSMutableArray *mySubmissionsAsPropertyList;
@property (strong, nonatomic) NSMutableArray *mySubmittedAsPropertyList;
- (IBAction)backButtonPressed:(UIButton *)sender;

@end

@implementation MOMoreViewController

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
    
    //Gets the data stored in NSUserDefaults for submissions
    self.mySubmissionsAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
    
    //Gets the data stored in NSUserDefaults for submitted
    self.mySubmittedAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
    
    [self strongestSubmission];
    [self submittedTheMostBY];

}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)strongestSubmission{
    int index = 0;
    int indexOfStrongestSubmission = 0;
    int numberOfSubmission = 0;
    NSDictionary *submission;
    for (submission in self.mySubmissionsAsPropertyList) {
        NSLog(@"MoreViewController: submission %@", submission);
        if (numberOfSubmission <= [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] integerValue]) {
            numberOfSubmission = [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] integerValue];
            indexOfStrongestSubmission = index;
            index++;
            NSLog(@"MoreViewController: index = %i and indexOfStrongest = %i", index, indexOfStrongestSubmission);
            
        }else{
            index ++;
        }
    }
    
    self.strongestSubmissionLabel.text = self.mySubmissionsAsPropertyList[indexOfStrongestSubmission][SUBMISSION_TYPE];

}

-(void)submittedTheMostBY{
    
    int index = 0;
    int indexOfStrongestSubmission = 0;
    int numberOfSubmission = 0;
    NSDictionary *submission;
    for (submission in self.mySubmittedAsPropertyList) {
        NSLog(@"MoreViewController: submission %@", submission);
        if (numberOfSubmission <= [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] integerValue]) {
            numberOfSubmission = [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] integerValue];
            indexOfStrongestSubmission = index;
            index++;
            NSLog(@"MoreViewController: index = %i and indexOfStrongest = %i", index, indexOfStrongestSubmission);
            
        }else{
            index ++;
        }
    }
    
    self.mostSubmittedByLabel.text = self.mySubmittedAsPropertyList[indexOfStrongestSubmission][SUBMISSION_TYPE];
    
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

- (IBAction)backButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}
@end
