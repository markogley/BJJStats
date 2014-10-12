//
//  MOVTopTableTableViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-09-21.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOTopTableTableViewController.h"
#import "MOSubmissionData.h"


@interface MOTopTableTableViewController ()

@property (strong, nonatomic) NSString *cellLabel;


@end




@implementation MOTopTableTableViewController




-(NSMutableArray *)submissions{
    
    if (!_submissions) {
        _submissions = [[NSMutableArray alloc] init];
    }
    
    return _submissions;
}

-(NSMutableArray *)submitted{
    
    if (!_submitted) {
        _submitted = [[NSMutableArray alloc] init];
    }
    
    return _submitted;
    
}

-(NSString *)cellLabel{
    if (!_cellLabel) {
        _cellLabel = [[NSString alloc] init];
    }
    
    return _cellLabel;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
    
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
    self.tableViewTitle.title = self.position;
    self.navigationItem.backBarButtonItem.title = @"";
    
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    // Return the number of sections.
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {

    // Return the number of rows in the section.
    if (self.segmentIndex == 0) {
    
        return [self.submissions count];
    
    }
    
    if (self.segmentIndex == 1) {
        
        return [self.submitted count];
    }
    
    return 0;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *ReuseIdentifier = @"Cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    // Configure the cell...
    
    if (self.segmentIndex == 0) {
    
        cell.textLabel.text = self.submissions[indexPath.row][SUBMISSION_TYPE];
        cell.detailTextLabel.text = [ NSString stringWithFormat:@"Performed %@ times", self.submissions[indexPath.row][SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER]];
    
    }
    
    if (self.segmentIndex == 1) {
        
        cell.textLabel.text = self.submitted[indexPath.row][SUBMISSION_TYPE];
        cell.detailTextLabel.text = [ NSString stringWithFormat:@"Performed %@ times", self.submitted[indexPath.row][SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER]];
    
    }
    
    return cell;
}

//-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    
    
    //if (self.segmentIndex == 0) {
        
        //UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
        //self.cellLabel = cell.textLabel.text;
        
        
        //self.cellLabel = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    //}
    
    //if (self.segmentIndex == 1) {
        
     //   UITableViewCell *cell = [tableView cellForRowAtIndexPath:indexPath];
     //   self.cellLabel = cell.textLabel.text;
        
        //self.cellLabel = [[[tableView cellForRowAtIndexPath:indexPath] textLabel] text];
    //}
    
    //NSLog(@"DidselectRow: %@", self.cellLabel);
    //[self.navigationController performSegueWithIdentifier:@"collectionViewSegue" sender:self];
//}

/*
// Override to support conditional editing of the table view.
- (BOOL)tableView:(UITableView *)tableView canEditRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the specified item to be editable.
    return YES;
}
*/

/*
// Override to support editing the table view.
- (void)tableView:(UITableView *)tableView commitEditingStyle:(UITableViewCellEditingStyle)editingStyle forRowAtIndexPath:(NSIndexPath *)indexPath {
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
- (void)tableView:(UITableView *)tableView moveRowAtIndexPath:(NSIndexPath *)fromIndexPath toIndexPath:(NSIndexPath *)toIndexPath {
}
*/

/*
// Override to support conditional rearranging of the table view.
- (BOOL)tableView:(UITableView *)tableView canMoveRowAtIndexPath:(NSIndexPath *)indexPath {
    // Return NO if you do not want the item to be re-orderable.
    return YES;
}
*/


#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
    
    if ([sender isKindOfClass:[UITableViewCell class]]) {
        if ([segue.destinationViewController isKindOfClass:[MOMoreCollectionViewController class]]) {
            MOMoreCollectionViewController *destinVC = segue.destinationViewController;
            NSIndexPath *path = [self.tableView indexPathForCell:sender];
            if (self.segmentIndex == 0) {
                self.cellLabel = self.submissions[path.row][SUBMISSION_TYPE];
                destinVC.segmentIndexCollectionView = self.segmentIndex;
            }
            if(self.segmentIndex == 1){
                self.cellLabel = self.submitted[path.row][SUBMISSION_TYPE];
                destinVC.segmentIndexCollectionView = self.segmentIndex;
            }
            
            destinVC.labelFromCell = self.cellLabel;
            
        }
    }
    
    
}


@end
