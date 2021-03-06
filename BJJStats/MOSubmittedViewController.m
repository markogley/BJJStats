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
@property (strong, nonatomic) IBOutlet UINavigationItem *navigationTitle;


@property (strong, nonatomic) NSArray *submittedArray;
@property (strong, nonatomic) NSArray *submittedPositionArray;
@property (strong, nonatomic) IBOutlet UILabel *dateForObjectLabel;


@property (strong, nonatomic) NSString *dateAsStringFull;
@property (strong, nonatomic) NSString *dateAsStringStats;


@property (strong, nonatomic) IBOutlet UIView *buttonView;
@property (strong, nonatomic) IBOutlet UIView *pickerContainerView;


@end

@implementation MOSubmittedViewController


-(NSNumber *)viewIdentifierSubmission{
    
    if (!_viewIdentifierSubmission) {
        _viewIdentifierSubmission = [[NSNumber alloc] init];
    }
    
    return _viewIdentifierSubmission;
}

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
    
    NSDate *date = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"MMMM dd, yyyy"];
    self.dateAsStringFull = [dateFormatter stringFromDate:date];
    
    self.dateForObjectLabel.text = self.dateAsStringFull;
    
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    [self setupView];
    
    NSLog(@"SubmissionView: viewIdentifier is %@", self.viewIdentifierSubmission);
    
    if ([self.viewIdentifierSubmission isEqual:@0]) {
        self.navigationTitle.title = @"Submission";
    }else if ([self.viewIdentifierSubmission isEqual:@1]){
        self.navigationTitle.title = @"Submitted";
    }
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView{
    //self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [self addShadowForView:self.pickerContainerView];
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


#pragma mark UIPickerViewDataSourceAndDelegateMethods


//Tells the app to display the number of rows per picker depending on the component it is evaluating
-(NSInteger)pickerView:(UIPickerView *)pickerView numberOfRowsInComponent:(NSInteger)component{
    
    NSInteger result = 0;
    
    if (component == 0) {
        
        result = [self.submittedArray count];
        
    }else if(component == 1){
        
        result = [self.submittedPositionArray count];
        
    }
    
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


- (IBAction)addedButtonPressed:(UIButton *)sender {
    
    MOSubmissionObject *newSubmissionObject = [self returnNewSubmissionObject];
    
    if ([self.viewIdentifierSubmission isEqual:@0]) {
        [self.delegate addSubmission:newSubmissionObject];
    }else if ([self.viewIdentifierSubmission isEqual:@1]){
        [self.delegate addSubmitted:newSubmissionObject];
    }

    
    
    
    [self.navigationController popToRootViewControllerAnimated:YES];
    
    
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

    
    
    //sets properties for new submissionObject
    addedSubmissionObject.submissionType = [self.submittedArray objectAtIndex:indexSubmissions];
    addedSubmissionObject.submissionPosition = [self.submittedPositionArray objectAtIndex:indexPositions];
    addedSubmissionObject.topOrBottom = topOrBottom;
    addedSubmissionObject.counter = 1;
    

    
    return addedSubmissionObject;
    
}

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
