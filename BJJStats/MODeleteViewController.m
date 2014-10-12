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
//sometimes crashes the app
-(IBAction)finishedButtonPressed:(id)sender{
    
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

//crashes app if their is 1 date left in an object and you try to delete it. Might rewrite to bypass this function or change fuction to something simpler that only requires replacing a old object with a new edited object. 
-(void)saveNewObject{
    
    MOObjectConverter *converter = [[MOObjectConverter alloc] init];
    MOSubmissionObject *editedObject = [converter submissionObjectForDictionary:self.submissionObjectDict];
    //[deletedObject decrementCounter];
    
    //NSMutableArray *updatedDates = [deletedObject.datesArray mutableCopy];
    //[updatedDates removeObjectAtIndex:index.row];
    //deletedObject.datesArray = [updatedDates copy];
    
    //once the dates array is empty this might be the spot to remove the object from NSUserdefaults and dismiss the viewcontroller
    
    //self.counterLabel.text = [NSString stringWithFormat:@"%i", deletedObject.counter];
    
    MOSubmissionsPersistenceManager *saveEditedSubmissionObject = [[MOSubmissionsPersistenceManager alloc]init];
    
    
    if ([self.sectionHeaderRecieved isEqualToString:@"SUBMISSIONS"]) {
        
        //open preveous submissions saved in NSUserDefaults
        NSMutableArray *submissionObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
        
        
        [saveEditedSubmissionObject compareEditedSubmissionObjectToSavedData:submissionObjectsAsPropertyLists newSubmissionObject:editedObject sectionHeader:self.sectionHeaderRecieved];
        
        
        //[[NSUserDefaults standardUserDefaults] setObject:submissionObjectsAsPropertyLists forKey:ADDED_SUBMISSION_OBJECTS_KEY];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        
    }else if ([self.sectionHeaderRecieved isEqualToString:@"SUBMITTED"]){
        
        //open preveous submitted saved in NSUserDefaults
        NSMutableArray *submittedObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
        
        
        [saveEditedSubmissionObject compareEditedSubmissionObjectToSavedData:submittedObjectsAsPropertyLists newSubmissionObject:editedObject sectionHeader:self.sectionHeaderRecieved];
        
        //[[NSUserDefaults standardUserDefaults] setObject:submittedObjectsAsPropertyLists forKey:ADDED_SUBMITTED_OBJECTS_KEY];
        //[[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }//else if ([self.sectionHeaderRecieved isEqualToString:@"DRAW"]){
        
        //NSMutableArray *drawObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_DRAW_OBJECTS_KEY] mutableCopy];
        
        
        //[saveEditedSubmissionObject compareEditedSubmissionObjectToSavedData:drawObjectsAsPropertyLists newSubmissionObject:deletedObject sectionHeader:self.sectionHeaderRecieved];
        
    //}
    
}
//deprecated with new commitEditingDelete tableview rewrite
//-(void)reloadTableAfterEditing{
//    
//    NSLog(@"DeletionViewController: reloading Data submissionObjectAsDic %@", self.submissionObjectDict);
//    
//    if ([self.sectionHeaderRecieved isEqualToString:@"SUBMISSIONS"]) {
//        NSLog(@"DeletionViewController: reloading Data for Submission");
//        
//        NSMutableArray *submissionObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
//        
//        
//        NSLog(@"DeletionController:IndexPath section %ld  row %ld", (long)self.indexOfSubmissionObject.section, (long)self.indexOfSubmissionObject.row);
//        
//        NSLog(@"DeletionController: submittedObjectsAsPropertyList %@", submissionObjectsAsPropertyLists);
//        
//        
//        if (!submissionObjectsAsPropertyLists | !submissionObjectsAsPropertyLists.count) {
//            self.submissionObjectDict = nil;
//        }else{
//            
//        self.submissionObjectDict = [submissionObjectsAsPropertyLists  objectAtIndex:self.indexOfSubmissionObject.row];
//        }
//        
//        NSLog(@"DeletionViewController: submissionObject %@", self.submissionObjectDict);
//    
//    }else if([self.sectionHeaderRecieved isEqualToString:@"SUBMITTED"]){
//        
//        NSLog(@"DeletionViewController: reloading Data for Submitted");
//        
//        NSMutableArray *submittedObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
//        
//        NSLog(@"DeletionController:IndexPath section %ld  row %ld", (long)self.indexOfSubmissionObject.section, (long)self.indexOfSubmissionObject.row);
//        
//        NSLog(@"DeletionController: submittedObjects");
//        
//        if (!submittedObjectsAsPropertyLists | !submittedObjectsAsPropertyLists.count) {
//            self.submissionObjectDict = nil;
//        }else{
//        
//        self.submissionObjectDict = [submittedObjectsAsPropertyLists  objectAtIndex:self.indexOfSubmissionObject.row];
//        }
//        NSLog(@"DeletionViewController: submissionObject %@", self.submissionObjectDict);
//        
//    }//else if ([self.sectionHeaderRecieved isEqualToString:@"DRAW"]){
//        
//        //NSLog(@"DeletionViewController: reloading Data for Draw");
//        
//        //NSMutableArray *drawObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_DRAW_OBJECTS_KEY] mutableCopy];
//        
//        //NSLog(@"DeletionController:IndexPath section %ld  row %ld", (long)self.indexOfSubmissionObject.section, (long)self.indexOfSubmissionObject.row);
//        
//        //NSLog(@"DeletionController: submittedObjects %@", self.submissionObjectDict);
//
//        //if (self.indexOfSubmissionObject.row == 0 && [self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] integerValue] == 1) {
//            //[self dismissViewControllerAnimated:YES completion:nil];
//        //}else{
//        //self.submissionObjectDict = [drawObjectsAsPropertyLists  objectAtIndex:self.indexOfSubmissionObject.row];
//        //}
//        //NSLog(@"DeletionViewController: submissionObject %@", self.submissionObjectDict);
//        
//   // }
//    
//}


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

-(BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath{
    
    return TRUE;
}

//method crashes application. Need to reload submissionObject Data when method completes.
-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"DeleteViewController: Editing Deletion Started!!!");
        
        
        NSMutableArray *tmpDatesArray = [ self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE] mutableCopy];
        NSLog(@"DeletionView: tmpDatesArray array before %@", tmpDatesArray);
        
        [tmpDatesArray removeObjectAtIndex:indexPath.row];
        
        NSLog(@"DeletionView: tmpDatesArray after %@", tmpDatesArray);
        
        self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE] = tmpDatesArray;
        int tmpCounter = [self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue];
        
        NSNumber *updatedCounter = [NSNumber numberWithInt:(tmpCounter - 1)];
        
        NSMutableDictionary *tmpSubObject = [self.submissionObjectDict mutableCopy];
        
        [tmpSubObject setValue:updatedCounter forKeyPath:@"Submission Counter and Date.Counter"];
        
        NSLog(@"DeletionView: SubmissionObject after update %@", tmpSubObject);
        
        [tableView reloadData];
        [self setupSubmissionObjectDetails];
        
        //rewrite new save method that might not need the persistance manager to impliment
        //[self saveNewObject];
        
        
        
        //[tableView beginUpdates];
        //if ([self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] integerValue]== 1) {
            
            
            
        //}else{
        //[self removeDateFromObject:indexPath];
        //[tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
        //if (self.submissionObjectDict[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] == 0) {
        //    [self dismissViewControllerAnimated:YES completion:nil];
        //}
        
        //if ([self.counterLabel.text isEqualToString:@"0"]) {
            //[self dismissViewControllerAnimated:YES completion:nil];
        //}
        
        //[self reloadTableAfterEditing];
        //}
        //[tableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationAutomatic];
        

        
        //[tableView endUpdates];
        
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
