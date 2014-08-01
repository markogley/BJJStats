//
//  MOSubmittedViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-19.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOSubmittedViewController.h"

@interface MOSubmittedViewController ()
@property (strong, nonatomic) IBOutlet UIPickerView *submittedPickerView;
@property (strong, nonatomic) IBOutlet UISegmentedControl *topOrBottomSegmentedControl;


@property (strong, nonatomic) NSArray *submittedArray;
@property (strong, nonatomic) NSArray *submittedPositionArray;
//@property (strong, nonatomic) NSArray *topOrBottomArray;

@end

@implementation MOSubmittedViewController

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
    
    self.submittedPickerView.delegate = self;
    self.submittedPickerView.dataSource = self;
    
    // Do any additional setup after loading the view.
    NSURL *submissions = [[NSBundle mainBundle] URLForResource:@"Submissions" withExtension:@"plist"];
    self.submittedArray = [NSArray arrayWithContentsOfURL:submissions];
    
    NSURL *positions = [[NSBundle mainBundle] URLForResource:@"Positions" withExtension:@"plist"];
    self.submittedPositionArray = [NSArray arrayWithContentsOfURL:positions];
    
    //NSURL *topBottom = [[NSBundle mainBundle] URLForResource:@"TopBottom" withExtension:@"plist"];
    //self.topOrBottomArray = [NSArray arrayWithContentsOfURL:topBottom];
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
        
        result = [self.submittedArray count];
        
    }else if(component == 1){
        
        result = [self.submittedPositionArray count];
        
    }//else if (component == 2){
        
        //result = [self.topOrBottomArray count];
    //}
    
    return result;
}


//returns the number of components in the UIPickerView
-(NSInteger)numberOfComponentsInPickerView:(UIPickerView *)pickerView{
    
    return 2;
}


//Sets the title for each row of the picker from the arrays created from the plist files.
-(NSString *)pickerView:(UIPickerView *)pickerView titleForRow:(NSInteger)row forComponent:(NSInteger)component{
    
    NSString *result = nil;
    
    if (component == 0) {
        
        result = self.submittedArray[row];
        
    }else if(component == 1){
        
        result =  self.submittedPositionArray[row];
        
    }//else if (component == 2){
        
        //result = self.topOrBottomArray[row];
    //}
    
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
        tView.text = self.submittedArray[row];
        
    }else if(component == 1){
        tView.textAlignment = NSTextAlignmentCenter;
        tView.text =  self.submittedPositionArray[row];
        
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


/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/
- (IBAction)addedButtonPressed:(UIButton *)sender {
    
    NSLog(@"Added new submission button pressed");
    MOSubmissionObject *newSubmissionObject = [self returnNewSubmissionObject];
    
    NSLog(@"finished returning new submission object");
    
    [self.delegate addSubmitted:newSubmissionObject];
    
    
}


- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    NSLog(@"Submitted Cancel Button  Pressed");
    [self.delegate  didCancelSubmitted];
}

-(MOSubmissionObject *)returnNewSubmissionObject{
    
    
    NSLog(@"Started returning new submission object");
    
    MOSubmissionObject *addedSubmissionObject = [[MOSubmissionObject alloc] init];
    
    NSInteger indexSubmissions = [self.submittedPickerView selectedRowInComponent:0];
    NSInteger indexPositions = [self.submittedPickerView selectedRowInComponent:1];
    //NSInteger indexTopBottom = [self.submittedPickerView selectedRowInComponent:2];
    NSString *topOrBottom;
    
    if (self.topOrBottomSegmentedControl.selectedSegmentIndex == 0) {
        topOrBottom = @"Top";
    
    }else if(self.topOrBottomSegmentedControl.selectedSegmentIndex == 1){
        topOrBottom = @"Bottom";
    }
    
    
    //sets properties for new submissionObject
    addedSubmissionObject.submissionType = [self.submittedArray objectAtIndex:indexSubmissions];
    addedSubmissionObject.submissionPosition = [self.submittedPositionArray objectAtIndex:indexPositions];
    addedSubmissionObject.topOrBottom = topOrBottom;
    addedSubmissionObject.counter = 1;
    

    
    return addedSubmissionObject;
    
}




@end
