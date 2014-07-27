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
@property (strong, nonatomic) NSMutableArray *percentageCalaculated;
@property (strong, nonatomic) NSMutableArray *submissionsStatisticsArray;
@property (strong, nonatomic) NSMutableArray *submittedStatisticsArray;

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
    if(!_percentageCalaculated){
        _percentageCalaculated = [[NSMutableArray alloc] init];
    }
    
    return _percentageCalaculated;
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
    
    NSLog(@"%@", self.mySubmissionsAsPropertyList);
//    MOObjectConverter *converter = [[MOObjectConverter alloc] init];
//    
//    //Iterates through all the dictionaries in the mySubmissionsAsPropertyList array and converts them to MOSubmission objects and adds the to the submissionsStatisticsArray
//    for (NSDictionary *dictionary in self.mySubmissionsAsPropertyList) {
//        NSLog(@"The dictionary being processed is %@", dictionary);
//        //using outside class as convert for plist to object and object to plist
//        MOSubmissionObject *submissionObject = [converter submissionObjectForDictionary:dictionary];
//        NSLog(@"Submission object is %@", submissionObject.submissionPosition);
//        [self.submissionsStatisticsArray addObject:submissionObject];
//    }
    
    NSLog(@"segmentIndex %ld", (long)self.pieChartSegmentControl.selectedSegmentIndex);
    
    [self convertMultipleObjectsToDictionary:self.mySubmissionsAsPropertyList storeInStatisticsArray:self.submissionsStatisticsArray];
    [self convertMultipleObjectsToDictionary:self.mySubmittedAsPropertyList storeInStatisticsArray:self.submittedStatisticsArray];
}

-(void)viewDidAppear:(BOOL)animated{
    
    [super viewDidAppear:YES];
    [self.pieChart reloadData];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
- (IBAction)exitButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark XYPieChartDataMethods

//need to persist data and add a count value to submission object as to not create duplicate values

-(CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
    
    int valueOfCounter = 0;
    NSNumber *percentage = 0;
    
    if (self.pieChartSegmentControl.selectedSegmentIndex == 0) {
        
        
        NSDictionary *dictOb = [self.mySubmissionsAsPropertyList objectAtIndex:index];
        valueOfCounter = (int)[[dictOb valueForKey:@"Counter"] integerValue];
        
        percentage = [NSNumber numberWithInt:valueOfCounter];
        [self.percentageCalaculated addObject:percentage];
        
    }else if (self.pieChartSegmentControl.selectedSegmentIndex == 1){
        
        NSDictionary *dictOb = [self.mySubmittedAsPropertyList objectAtIndex:index];
        valueOfCounter = (int)[[dictOb valueForKey:@"Counter"] integerValue];
        percentage = [NSNumber numberWithInt:valueOfCounter];
        [self.percentageCalaculated addObject:percentage];
        
        
    }
    
    return valueOfCounter;
    
}

-(NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart{
    
    if (self.pieChartSegmentControl.selectedSegmentIndex == 0) {
        NSLog(@"Count of Submitted statistics Array %ld", [self.submissionsStatisticsArray count]);
        return [self.submissionsStatisticsArray count];
        
    }else if (self.pieChartSegmentControl.selectedSegmentIndex == 1){
        NSLog(@"Count of Submitted statistics Array %ld", [self.submittedStatisticsArray count]);
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
    MOSubmissionObject *objectFromArray = self.submissionsStatisticsArray[index];
    self.submissionSelectedLabel.text = objectFromArray.submissionType;
    self.submissionPositionLabel.text = objectFromArray.submissionPosition;
    self.topOrBottomLabel.text = objectFromArray.topOrBottom;
    
    NSNumber *total = [[NSNumber alloc] init];
    for (NSNumber *i in self.percentageCalaculated) {
        total = [NSNumber numberWithInt:([total intValue] + [i intValue])];
    }
    
    NSDictionary *dictOb = [self.mySubmissionsAsPropertyList objectAtIndex:index];
    int valueOfCounter = (int)[[dictOb valueForKey:@"Counter"] integerValue];
    
    float percentage = (valueOfCounter / [total floatValue]) * 100;
    NSString *percentageAsString = [NSString stringWithFormat:@"%.2f%%", percentage];
    self.percentageLabel.text = percentageAsString;
        
    }else if (self.pieChartSegmentControl.selectedSegmentIndex == 1){
        
        MOSubmissionObject *objectFromArray = self.submittedStatisticsArray[index];
        self.submissionSelectedLabel.text = objectFromArray.submissionType;
        self.submissionPositionLabel.text = objectFromArray.submissionPosition;
        self.topOrBottomLabel.text = objectFromArray.topOrBottom;
        
        NSNumber *total = [[NSNumber alloc] init];
        for (NSNumber *i in self.percentageCalaculated) {
            total = [NSNumber numberWithInt:([total intValue] + [i intValue])];
        }
        
        NSDictionary *dictOb = [self.mySubmittedAsPropertyList objectAtIndex:index];
        int valueOfCounter = (int)[[dictOb valueForKey:@"Counter"] integerValue];
        
        float percentage = (valueOfCounter / [total floatValue]) * 100;
        NSString *percentageAsString = [NSString stringWithFormat:@"%.2f%%", percentage];
        self.percentageLabel.text = percentageAsString;
        
    }
    
}

-(void)pieChart:(XYPieChart *)pieChart didDeselectSliceAtIndex:(NSUInteger)index{

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
        NSLog(@"The dictionary being processed is %@", dictionary);
        //using outside class as convert for plist to object and object to plist
        MOSubmissionObject *submissionObject = [converter submissionObjectForDictionary:dictionary];
        NSLog(@"Submission object is %@", submissionObject.submissionPosition);
        [statisticsArray addObject:submissionObject];
    }
    
}


- (IBAction)segementControllerPressed:(UISegmentedControl *)sender {
    
    [self viewDidAppear:YES];
    NSLog(@"segmentIndex %ld", (long)self.pieChartSegmentControl.selectedSegmentIndex);
}
@end
