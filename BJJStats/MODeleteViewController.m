//
//  MODeleteViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-02.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MODeleteViewController.h"

@interface MODeleteViewController ()

@property (strong, nonatomic) MOObjectConverter *converter;
//@property (strong, nonatomic) NSDictionary *submissionObjectAsDict;

@end

@implementation MODeleteViewController

//-(NSDictionary *)submissionObjectAsDict{
    
    //if (!_submissionObjectAsDict) {
        //_submissionObjectAsDict = [[NSDictionary alloc] init];
    //}
    //return _submissionObjectAsDict;
    
//}

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
    NSLog(@"%@", self.submissionObject[SUBMISSION_TYPE]);
    
    NSLog(@"SubmissionObjectAsDict %@", self.submissionObject);
    
    self.submissionTypeLabel.text = self.submissionObject[SUBMISSION_TYPE];
    self.submissionPositionLabel.text = self.submissionObject[SUBMISSION_POSITION];
    self.topOrBottomLabel.text = self.submissionObject[SUBMISSION_TOP_OR_BOTTOM];
    self.counterLabel.text = [NSString stringWithFormat:@"%@",self.submissionObject[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER]];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
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

@end
