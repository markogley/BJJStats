//
//  MOStatisticsViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-20.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOStatisticsViewController.h"
#import "MOViewController.h"

@interface MOStatisticsViewController ()

@property (strong, nonatomic) NSMutableArray *mySubmissionsAsPropertyList;
@property (strong, nonatomic) NSMutableArray *mySubmittedAsPropertyList;
@property (strong, nonatomic) NSArray *sliceColors;
@property (strong, nonatomic) NSMutableArray *percentageCalculated;
//@property (strong, nonatomic) NSMutableArray *percentageCalaculatedSubmissions;
//@property (strong, nonatomic) NSMutableArray *percentageCalculatedSubmitted;
@property (strong, nonatomic) NSMutableArray *submissionsStatisticsArray;
@property (strong, nonatomic) NSMutableArray *submittedStatisticsArray;

//@property (strong, nonatomic) NSNumber *total;

@end

@implementation MOStatisticsViewController

#pragma mark LazyInstantiation

-(NSMutableArray *)submissionsStatisticsArray{
    if(!_submissionsStatisticsArray){
        _submissionsStatisticsArray = [[NSMutableArray alloc] init];
    }
    
    return _submissionsStatisticsArray;
}

-(NSMutableArray *)submittedStatisticsArray{
    
    if (!_submittedStatisticsArray) {
        _submittedStatisticsArray = [[NSMutableArray alloc] init];
    }
    
    return _submittedStatisticsArray;
    
}

-(NSMutableArray *)mySubmissionsAsPropertyList{
    if(!_mySubmissionsAsPropertyList){
        _mySubmissionsAsPropertyList = [[NSMutableArray alloc] init];
    }
    
    return _mySubmissionsAsPropertyList;
}


-(NSMutableArray *)percentageCalaculated{
    if(!_percentageCalculated){
        _percentageCalculated = [[NSMutableArray alloc] init];
    }
    
    return _percentageCalculated;
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
    [_pieChart setDelegate:self];
    [_pieChart setDataSource:self];
    // Do any additional setup after loading the view.
    
    [self.pieChart setStartPieAngle:M_PI_2];	//optional
    [self.pieChart setAnimationSpeed:1.0];	//optional
    [self.pieChart setShowLabel:NO];
    [self.pieChart setLabelFont:[UIFont fontWithName:@"HelveticaNeue" size:10]];	//optional
    [self.pieChart setLabelColor:[UIColor grayColor]];	//optional, defaults to white
    [self.pieChart setLabelShadowColor:[UIColor blackColor]];	//optional, defaults to none (nil)
    [self.pieChart setLabelRadius:125];	//optional
    [self.pieChart setShowPercentage:NO];	//optional
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.95 alpha:1]];	//optional
    //[self.pieChart setPieCenter:CGPointMake(240, 240)];	//optional
    
    
    self.sliceColors = [NSArray arrayWithObjects:[UIColor colorWithRed:85/255.0 green:98/255.0 blue:112/255.0 alpha:1.0],[UIColor colorWithRed:78/255.0 green:205/255.0 blue:196./255.0 alpha:1.0],[UIColor colorWithRed:199/255.0 green:244/255.0 blue:100/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:107/255.0 blue:107/255.0 alpha:1.0], [UIColor colorWithRed:196/255.0 green:77/255.0 blue:88/255.0 alpha:1.0],[UIColor colorWithRed:76/255.0 green:75/255.0 blue:90/255.0 alpha:1.0],[UIColor colorWithRed:244/255.0 green:37/255.0 blue:111/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:113/255.0 blue:81/255.0 alpha:1.0],[UIColor colorWithRed:199/255.0 green:212/255.0 blue:34/255.0 alpha:1.0], [UIColor colorWithRed:142/255.0 green:211/255.0 blue:190/255.0 alpha:1.0], nil];
    
    //Gets the data stored in NSUserDefaults for submissions
   self.mySubmissionsAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
    
    //Gets the data stored in NSUserDefaults for submitted
    self.mySubmittedAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
    
    
    
    [self convertMultipleObjectsToDictionary:self.mySubmissionsAsPropertyList storeInStatisticsArray:self.submissionsStatisticsArray];
    [self convertMultipleObjectsToDictionary:self.mySubmittedAsPropertyList storeInStatisticsArray:self.submittedStatisticsArray];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self setupView];
    [self.pieChart reloadData];
    [super viewDidAppear:YES];
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exitButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)setupView{
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [self addShadowForView:self.pieChart];
    [self addShadowForView:self.statisticsLabelView];
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
    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
    //how the shadow is oriented to the view
    view.layer.shadowOffset = CGSizeMake(0, 1);
    //sets alpha for shadow
    view.layer.shadowOpacity = 0.25;
    
}

#pragma mark XYPieChartDataMethods

-(CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
    
    int valueOfCounter = 0;
    NSNumber *percentage = 0;
    
    if (self.pieChartSegmentControl.selectedSegmentIndex == 0) {
        
        
        NSDictionary *dictOb = [self.mySubmissionsAsPropertyList objectAtIndex:index];
        valueOfCounter = (int)[[[dictOb valueForKey:SUBMISSION_COUNTER_AND_DATE ] valueForKey:@"Counter"] integerValue];
        
        percentage = [NSNumber numberWithInt:valueOfCounter];
        [self.percentageCalaculated addObject:percentage];
        
    }else if (self.pieChartSegmentControl.selectedSegmentIndex == 1){
        
        NSDictionary *dictOb = [self.mySubmittedAsPropertyList objectAtIndex:index];
        valueOfCounter = (int)[[[dictOb valueForKey:SUBMISSION_COUNTER_AND_DATE ] valueForKey:@"Counter"] integerValue];
        percentage = [NSNumber numberWithInt:valueOfCounter];
        [self.percentageCalaculated addObject:percentage];
        
        
    }
    return valueOfCounter;
    
}

-(NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart{
    
    if (self.pieChartSegmentControl.selectedSegmentIndex == 0) {
                return [self.submissionsStatisticsArray count];
        
    }else if (self.pieChartSegmentControl.selectedSegmentIndex == 1){
        return [self.submittedStatisticsArray count];
    }else{
        return 0;
    }
}

-(UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index{
    
    return  [self.sliceColors objectAtIndex:(index % [self.sliceColors count])];
    
}

-(NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index{
    
    if (self.pieChartSegmentControl.selectedSegmentIndex ==  0) {
        
        MOSubmissionObject *objectFromArray = self.submissionsStatisticsArray[index];
        return objectFromArray.submissionType;
        
    }else if(self.pieChartSegmentControl.selectedSegmentIndex ==1){
        
        MOSubmissionObject *objectFromArray = self.submittedStatisticsArray[index];
        return objectFromArray.submissionType;
    }
    
    return @"None";
    
}

#pragma mark XYPieChartDelegateMethods


-(void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index{
    
    
    if (self.pieChartSegmentControl.selectedSegmentIndex == 0) {
        
        //sets up a new submissionObject from an object in the submissionArray
        MOSubmissionObject *objectFromArray = self.submissionsStatisticsArray[index];
        //sets all the labels for the display for all the object properties underneath the pie chart
        self.submissionSelectedLabel.text = objectFromArray.submissionType;
        self.submissionPositionLabel.text = objectFromArray.submissionPosition;
        self.topOrBottomLabel.text = objectFromArray.topOrBottom;
        
        //calculates the total number value of counters for all the objects in the submissionsArray
        NSNumber *total = [[NSNumber alloc] init];
        for (NSNumber *i in self.percentageCalaculated) {
            total = [NSNumber numberWithInt:([total intValue] + [i intValue])];
        }
        NSLog(@"The submissions total is %@", total);
        
        //grabs the string literal from the dictionary version of the submission object
        NSDictionary *dictOb = [self.mySubmissionsAsPropertyList objectAtIndex:index];
        //converts this value to an int
        int valueOfCounter = [[[dictOb valueForKey:SUBMISSION_COUNTER_AND_DATE ] valueForKey:@"Counter"] integerValue];
        
        //calculates the percentage using the valueOfCounter from the object with the total calculated above
        float percentage = (valueOfCounter / [total floatValue]) * 100;
        //rounds off the total to 2 decimals and converts it to a string to put in the percentageLabel
        NSString *percentageAsString = [NSString stringWithFormat:@"%.2f%%", percentage];
        self.percentageLabel.text = percentageAsString;
        
    }else if (self.pieChartSegmentControl.selectedSegmentIndex == 1){
        
        //sets up a new submissionObject from an object in the submissionArray
        MOSubmissionObject *objectFromArray = self.submittedStatisticsArray[index];
        
        //sets all the labels for the display for all the object properties underneath the pie chart
        self.submissionSelectedLabel.text = objectFromArray.submissionType;
        self.submissionPositionLabel.text = objectFromArray.submissionPosition;
        self.topOrBottomLabel.text = objectFromArray.topOrBottom;
        
        //calculates the total number value of counters for all the objects in the submissionsArray
        NSNumber *total = [[NSNumber alloc] init];
        for (NSNumber *i in self.percentageCalaculated) {
            total = [NSNumber numberWithInt:([total intValue] + [i intValue])];
        }
        
        //grabs the string literal from the dictionary version of the submission object
        NSDictionary *dictOb = [self.mySubmittedAsPropertyList objectAtIndex:index];
        //converts this value to an int
        int valueOfCounter = [[[dictOb valueForKey:SUBMISSION_COUNTER_AND_DATE] valueForKey:@"Counter"] integerValue];
        
        //calculates the percentage using the valueOfCounter from the object with the total calculated above
        float percentage = (valueOfCounter / [total floatValue]) * 100;
        NSString *percentageAsString = [NSString stringWithFormat:@"%.2f%%", percentage];
        self.percentageLabel.text = percentageAsString;
    }
}

-(void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index{
    
    //erases all the labels when the user deselects a slice of the pie chart
    self.submissionSelectedLabel.text = nil;
    self.submissionPositionLabel.text = nil;
    self.topOrBottomLabel.text = nil;
    self.percentageLabel.text = nil;
    
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

#pragma mark HelperMethods

-(void)convertMultipleObjectsToDictionary:(NSMutableArray *)objectsAsPlistArray storeInStatisticsArray:(NSMutableArray *)statisticsArray{
    
    MOObjectConverter *converter = [[MOObjectConverter alloc] init];
    
    //Iterates through all the dictionaries in the mySubmissionsAsPropertyList array and converts them to MOSubmission objects and adds the to the submissionsStatisticsArray
    for (NSDictionary *dictionary in objectsAsPlistArray) {
        //using outside class as convert for plist to object and object to plist
        MOSubmissionObject *submissionObject = [converter submissionObjectForDictionary:dictionary];
        [statisticsArray addObject:submissionObject];
    }
    
}


- (IBAction)segementControllerPressed:(UISegmentedControl *)sender {
    
    //erases all the labels when the user deselects a slice of the pie chart
    self.submissionSelectedLabel.text = nil;
    self.submissionPositionLabel.text = nil;
    self.topOrBottomLabel.text = nil;
    self.percentageLabel.text = nil;
    
    //This solved the readding of the percentage totals in the the calculated percentage method of didSelectedSliceAtIndex
    self.percentageCalculated = nil;
    //reloads all the data for the new segment
    [self.pieChart reloadData];
}
@end
