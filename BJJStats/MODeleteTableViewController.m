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
//@property (strong, nonatomic) NSMutableArray *myDrawAsPropertyList;
@property (strong, nonatomic) NSDictionary *selectedObject;
@property (strong, nonatomic) MOObjectConverter *converter;
@property (strong, nonatomic) NSString *sectionHeader;
@property (strong, nonatomic) NSIndexPath *indexPathStored;




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

//-(NSMutableArray *)myDrawAsPropertyList{

//if (!_myDrawAsPropertyList) {
//_myDrawAsPropertyList = [[NSMutableArray alloc] init];
//}

//return _myDrawAsPropertyList;
//}

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
    
    
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
    //Gets the data stored in NSUserDefaults for submissions
    self.mySubmissionsAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
    
    //Gets the data stored in NSUserDefaults for submitted
    self.mySubmittedAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
    
//    
//    int index = 0;
//    for (NSMutableDictionary *item in self.mySubmissionsAsPropertyList) {
//        if ([item[SUBMISSION_TYPE] isEqualToString:@"In Arm Guillotine"]) {
//            if ([item[SUBMISSION_POSITION] isEqualToString:@"North/South"]){
//                NSMutableArray *tmpDic = [self.mySubmissionsAsPropertyList mutableCopy];
//                [tmpDic removeObjectAtIndex:index];
//                [[NSUserDefaults standardUserDefaults] setObject:tmpDic forKey:ADDED_SUBMISSION_OBJECTS_KEY];
//                [[NSUserDefaults standardUserDefaults] synchronize];
//                    }
//        }else{
//            index++;
//        }
//    }
//    
//    [self.tableView reloadData];
    
    
}

-(void)viewWillAppear:(BOOL)animated{
    
    
    
    [super viewWillAppear:YES];
    [self.tableView reloadData];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark MODeleteViewControllerDelegate

-(void)reloadTableData{
    
    NSLog(@"DeletionTableView: Delegate Fired Up");
    
    self.tableView.dataSource = nil;
    
    [self viewDidLoad];
    
    NSLog(@"DeleteTabelView: reloading Data");
    [self.tableView reloadData];
    NSLog(@"DeleteTabelView: data reloaded");
    
    
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    
    // Return the number of sections.
    //if ([self.mySubmittedAsPropertyList count] && ![self.mySubmissionsAsPropertyList count] | ![self.mySubmittedAsPropertyList count] && [self.mySubmissionsAsPropertyList count]) {
    //return 1;
    //}else{
    //return 2;
    //}
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    // Return the number of rows in the section.
    if (section == 0) {
        return [self.mySubmissionsAsPropertyList count];
    }else if(section == 1){
        return [self.mySubmittedAsPropertyList count];
    }//else if(section == 2){
    //return [self.myDrawAsPropertyList count];
    //}
    return 0;
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
    }//else if (indexPath.section == 2){
    
    //NSDictionary *selectedDrawObject = [self.myDrawAsPropertyList objectAtIndex:indexPath.row];
    
    //cell.textLabel.text = selectedDrawObject[SUBMISSION_TYPE];
    
    
    //}
    
    cell.backgroundColor = [UIColor clearColor];
    cell.textLabel.textColor = [UIColor colorWithRed: 0.29 green: 0.47 blue: 0.75 alpha: 1.0];
    cell.detailTextLabel.textColor = [UIColor colorWithRed: 0.29 green: 0.47 blue: 0.75 alpha: 1.0];
    
    
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    self.indexPathStored = indexPath;
    
    
    if (indexPath.section == 0) {
        
        self.selectedObject = [self.mySubmissionsAsPropertyList objectAtIndex:indexPath.row];
        
        UITableViewHeaderFooterView *headerTitle = [[UITableViewHeaderFooterView alloc] init];
        
        headerTitle = [self.tableView headerViewForSection:indexPath.section];
        
        self.sectionHeader = [NSString stringWithFormat:@"%@", headerTitle.textLabel.text];
        
        
        
        
    }else if (indexPath.section == 1){
        
        self.selectedObject = [self.mySubmittedAsPropertyList objectAtIndex:indexPath.row];
        
        UITableViewHeaderFooterView *headerTitle = [self.tableView headerViewForSection:indexPath.section];
        self.sectionHeader = [NSString stringWithFormat:@"%@", headerTitle.textLabel.text];
        
        
    }
    

    NSLog(@"DeletionTableView: The selected object to pass is %@", self.selectedObject);

    [self performSegueWithIdentifier:@"deleteSegue" sender:self];

}



//-(void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
//{
//    
//    //[self tableView:tableView didSelectRowAtIndexPath:indexPath];
//    
//    self.indexPathStored = indexPath;
//    
//    
//    if (indexPath.section == 0) {
//        
//        self.selectedObject = [self.mySubmissionsAsPropertyList objectAtIndex:indexPath.row];
//        
//        UITableViewHeaderFooterView *headerTitle = [[UITableViewHeaderFooterView alloc] init];
//        
//        headerTitle = [self.tableView headerViewForSection:indexPath.section];
//        
//        self.sectionHeader = [NSString stringWithFormat:@"%@", headerTitle.textLabel.text];
//        
//        
//        
//        //[self performSegueWithIdentifier:@"pushToDeleteViewController" sender:indexPath];
//        
//    }else if (indexPath.section == 1){
//        
//        self.selectedObject = [self.mySubmittedAsPropertyList objectAtIndex:indexPath.row];
//        
//        UITableViewHeaderFooterView *headerTitle = [self.tableView headerViewForSection:indexPath.section];
//        self.sectionHeader = [NSString stringWithFormat:@"%@", headerTitle.textLabel.text];
//        
//        
//    }
//    
//    
//    [self performSegueWithIdentifier:@"deleteSegue" sender:self];
//    
//    //[self performSegueWithIdentifier:@"pushToDelete" sender:self];
//    
//    //else if (indexPath.section == 2){
//        
//        //self.selectedObject = [self.myDrawAsPropertyList objectAtIndex:indexPath.row];
//        
//        //UITableViewHeaderFooterView *headerTitle = [self.tableView headerViewForSection:indexPath.section];
//        //self.sectionHeader = [NSString stringWithFormat:@"%@", headerTitle.textLabel.text];
//        
//        
//        //[self performSegueWithIdentifier:@"pushToDeleteViewController" sender:self];
//        
//    //}
//    
//}



-(NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section{
    
    NSString *sectionName;
    
    switch (section) {
        case 0:
            sectionName = @"Submissions";
            break;
        case 1:
            sectionName = @"Submitted";
            break;
        case 2:
            sectionName = @"Draw";
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
    //if([sender isKindOfClass:[UITableViewCell class]]){
    //if ([segue.destinationViewController isKindOfClass:[MODeleteViewController class] ]){
        //if ([segue.identifier isEqualToString:@"deleteSegue"]) {
        
        
        
        MODeleteViewController *deleteVC = segue.destinationViewController;
        
        
        //setting delegate for reloadTable method
        deleteVC.delegate = self;
        //setting data to pass to deleteView
        deleteVC.submissionObjectDict = self.selectedObject;
        deleteVC.indexOfSubmissionObject =self.indexPathStored;
        deleteVC.sectionHeaderRecieved = self.sectionHeader;
        
       
        
        //}
    //}
    
}

#pragma mark HelperMethod






@end
