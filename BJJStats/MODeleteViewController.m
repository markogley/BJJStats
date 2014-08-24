//
//  MODeleteViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-02.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MODeleteViewController.h"

@interface MODeleteViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MOObjectConverter *converter;
@property (strong, nonatomic) IBOutlet UIView *detailDeleteView;
@property (strong, nonatomic) IBOutlet UITableView *datesTableView;



@end

@implementation MODeleteViewController



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
    self.datesTableView.delegate = self;
    self.datesTableView.dataSource = self;
    
    [self setupSubmissionObjectDetails];
    
    
    self.view.backgroundColor = [UIColor clearColor];
    
    self.datesTableView.layer.borderWidth = 1.0;
    self.datesTableView.layer.borderColor = [UIColor blackColor].CGColor;
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    [self setupView];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


- (IBAction)cancelButtonPressed:(UIButton *)sender {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)setupView{
    //self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [self addShadowForView:self.detailDeleteView];
    //do want to clip any subviews of the imageView
}

-(void)addShadowForView:(UIView *)view{
    
    //any subviews will be clipped
    view.layer.masksToBounds = NO;
    //rounds corners of the view
    view.layer.cornerRadius = 4;
    //size of shadow raidius
    //view.layer.shadowRadius = 1;
    //tweak to allow iPhone 4 to load shadows without hindering performace of XYPieChart animations
    //view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
    //how the shadow is oriented to the view
    //view.layer.shadowOffset = CGSizeMake(0, 1);
    //sets alpha for shadow
    //view.layer.shadowOpacity = 0.25;
}

-(void)setupSubmissionObjectDetails{
    
    self.submissionTypeLabel.text = self.submissionObjectDict[SUBMISSION_TYPE];
    self.submissionPositionLabel.text = self.submissionObjectDict[SUBMISSION_POSITION];
    self.topOrBottomLabel.text = self.submissionObjectDict[SUBMISSION_TOP_OR_BOTTOM];
    self.counterLabel.text = [NSString stringWithFormat:@"%@",self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER]];
    
    
}

-(void)removeDateFromObject:(NSIndexPath *)index{
    
    MOObjectConverter *converter = [[MOObjectConverter alloc] init];
    MOSubmissionObject *deletedObject = [converter submissionObjectForDictionary:self.submissionObjectDict];
    [deletedObject decrementCounter];
    
    //deletedObject.datesArray = [deletedObject.datesArray mutableCopy];
    NSMutableArray *updatedDates = [deletedObject.datesArray mutableCopy];
    [updatedDates removeObjectAtIndex:index.row];
    deletedObject.datesArray = [updatedDates copy];
    
    
    self.counterLabel.text = [NSString stringWithFormat:@"%i", deletedObject.counter];
    
    MOSubmissionsPersistenceManager *saveEditedSubmissionObject = [[MOSubmissionsPersistenceManager alloc]init];
    
    
    if ([self.sectionHeaderRecieved isEqualToString:@"SUBMISSIONS"]) {
        
        //open preveous submissions saved in NSUserDefaults
        NSMutableArray *submissionObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
        
        
        [saveEditedSubmissionObject compareEditedSubmissionObjectToSavedData:submissionObjectsAsPropertyLists newSubmissionObject:deletedObject sectionHeader:self.sectionHeaderRecieved];
        
        
        //[[NSUserDefaults standardUserDefaults] setObject:submissionObjectsAsPropertyLists forKey:ADDED_SUBMISSION_OBJECTS_KEY];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        
    }else if ([self.sectionHeaderRecieved isEqualToString:@"SUBMITTED"]){
        
        //open preveous submitted saved in NSUserDefaults
        NSMutableArray *submittedObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
        
        
        [saveEditedSubmissionObject compareEditedSubmissionObjectToSavedData:submittedObjectsAsPropertyLists newSubmissionObject:deletedObject sectionHeader:self.sectionHeaderRecieved];
        
        //[[NSUserDefaults standardUserDefaults] setObject:submittedObjectsAsPropertyLists forKey:ADDED_SUBMITTED_OBJECTS_KEY];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }
    
    [self reloadTableAfterEditing];
    
}

-(void)reloadTableAfterEditing{
    NSLog(@"DeletionViewController: reloading Data");
    
    if ([self.sectionHeaderRecieved isEqualToString:@"SUBMISSIONS"]) {
        NSLog(@"DeletionViewController: reloading Data for Submission");
        
        NSMutableArray *submissionObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
        
        NSLog(@"DeletionController:IndexPath section %ld  row %ld", (long)self.indexOfSubmissionObject.section, (long)self.indexOfSubmissionObject.row);
        
        NSLog(@"DeletionController: submittedObjects");
        
        self.submissionObjectDict = [submissionObjectsAsPropertyLists  objectAtIndex:self.indexOfSubmissionObject.row];
        
        NSLog(@"DeletionViewController: submissionObject %@", self.submissionObjectDict);
    
    }
    
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.textLabel.text = [self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE] objectAtIndex:indexPath.row];
    NSLog(@"DeleteViewController: Date for table %@", [self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE] objectAtIndex:indexPath.row]);
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed: 0.29 green: 0.47 blue: 0.75 alpha: 1.0];
    cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    
    return cell;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSLog(@"DeleteViewController: The number of rows is %lu", (unsigned long)[self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE] count]);
    
    return [self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE] count];
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

//method crashes application. Need to reload submissionObject Data when method completes.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"DeleteViewController: Editing Deletion Started!!!");
        
        //[tableView beginUpdates];
        [self removeDateFromObject:indexPath];
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //[self reloadTableAfterEditing];
        
        //[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        [tableView endUpdates];
        
        
    }

}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionName;
    
    switch (section) {
        case 0:
            sectionName = @"Dates";
            break;
        default:
            break;
    }
    
    return sectionName;
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
