//
//  MODeleteTableViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-02.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MODeleteTableViewController.h"

@interface MODeleteTableViewController ()

@property (strong, nonatomic) NSMutableArray *mySubmissionsAsPropertyList;
@property (strong, nonatomic) NSMutableArray *mySubmittedAsPropertyList;
@property (strong, nonatomic) NSDictionary *selectedObject;
@property (strong, nonatomic) MOObjectConverter *converter;
@property (strong, nonatomic) NSString *sectionHeader;


@end

@implementation MODeleteTableViewController

-(NSMutableArray *)mySubmissionsAsPropertyList{
    if (!_mySubmissionsAsPropertyList) {
        _mySubmissionsAsPropertyList = [[NSMutableArray alloc] init];
    }
    return _mySubmissionsAsPropertyList;
}

-(NSMutableArray *)mySubmittedAsPropertyList{
    if(!_mySubmittedAsPropertyList){
        _mySubmittedAsPropertyList = [[NSMutableArray alloc] init];
    }
    
    return _mySubmittedAsPropertyList;
}

-(NSDictionary *)selectedObject{
    if (!_selectedObject) {
        _selectedObject = [[NSDictionary alloc] init];
    }
    return _selectedObject;
}

-(NSString *)sectionHeader{
    
    if (!_sectionHeader) {
        _sectionHeader = [[NSString alloc] init];
    }
    
    return _sectionHeader;
    
}


- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        // Custom initialization
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.mySubmissionsAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
    
    //Gets the data stored in NSUserDefaults for submitted
    self.mySubmittedAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
    
    
    
    NSLog(@"mySubmittedAsPropertyList %@", self.mySubmittedAsPropertyList);
}

-(void)viewWillAppear:(BOOL)animated{
    
    [super viewWillAppear:YES];
    [self viewDidLoad];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{

    // Return the number of sections.
    if ([self.mySubmittedAsPropertyList count] && ![self.mySubmissionsAsPropertyList count] | ![self.mySubmittedAsPropertyList count] && [self.mySubmissionsAsPropertyList count]) {
        //return 1;
    }else{
        return 2;
    }
    return 0;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [self.mySubmissionsAsPropertyList count];
    }else{
        return [self.mySubmittedAsPropertyList count];
    }
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    
    static NSString *CellIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    
    // Configure the cell...
    if (indexPath.section == 0) {
        
        NSDictionary *selectedSubmissionObject = [self.mySubmissionsAsPropertyList objectAtIndex:indexPath.row];
        
        cell.textLabel.text = selectedSubmissionObject[SUBMISSION_TYPE];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", selectedSubmissionObject[SUBMISSION_POSITION], selectedSubmissionObject[SUBMISSION_TOP_OR_BOTTOM]];
    }else if(indexPath.section == 1){
        NSDictionary *selectedSubmittedObject = [self.mySubmittedAsPropertyList objectAtIndex:indexPath.row];
        
        cell.textLabel.text = selectedSubmittedObject[SUBMISSION_TYPE];
        cell.detailTextLabel.text = [NSString stringWithFormat:@"%@ - %@", selectedSubmittedObject[SUBMISSION_POSITION], selectedSubmittedObject[SUBMISSION_TOP_OR_BOTTOM]];
    }
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed: 0.29 green: 0.47 blue: 0.75 alpha: 1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed: 0.29 green: 0.47 blue: 0.75 alpha: 1.0];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.section == 0) {
        
    self.selectedObject = [self.mySubmissionsAsPropertyList objectAtIndex:indexPath.row];
    
    UITableViewHeaderFooterView *headerTitle = [self.tableView headerViewForSection:indexPath.section];
    self.sectionHeader = [NSString stringWithFormat:@"%@", headerTitle.textLabel.text];

    
    [self performSegueWithIdentifier:@"pushToDeleteViewController" sender:indexPath];
        
    }else if (indexPath.section == 1){
        
        self.selectedObject = [self.mySubmittedAsPropertyList objectAtIndex:indexPath.row];
        
        UITableViewHeaderFooterView *headerTitle = [self.tableView headerViewForSection:indexPath.section];
        self.sectionHeader = [NSString stringWithFormat:@"%@", headerTitle.textLabel.text];
        
        
        [self performSegueWithIdentifier:@"pushToDeleteViewController" sender:indexPath];
        
    }
    
}

-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionName;
    
    switch (section) {
        case 0:
            sectionName = @"Submissions";
            break;
        case 1:
            sectionName = @"Submitted";
            break;
        default:
            break;
    }
    
    return sectionName;
}


/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath
{
    if (editingStyle == UITableViewCellEditingStyleDelete) {
        // Delete the row from the data source
        [tableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationFade];
    } else if (editingStyle == UITableViewCellEditingStyleInsert) {
        // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
    }   
}
*/

/*
// Override to support rearranging the table view.
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath
{
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath
{
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender
{
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    MODeleteViewController *deleteVC = segue.destinationViewController;
    
    deleteVC.submissionObjectDict = self.selectedObject;
    NSLog(@"The sections header is %@", self.sectionHeader);
    
    deleteVC.sectionHeaderRecieved = self.sectionHeader;
    
}



@end
