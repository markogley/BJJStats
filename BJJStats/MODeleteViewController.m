//
//  MODeleteViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-02.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MODeleteViewController.h"
#import "UIViewController+MJPopupViewController.h"

@interface MODeleteViewController () <UITableViewDataSource, UITableViewDelegate>

@property (strong, nonatomic) MOObjectConverter *converter;
@property (strong, nonatomic) IBOutlet UIView *detailDeleteView;
@property (strong, nonatomic) IBOutlet UITableView *datesTableView;
@property (strong, nonatomic) NSMutableArray *objectsAsPropertyList;



@end

@implementation MODeleteViewController

-(NSMutableArray *)objectsAsPropertyList{
    
    if (!_objectsAsPropertyList) {
        _objectsAsPropertyList = [[NSMutableArray alloc] init];
    }
    
    return _objectsAsPropertyList;
}


-(NSDictionary *)submissionObjectDict{
    
    if (!_submissionObjectDict) {
        _submissionObjectDict = [[NSDictionary alloc] init];
    }
    
    return _submissionObjectDict;
    
}

-(NSString *)sectionHeaderRecieved{
    
    if (!_sectionHeaderRecieved) {
        _sectionHeaderRecieved = [[NSString alloc] init];
    }
    
    return _sectionHeaderRecieved;
    
}

-(NSIndexPath *)indexOfSubmissionObject{
    
    if (!_indexOfSubmissionObject) {
        _indexOfSubmissionObject = [[NSIndexPath alloc] init];
    }
    
    return _indexOfSubmissionObject;
    
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
    
    //sets delegates for information passing
    self.datesTableView.delegate = self;
    self.datesTableView.dataSource = self;
    
    
    NSLog(@"DeleteViewController: the submission object passed is %@)", self.submissionObjectDict);
    
    //sets up the view
    [self getObjectsFromUserDefaults];
    [self setupSubmissionObjectDetails];
    
    
    //self.view.backgroundColor = [UIColor clearColor];
    
    //sets parameters for the tableView
    self.datesTableView.layer.borderWidth = 1.0;
    self.datesTableView.layer.borderColor = [UIColor blackColor].CGColor;
    
    [self prepViewForShow:self.deleteModalView];
    
    
}

-(void)viewDidAppear:(BOOL)animated{
    
    //[self setupView];
    
}


- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


//deals with crash on tableview that was crashing after editing it.
//-(void)dealloc{
    
    //self.datesTableView.editing = NO;
//}


-(IBAction)finishedButtonPressed:(id)sender{
    
    
    
    
    //[self dismissViewControllerAnimated:YES completion:nil];
    //UINavigationController *nav = (UINavigationController *)self.presentingViewController;
    //[self dismissViewControllerAnimated:YES completion:^{
        //[nav popViewControllerAnimated:YES];
        
    //}];
    
    [self.delegate reloadTableData];
    //[self dismissViewControllerAnimated:YES completion:nil];
    
    //dissmiss MJPopViewCOntroller and dismiss diming overlay
    [self dismissPopupViewControllerWithanimationType:MJPopupViewAnimationFade];

    
}



-(void)prepViewForShow:(UIView *)view{
    
    //any subviews will be clipped
    view.layer.masksToBounds = NO;
    //rounds corners of the view
    view.layer.cornerRadius = 8;
    
}


//loads the details from the submissionObjectAsDict sent to the view controller
-(void)setupSubmissionObjectDetails{
    
    self.submissionTypeLabel.text = self.submissionObjectDict[SUBMISSION_TYPE];
    self.submissionPositionLabel.text = self.submissionObjectDict[SUBMISSION_POSITION];
    self.topOrBottomLabel.text = self.submissionObjectDict[SUBMISSION_TOP_OR_BOTTOM];
    self.counterLabel.text = [NSString stringWithFormat:@"%@",self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER]];
    
    
}


//loads the right NSUserDefaults array depending on the section header sent.
-(void)getObjectsFromUserDefaults{
    
    if ([self.sectionHeaderRecieved isEqualToString:@"SUBMISSIONS"]) {
    
    self.objectsAsPropertyList = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
    
    NSLog(@"DeleteViewController: submissionObjectsAsPlist for SUBMISSIONS Header before %@", self.objectsAsPropertyList);
        
    }else if ([self.sectionHeaderRecieved isEqualToString:@"SUBMITTED"]){
        
        self.objectsAsPropertyList = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
        
        
        NSLog(@"DeleteViewController: submissionObjectsAsPlist for SUBMISSIONS Header before %@", self.objectsAsPropertyList);
        
    }
    
    
}

-(void)saveNewObject:(NSMutableDictionary *)editedObject{
    
    //checkes to make sure the counter is greater then 1
    if ([editedObject[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue] > 0) {
    
        //removes old object and replaces it with the edited object back in the array at the same index
        [self.objectsAsPropertyList removeObjectAtIndex:self.indexOfSubmissionObject.row];
        [self.objectsAsPropertyList insertObject:editedObject atIndex:self.indexOfSubmissionObject.row];
        
        NSLog(@"DeleteViewController: submissionObjectsAsPlist for SUBMISSIONS Header after when counter is greater than 0 %@", self.objectsAsPropertyList);
        
    //if the object counter equals 0 it removes it from the submissions/submitted list array
    }else if ([editedObject[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue] == 0){
        
        [self.objectsAsPropertyList removeObjectAtIndex:self.indexOfSubmissionObject.row];
        
        NSLog(@"DeleteViewController: submissionObjectsAsPlist for SUBMISSIONS Header after when counter is equal to 0 %@", self.objectsAsPropertyList);
    }
    
    //saves to the appropriate place
    if ([self.sectionHeaderRecieved isEqualToString:@"SUBMISSIONS"]) {
        
        [[NSUserDefaults standardUserDefaults] setObject:self.objectsAsPropertyList forKey:ADDED_SUBMISSION_OBJECTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }else if ([self.sectionHeaderRecieved isEqualToString:@"SUBMITTED"]){
        
        [[NSUserDefaults standardUserDefaults] setObject: self.objectsAsPropertyList forKey:ADDED_SUBMITTED_OBJECTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
    }

    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    if (self.submissionObjectDict) {
    
        cell.textLabel.text = [self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE] objectAtIndex:indexPath.row];
        NSLog(@"DeleteViewController: Date for table %@", [self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE] objectAtIndex:indexPath.row]);
    
        cell.backgroundColor = [UIColor clearColor];
        cell.textLabel.textColor = [UIColor colorWithRed: 0.29 green: 0.47 blue: 0.75 alpha: 1.0];
        cell.textLabel.font = [UIFont fontWithName:@"HelveticaNeue-Light" size:17.0];
    }
    return cell;
    
}



-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    
    
    NSLog(@"DeleteViewController: The number of rows is %lu", (unsigned long)[self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE] count]);
    
    return [self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE] count];
   
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    
    return 1;
    
}

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return TRUE;
}

//method crashes application. Need to reload submissionObject Data when method completes.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        
        [self.datesTableView beginUpdates];
        NSLog(@"DeleteViewController: Editing Deletion Started!!!");
        
        //creates temporary array to store dates so they can be modified
        NSMutableArray *tmpDatesArray = [self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE] mutableCopy];
        NSLog(@"DeletionView: tmpDatesArray array before %@", tmpDatesArray);
        
        //removed date after swiping to delete on table from datasource
        [tmpDatesArray removeObjectAtIndex:indexPath.row];
        //removes cell from table after clicking delete
        [self.datesTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        NSLog(@"DeletionView: tmpDatesArray after %@", tmpDatesArray);
        
        
        //create temporary counter for modification
        int tmpCounter = [self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue];
        NSLog(@"DeleteViewController: copied counter data %d", tmpCounter);
        
        //updates the new counter
        
        NSNumber *updatedCounter = [NSNumber numberWithInt:(tmpCounter - 1)];
        
        NSLog(@"DeleteViewController: setup new updated counter %@", updatedCounter);
        
        //makes a copy of the submission object
        NSMutableDictionary *tmpSubObject = [self.submissionObjectDict mutableCopy];
        NSLog(@"DeleteViewController: copied submission object");
        
        //sets the new updates counter
        //[[tmpSubObject objectForKey:@"Submission Counter and Date"] rem:@"Counter"];
        
        NSMutableDictionary *tempStore = [[tmpSubObject  objectForKey:@"Submission Counter and Date" ] mutableCopy];
        NSLog(@"DeleteViewController: temp store %@", tempStore);
    
    
        [tempStore setObject:updatedCounter forKey:@"Counter"];
        [tempStore setObject:tmpDatesArray forKey:@"Date"];
        
        NSLog(@"DeleteViewController: counter updated");
        
        //sets new dates array into modified object
        //[[tmpSubObject objectForKey:@"Submission Counter and Date" ] removeObjectForKey:@"Date"];
        //[[tmpSubObject  objectForKey:@"Submission Counter and Date" ] setObject:tmpDatesArray forKey:@"Date"];
        
        NSLog(@"DeleteViewController: dates updated");
        
        NSLog(@"DeleteViewController: temp store %@", tempStore);
        
        [tmpSubObject setObject:tempStore forKey:@"Submission Counter and Date"];
        
        NSLog(@"DeleteViewController: table reloaded and new object details %@", tmpSubObject);
        
        //saves the the new editied object to to NSUserDefaults
        [self saveNewObject:tmpSubObject];
        
        self.submissionObjectDict = tmpSubObject;
        
        //reloads the table data
        //[tableView reloadData];
        
        if (tmpCounter == 0) {
            [self finishedButtonPressed:nil];
        }else{
            
            //reload the details to reflect the updated information
            [self setupSubmissionObjectDetails];
            
        }
        
        [self.datesTableView endUpdates];
        
        
        
        
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
