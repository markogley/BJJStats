//
//  MOStatisticsViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-20.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOStatisticsViewController.h"



@interface MOStatisticsViewController ()

@property (strong, nonatomic) IBOutlet UIBarButtonItem *navButton;



@property (strong, nonatomic) NSMutableArray *mySubmissionsAsPropertyList;
@property (strong, nonatomic) NSMutableArray *mySubmittedAsPropertyList;
@property (strong, nonatomic) NSArray *sliceColors;
@property (strong, nonatomic) NSMutableArray *percentageCalculatedSubmission;
@property (strong, nonatomic) NSMutableArray *percentageCalculatedSubmitted;
@property (strong, nonatomic) NSMutableArray *objectsForPosition;
@property (strong, nonatomic) NSString *positionSelected;
@property (strong, nonatomic) NSArray *submissionsFromPlistArray;
@property (strong, nonatomic) IBOutlet UIView *collectionHolder;

@property int totalSubmissions;
@property int totalSubmitted;


@end

@implementation MOStatisticsViewController

#pragma mark LazyInstantiation



-(NSMutableArray *)mySubmittedAsPropertyList{
    if(!_mySubmittedAsPropertyList){
        _mySubmittedAsPropertyList = [[NSMutableArray alloc] init];
    }
    
    return _mySubmittedAsPropertyList;
}


-(NSMutableArray *)mySubmissionsAsPropertyList{
    if(!_mySubmissionsAsPropertyList){
        _mySubmissionsAsPropertyList = [[NSMutableArray alloc] init];
    }
    
    return _mySubmissionsAsPropertyList;
}


-(NSMutableArray *)percentageCalaculatedSubmission{
    if(!_percentageCalculatedSubmission){
        _percentageCalculatedSubmission = [[NSMutableArray alloc] init];
    }
    
    return _percentageCalculatedSubmission;
}

-(NSMutableArray *)percentageCalaculatedSubmitted{
    if(!_percentageCalculatedSubmitted){
        _percentageCalculatedSubmitted = [[NSMutableArray alloc] init];
    }
    
    return _percentageCalculatedSubmitted;
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
    [self.pieChart setLabelFont:[UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:12]];	//optional
    [self.pieChart setLabelColor:[UIColor whiteColor]];	//optional, defaults to white
    //[self.pieChart setLabelShadowColor:[UIColor blackColor]];	//optional, defaults to none (nil)
    [self.pieChart setLabelRadius:120];	//optional
    [self.pieChart setShowPercentage:NO];	//optional
    [self.pieChart setPieBackgroundColor:[UIColor colorWithWhite:0.96 alpha:1]];	//optional
    [self.pieChart setPieCenter:CGPointMake(self.pieChart.frame.size.width/2 + 5, self.pieChart.frame.size.height/2 + 15)];
    [self.pieChart setPieRadius:self.pieChart.frame.size.width/2.05]; //optional
    
    self.sliceColors = [NSArray arrayWithObjects:[UIColor colorWithRed:85/255.0 green:98/255.0 blue:112/255.0 alpha:1.0],[UIColor colorWithRed:78/255.0 green:205/255.0 blue:196./255.0 alpha:1.0],[UIColor colorWithRed:199/255.0 green:244/255.0 blue:100/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:107/255.0 blue:107/255.0 alpha:1.0], [UIColor colorWithRed:196/255.0 green:77/255.0 blue:88/255.0 alpha:1.0],[UIColor colorWithRed:76/255.0 green:75/255.0 blue:90/255.0 alpha:1.0],[UIColor colorWithRed:244/255.0 green:37/255.0 blue:111/255.0 alpha:1.0],[UIColor colorWithRed:255/255.0 green:113/255.0 blue:81/255.0 alpha:1.0],[UIColor colorWithRed:199/255.0 green:212/255.0 blue:34/255.0 alpha:1.0], [UIColor colorWithRed:142/255.0 green:211/255.0 blue:190/255.0 alpha:1.0], nil];
    
    //Gets the data stored in NSUserDefaults for submissions
   self.mySubmissionsAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
    
    //Gets the data stored in NSUserDefaults for submitted
    self.mySubmittedAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
    
    
    self.percentageCalculatedSubmission = [self getTotalSubmissionForEachPosition:self.mySubmissionsAsPropertyList];
    self.percentageCalculatedSubmitted = [self getTotalSubmissionForEachPosition:self.mySubmittedAsPropertyList];
    
    [[MZFormSheetBackgroundWindow appearance] setBackgroundBlurEffect:YES];
    [[MZFormSheetBackgroundWindow appearance] setBlurRadius:5.0];
    [[MZFormSheetBackgroundWindow appearance] setBackgroundColor:[UIColor clearColor]];
    
    self.pieChartKey.dataSource = self;
    self.pieChartKey.delegate = self;
    
    self.selectedView = 0;
    self.showPercentageCurrent = 0;
    
    [self setupTitle];
    
    //NSArray *title = [[NSBundle mainBundle] loadNibNamed:@"TitleView" owner:self options:nil];
    
    //self.navigationItem.titleView = [title objectAtIndex:0];
    
    
    
    
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

-(void)setupTitle{
    
    UIView *navBarView = [[UIView alloc] initWithFrame:CGRectMake(96, 6, 128, 36)];
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 128, 21)];
    title.font = [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18];
    title.textAlignment = NSTextAlignmentCenter;
    title.text = @"Statistics";
    title.textColor = [UIColor colorWithRed:0.75 green:0.56 blue:0.83 alpha:1.0];
    [navBarView addSubview:title];
    
    UILabel *subTitle = [[UILabel alloc] initWithFrame:CGRectMake(0, 18, 128, 15)];
    subTitle.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:12];
    subTitle.textAlignment = NSTextAlignmentCenter;
    subTitle.textColor = [UIColor colorWithRed:0.75 green:0.56 blue:0.83 alpha:1.0];
    if(self.selectedView == 0){
        
        subTitle.text = @"Submissions";
        
        
    }else if (self.selectedView == 1){
        
        subTitle.text = @"Submitted";
        
    }
    [navBarView addSubview:subTitle];
    self.navigationItem.titleView = navBarView;
    
}

-(void)setupView{
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [self addShadowForView:self.pieChart];
    [self addShadowForView:self.collectionHolder];
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

- (NSString *)pieChart:(XYPieChart *)pieChart textForSliceAtIndex:(NSUInteger)index{
    
    //NSString *label;
    
    //if (self.selectedView == 0) {
        //label = self.percentageCalculatedSubmission[index][0];
    //}
    
    //if (self.selectedView == 1) {
        //label = self.percentageCalculatedSubmitted[index][0];
    //}
    
    //return label;
    return nil;
    
}

//need to recalculate percentages based on position not submission
-(CGFloat)pieChart:(XYPieChart *)pieChart valueForSliceAtIndex:(NSUInteger)index{
    
    int valueOfCounter = 0;
    float percentage = 0;
    
    
    valueOfCounter = [self.percentageCalculatedSubmission[index][1] intValue];
    
    
    percentage = (float)valueOfCounter/self.totalSubmissions * 100;
    
    
    return percentage;
    
}

-(NSUInteger)numberOfSlicesInPieChart:(XYPieChart *)pieChart{
    
    //gets unique values from an array and adds them to the new array
//    if (self.mySubmissionsAsPropertyList.count > 0) {
//        self.submissionPositionsLabels = [self.mySubmissionsAsPropertyList valueForKeyPath:[NSString stringWithFormat:@"@distinctUnionOfObjects.%@", @"Submission Position"]];
//    }
    
    if(self.selectedView == 0 && [self.percentageCalculatedSubmission count] > 0){
        
        //return [self.submissionPositionsLabels count];
        return [self.percentageCalculatedSubmission count];
    }
    
    if (self.selectedView == 1 && [self.percentageCalculatedSubmitted count] > 0){
        
        //return [self.submittedPositionsLabels count];
        return [self.percentageCalculatedSubmitted count];

    }

        return 0;
}

-(UIColor *)pieChart:(XYPieChart *)pieChart colorForSliceAtIndex:(NSUInteger)index{
    
    return  [self.sliceColors objectAtIndex:(index % [self.sliceColors count])];
    
}


#pragma mark XYPieChartDelegateMethods


-(void)pieChart:(XYPieChart *)pieChart didSelectSliceAtIndex:(NSUInteger)index{
    
    self.objectsForPosition = NULL;
    //self.positionSelected = [[NSString alloc] init];
    NSMutableArray *tmpArray = [[NSMutableArray alloc] init];
    
    if (self.selectedView == 0) {
        
        for (NSDictionary *items in self.mySubmissionsAsPropertyList){
            if ([items[SUBMISSION_POSITION] isEqualToString:self.percentageCalculatedSubmission[index][0]]) {
            
                [tmpArray addObject:items];
            }
            
    }
        self.positionSelected = self.percentageCalculatedSubmission[index][0];
        
    }else if (self.selectedView == 1){
        
        for(NSDictionary *items in self.mySubmittedAsPropertyList){
            if ([items[SUBMISSION_POSITION] isEqualToString:self.percentageCalculatedSubmitted[index][0]]) {
                
                [tmpArray addObject:items];
            }
            
        }
        self.positionSelected = self.percentageCalculatedSubmitted[index][0];
        
        
       
    }
    
    NSSortDescriptor *sortDescriptor;
    sortDescriptor = [[NSSortDescriptor alloc] initWithKey:@"Submission Counter and Date.Counter" ascending:NO];
    NSArray *sortDescriptors = [NSArray arrayWithObjects:sortDescriptor, nil];
    self.objectsForPosition = [[tmpArray sortedArrayUsingDescriptors:sortDescriptors] mutableCopy];
    
    [self performSegueWithIdentifier:@"pushTopTenTableViewSegue" sender:self];
    
}


#pragma mark - Navigation

-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    
    //if ([sender isKindOfClass:[XYPieChart class]]) {
    if ([segue.destinationViewController isKindOfClass:[MOTopTableTableViewController class]]) {
        MOTopTableTableViewController *destinVC = segue.destinationViewController;
        
        if (self.selectedView == 0) {
            
            
            destinVC.submissions = self.objectsForPosition;
            destinVC.segmentIndex = 0;
            destinVC.position = self.positionSelected;
            
        }
        
        if (self.selectedView == 1) {
            
            destinVC.submitted = self.objectsForPosition;
            destinVC.segmentIndex = 1;
            destinVC.position = self.positionSelected;
        }
        
    }
    
    if([segue.destinationViewController isKindOfClass:[MOOptionsViewController class]]){
        
        MZFormSheetSegue *formSheetSegue = (MZFormSheetSegue *)segue;
        MZFormSheetController *formSheet = formSheetSegue.formSheetController;
        formSheet.transitionStyle = MZFormSheetTransitionStyleBounce;
        formSheet.cornerRadius = 8.0;
        formSheet.didTapOnBackgroundViewCompletionHandler = ^(CGPoint location){
            
        };
        
        formSheet.shouldDismissOnBackgroundViewTap = NO;
        formSheet.didPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        
        };
        
        MOOptionsViewController *destinVC = segue.destinationViewController;
        destinVC.deleagate = self;
        destinVC.selectedViewSegmentController.selectedSegmentIndex = self.selectedView;
        if (self.showPercentageCurrent == 0) {
            [destinVC.percentageSwitch setOn:NO];
        }else{
            [destinVC.percentageSwitch setOn:YES];
        }
        
        
    }
    
}




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
    //self.submissionSelectedLabel.text = nil;
    //self.submissionPositionLabel.text = nil;
    //self.topOrBottomLabel.text = nil;
    //self.percentageLabel.text = nil;
    
    
    //reloads all the data for the new segment
    [self.pieChart reloadData];
    
}



-(NSMutableArray *)getTotalSubmissionForEachPosition:(NSMutableArray *)submissionObjectsAsPlist{
    
    NSURL *positions = [[NSBundle mainBundle] URLForResource:@"Positions" withExtension:@"plist"];
    self.submissionsFromPlistArray = [NSArray arrayWithContentsOfURL:positions];
    
    NSLog(@"StatisticsViewController: submissionFromPlist: %@", self.submissionsFromPlistArray);
    
    int tmpInt = 0;
    NSArray *tmpDic = [[NSArray alloc] init];
    NSMutableArray * testArray = [[NSMutableArray alloc] init];
    
        for (NSString *item in self.submissionsFromPlistArray){
            for (NSDictionary *submission in submissionObjectsAsPlist) {
                if ([item isEqualToString:submission[SUBMISSION_POSITION]]){
                    
                    tmpInt += [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue];
                }
                
                
            }
            if (tmpInt > 0) {
            tmpDic = @[item, [NSNumber numberWithInt:tmpInt]];
            [testArray addObject:tmpDic];
            }
            tmpDic = @[];
            tmpInt = 0;
        }
        
    NSLog(@"StatisticsViewController: testArray: %@", testArray);
    
    
    
    for (NSArray *item in testArray) {
        if ([self.mySubmissionsAsPropertyList isEqualToArray:submissionObjectsAsPlist]) {
        self.totalSubmissions +=  [item[1] intValue];
    }
        else if ([self.mySubmittedAsPropertyList isEqualToArray:submissionObjectsAsPlist]){
            self.totalSubmitted += [item[1] intValue];
        }
            
    }
    
    return testArray;
}

- (IBAction)changePieChartDisplay:(id)sender {
    
//    if ([self.navButton.title isEqualToString:@"Percentage"]) {
//    
//    [self.pieChart setShowPercentage:YES];
//    [self.pieChart setShowLabel:YES];
//    
//    self.navButton.title = @"Position";
//        
//    } else if ([self.navButton.title isEqualToString:@"Position"]){
//        [self.pieChart setShowPercentage:NO];
//        [self.pieChart setShowLabel:YES];
//        
//        self.navButton.title = @"Percentage";
//        
//    }
//    
//    [self.pieChart reloadData];
    UIViewController *optionVC = [self.storyboard instantiateViewControllerWithIdentifier:@"options"];
    
    MZFormSheetController *formSheet = [[MZFormSheetController alloc] initWithViewController:optionVC];
    
    formSheet.presentedFormSheetSize = CGSizeMake(300, 200);
    
    formSheet.shadowRadius = 2.0;
    formSheet.shadowOpacity = 0.3;
    formSheet.shouldDismissOnBackgroundViewTap = YES;
    formSheet.shouldCenterVertically = YES;
    

    
    formSheet.willPresentCompletionHandler = ^(UIViewController *presentedFSViewController){
        presentedFSViewController.view.autoresizingMask = presentedFSViewController.view.autoresizingMask | UIViewAutoresizingFlexibleWidth;
    };
    
    [formSheet presentAnimated:YES completionHandler:^(UIViewController *presentedFSViewController) {
        
    }];
    
    
    //[self performSegueWithIdentifier:@"optionsSegue" sender:nil];
}

#pragma mark UICollectionView DataSource and Delegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (self.selectedView == 0) {
        return [self.percentageCalculatedSubmission count];
    }else if(self.selectedView == 1){
        return [self.percentageCalculatedSubmitted count];
    }else{
        return 0;
    }
    
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
    
}



-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *reuseIdentifier = @"Cell";
    
    MOStatisticsCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    
    
    if (self.selectedView == 0) {
        cell.keyLabel.text = self.percentageCalculatedSubmission[indexPath.row][0];
        cell.colorView.backgroundColor = [self.sliceColors objectAtIndex:(indexPath.row % [self.sliceColors count])];
        //cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
        
        
    }else if (self.selectedView == 1){
        
        cell.keyLabel.text = self.percentageCalculatedSubmitted[indexPath.row][0];
        cell.colorView.backgroundColor = [self.sliceColors objectAtIndex:(indexPath.row % [self.sliceColors count])];
        //cell.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    }
    
    return cell;
    
    
}

#pragma mark MOOptionsViewControllerDelegate

-(void)updateOptions:(int)segmentViewSelected :(int)showPercentage{
    
    NSLog(@"Statistics: segmentViewSelected %d and showPercentageState %d", segmentViewSelected, showPercentage);
    
    self.selectedView = segmentViewSelected;
    self.showPercentageCurrent = showPercentage;
    
    if (showPercentage == 1) {
        [self.pieChart setShowPercentage:YES];
        [self.pieChart setShowLabel:YES];
    }else{
        [self.pieChart setShowLabel:NO];
        [self.pieChart setShowPercentage:NO];
    }
    
    [self setupTitle];
    [self.pieChart reloadData];
    [self.pieChartKey reloadData];
    
    
}


@end
