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
//@property (strong, nonatomic) IBOutlet UITextView *datesTextView;
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

-(void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        NSLog(@"DeleteViewController: Editing Delete Started!!!");
        
        
        MOObjectConverter *converter = [[MOObjectConverter alloc] init];
        MOSubmissionObject *deletedObject = [converter submissionObjectForDictionary:self.submissionObjectDict];
        [deletedObject decrementCounter];
        
        //deletedObject.datesArray = [deletedObject.datesArray mutableCopy];
        NSMutableArray *updatedDates = [deletedObject.datesArray mutableCopy];
        NSLog(@"DeleteViewController: updatedDatesArray before %@", updatedDates);
        [updatedDates removeObjectAtIndex:indexPath.row];
        NSLog(@"DeleteViewController: updatedDatesArray after %@", updatedDates);
        deletedObject.datesArray = [updatedDates copy];
        NSLog(@"DeleteViewController: deletedObjectDatesArrayNew is %@", deletedObject.datesArray);
        NSLog(@"DeleteViewController: The counter for the edited object is %i", deletedObject.counter);
        
        
        self.counterLabel.text = [NSString stringWithFormat:@"%i", deletedObject.counter];
        
        MOSubmissionsPersistenceManager *saveEditedSubmissionObject = [[MOSubmissionsPersistenceManager alloc]init];
        
        NSLog(@"DeleteViewController: The header is %@", self.sectionHeaderRecieved);
        if ([self.sectionHeaderRecieved isEqualToString:@"SUBMISSIONS"]) {
            
            NSLog(@"DeleteViewController: The header is equal to Submissions and the counter is %i", deletedObject.counter);
            
            //open preveous submissions saved in NSUserDefaults
            NSMutableArray *submissionObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
            
            //if submissionsObjectAsPropertyList does not exist allocate and initialize it
            if (!submissionObjectsAsPropertyLists) {
                submissionObjectsAsPropertyLists = [[NSMutableArray alloc] init];
            }
            
            [saveEditedSubmissionObject compareEditedSubmissionObjectToSavedData:submissionObjectsAsPropertyLists newSubmissionObject:deletedObject];
            
            NSLog(@"DeleteViewController: submissionsAsProperty after persistance %@", submissionObjectsAsPropertyLists);
            
            [[NSUserDefaults standardUserDefaults] setObject:submissionObjectsAsPropertyLists forKey:ADDED_SUBMISSION_OBJECTS_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
        }else if ([self.sectionHeaderRecieved isEqualToString:@"SUBMITTED"]){
            
            //open preveous submissions saved in NSUserDefaults
            NSMutableArray *submittedObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
            //if submissionsObjectAsPropertyList does not exist allocate and initialize it
            if (!submittedObjectsAsPropertyLists) {
                submittedObjectsAsPropertyLists = [[NSMutableArray alloc] init];
            }
            
            [saveEditedSubmissionObject compareEditedSubmissionObjectToSavedData:submittedObjectsAsPropertyLists newSubmissionObject:deletedObject];
            
            [[NSUserDefaults standardUserDefaults] setObject:submittedObjectsAsPropertyLists forKey:ADDED_SUBMITTED_OBJECTS_KEY];
            [[NSUserDefaults standardUserDefaults] synchronize];
            
            
        }
        
        //my rowsinsection and datesTableView are not reloading when I delete an object from my array.
        [self.datesTableView reloadData];
        
        if (deletedObject.counter == 0) {
            [self dismissViewControllerAnimated:YES completion:nil];
        }
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
