//
//  MOSubmissionsViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-19.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOSubmissionsViewController.h"

@interface MOSubmissionsViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *submissionPickerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *topOrBottomSegmentedControl;

@property (strong, nonatomic) NSArray *submissionsArray;
@property (strong, nonatomic) NSArray *submissionPositionsArray;
@property (strong, nonatomic) IBOutlet UILabel *dateForObjectLabel;

@property (strong, nonatomic) NSString *dateAsStringFull;
@property (strong, nonatomic) NSString *dateAsStringStats;


@end

@implementation MOSubmissionsViewController

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
    self.submissionPickerView.delegate = self;
    self.submissionPickerView.dataSource = self;
    
    // Do any additional setup after loading the view.
    NSURL *submissions = [[NSBundle mainBundle] URLForResource:@"Submissions" withExtension:@"plist"];
    self.submissionsArray = [NSArray arrayWithContentsOfURL:submissions];
    //NSLog(@"The submissions are %@", self.submissionsArray);
    NSURL *positions = [[NSBundle mainBundle] URLForResource:@"Positions" withExtension:@"plist"];
    self.submissionPositionsArray = [NSArray arrayWithContentsOfURL:positions];
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    self.dateAsStringFull = [dateFormatter stringFromDate:date];
    
    self.dateForObjectLabel.text = self.dateAsStringFull;
    
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark UIPickerViewDataSourceAndDelegateMethods


//Tells the app to display the number of rows per picker depending on the component it is evaluating
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger result = 0;
    
    if (component == 0) {
        
        result = [self.submissionsArray count];
        
    }else if(component == 1){
        
        result = [self.submissionPositionsArray count];
        
    }
    
    return result;
}


//returns the number of components in the UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 3;
}


//Sets the title for each row of the picker from the arrays created from the plist files.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *result = nil;
    
    if (component == 0) {
        
        result = self.submissionsArray[row];
    
    }else if(component == 1){
        
        result =  self.submissionPositionsArray[row];
    
    }
    
    return result;
}


//sets width of row to display text in each component of the UIPickerView
-(CGFloat)pickerView:(UIPickerView *)pickerView widthForComponent:(NSInteger)component{
    
        return 160;
    
    
}

//sets font size and style for each row in the UIPickerView
-(UIView *)pickerView:(UIPickerView *)pickerView viewForRow:(NSInteger)row forComponent:(NSInteger)component reusingView:(UIView *)view{
    //creates a new UILabel from the view of the row being passed in
    UILabel *tView = (UILabel*)view;
   //if the view does not exist it creates the label
    if (!tView){
        tView = [[UILabel alloc] init];
        //sets font size to 14pt
        tView.font = [UIFont systemFontOfSize:16];
    }
    
    //depending on the component the text is aligned differently and the text for that row is set from its array.
    if (component == 0) {
        tView.textAlignment = NSTextAlignmentCenter;
        tView.text = self.submissionsArray[row];
        
    }else if(component == 1){
        tView.textAlignment = NSTextAlignmentCenter;
        tView.text =  self.submissionPositionsArray[row];
        
    }//else if (component == 2){
        //tView.textAlignment = NSTextAlignmentCenter;
        //tView.text = self.topOrBottomArray[row];
    //}
    
    return tView;
}

//
-(void)pickerView:(UIPickerView *)pickerView didSelectRow:(NSInteger)row inComponent:(NSInteger)component{
    
    //NSLog(@"Select row %ld from submissions, %ld from positions, %ld from top/Bottom", (long)[self.informationPickerView selectedRowInComponent:0], (long)[self.informationPickerView selectedRowInComponent:1], (long)[self.informationPickerView selectedRowInComponent:2]);
}


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    if ([segue.destinationViewController isKindOfClass:[MODateAddedViewController class]]) {
        MODateAddedViewController *dateAddedVC = segue.destinationViewController;
        dateAddedVC.delegate = self;
    }
}



- (IBAction)addSubmissionButtonPressed:(UIButton *)sender {
    /*NSInteger indexSubmissions = [self.informationPickerView selectedRowInComponent:0];
    NSInteger indexPositions = [self.informationPickerView selectedRowInComponent:1];
    NSInteger indexTopBottom = [self.informationPickerView selectedRowInComponent:2];
    
    NSString *message = [NSString stringWithFormat:@"Your picked %@ from submission, %@ from positions and your were on the %@", [self.submissionsArray objectAtIndex:indexSubmissions], [self.positionsArray objectAtIndex:indexPositions], [self.topBottomArray objectAtIndex:indexTopBottom]];
    
    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Confirm" message:message delegate:nil cancelButtonTitle:@"Confirm" otherButtonTitles: nil];
    
    [alert show];
    */
    MOSubmissionObject *newSubmissionObject = [self returnNewSubmissionObject];
    
    [self.delegate addSubmission:newSubmissionObject];
    
}

//dismisses back to the main screen on pushing the cancel button.
- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self.delegate didCancelSubmission];
    
}

-(MOSubmissionObject *)returnNewSubmissionObject{
    
    MOSubmissionObject *addedSubmissionObject = [[MOSubmissionObject alloc] init];
    
    NSInteger indexSubmissions = [self.submissionPickerView selectedRowInComponent:0];
    NSInteger indexPositions = [self.submissionPickerView selectedRowInComponent:1];
    
    NSString *topOrBottom;
    
    if (self.topOrBottomSegmentedControl.selectedSegmentIndex == 0) {
        topOrBottom = @"Top";
        
    }else if(self.topOrBottomSegmentedControl.selectedSegmentIndex == 1){
        topOrBottom = @"Bottom";
    }
    
    //adds the correct date to the new object depending on whether the user used the change date option or not.
    if (self.dateAsStringStats == nil) {
        NSDate *today = [NSDate date];
        NSDateFormatter *shortFormat = [[NSDateFormatter alloc] init];
        [shortFormat setDateFormat:@"yyyy-MM-dd"];
        NSString *todayAsString =[shortFormat stringFromDate:today];
        NSLog(@"the addedSubmissionObject.datesArray is %@", addedSubmissionObject.datesArray);
        [addedSubmissionObject.datesArray addObject:todayAsString];
    }else{
        NSLog(@"self.dateAsStringStats is %@", self.dateAsStringStats);
        [addedSubmissionObject.datesArray addObject:self.dateAsStringStats];
        NSLog(@"the addedSubmissionObject.datesArray is %@", addedSubmissionObject.datesArray);
        
    }
    
    addedSubmissionObject.submissionType = [self.submissionsArray objectAtIndex:indexSubmissions];
    addedSubmissionObject.submissionPosition = [self.submissionPositionsArray objectAtIndex:indexPositions];
    addedSubmissionObject.topOrBottom = topOrBottom;
    addedSubmissionObject.counter = 1;
    
    
    
    return addedSubmissionObject;
    
}

#pragma mark MODateAddedViewControllerDelegate Methods

//creates strings of dates to be set in the viewController and the submission object when the change date button option is used.
-(void)setDate:(NSDate *)datePicked{
    
    //testing date object for future statistics
    NSDateFormatter *dateFormatterFull = [[NSDateFormatter alloc] init];
    [dateFormatterFull setDateFormat:@"MMMM dd, yyyy"];
    self.dateAsStringFull = [dateFormatterFull stringFromDate:datePicked];
    
    self.dateForObjectLabel.text = self.dateAsStringFull;
    
    NSDateFormatter *dateFormatterStats = [[NSDateFormatter alloc] init];
    [dateFormatterStats setDateFormat:@"yyyy-MM-dd"];
    self.dateAsStringStats = [dateFormatterStats stringFromDate:datePicked];
    
    
}

@end
