//
//  MOMoreViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-24.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOMoreViewController.h"
#import "MOSubmissionsPersistenceManager.h"
#import "MOSubmissionObject.h"
#import "MOMatchObject.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "MOCustomCollectionViewCell.h"

@interface MOMoreViewController ()
@property (strong, nonatomic) IBOutlet UILabel *numberOfMatchesLabel;

@property (strong, nonatomic) NSMutableArray *mySubmissionsAsPropertyList;
@property (strong, nonatomic) NSMutableArray *mySubmittedAsPropertyList;
@property (strong, nonatomic) NSMutableArray *matchesAsPropertyList;
@property (strong, nonatomic) NSMutableArray *youTubeJSONResponseAsArray;




@end

@implementation MOMoreViewController

-(NSMutableArray *)mySubmissionsAsPropertyList{
    
    if (!_mySubmissionsAsPropertyList) {
        _mySubmissionsAsPropertyList = [[NSMutableArray alloc] init];
    }
    
    return _mySubmissionsAsPropertyList;
}

-(NSMutableArray *)mySubmittedAsPropertyList{
    
    if (!_mySubmittedAsPropertyList) {
        _mySubmittedAsPropertyList = [[NSMutableArray alloc] init];
    }
    
    return _mySubmittedAsPropertyList;
}

-(NSMutableArray *)matchesAsPropertyList{
    
    if (!_matchesAsPropertyList) {
        _matchesAsPropertyList = [[NSMutableArray alloc] init];
    }
    
    return _matchesAsPropertyList;
}

-(NSMutableArray *)youTubeJSONResponseAsArray{
    
    if (!_youTubeJSONResponseAsArray) {
        _youTubeJSONResponseAsArray = [[NSMutableArray alloc] init];
    }
    
    return _youTubeJSONResponseAsArray;
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
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN){
            
            [self retrieveYouTubeVideoLinks];
        }else if (status == AFNetworkReachabilityStatusNotReachable){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"This application needs to be on the internet to be used to its fullest." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }
        
     
        }];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    
    //Gets the data stored in NSUserDefaults for submissions
    self.mySubmissionsAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
    
    //Gets the data stored in NSUserDefaults for submitted
    self.mySubmittedAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
    
    [self strongestSubmission];
    [self submittedTheMostBy];
    self.numberOfMatchesLabel.text = [self numberOfRolls];
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ViewHelperMethods

-(void)strongestSubmission{
    int index = 0;
    int indexOfStrongestSubmission = 0;
    int numberOfSubmission = 0;
    NSDictionary *submission;
    if (self.mySubmissionsAsPropertyList.count) {
        for (submission in self.mySubmissionsAsPropertyList) {
            NSLog(@"MoreViewController: submission %@", submission);
            if (numberOfSubmission <= [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue]) {
                numberOfSubmission = [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue];
                indexOfStrongestSubmission = index;
                index++;
                NSLog(@"MoreViewController: index = %i and indexOfStrongestSubmission = %i", index, indexOfStrongestSubmission);
                
            }else{
                index ++;
            }
            self.strongestSubmissionLabel.text = self.mySubmissionsAsPropertyList[indexOfStrongestSubmission][SUBMISSION_TYPE];
        }
    }else{
        
        self.strongestSubmissionLabel.text = @"";
    }

}

-(void)submittedTheMostBy{
    
    int index = 0;
    int indexOfStrongestSubmission = 0;
    int numberOfSubmission = 0;
    NSDictionary *submission;
    if (self.mySubmittedAsPropertyList.count) {
        for (submission in self.mySubmittedAsPropertyList) {
            NSLog(@"MoreViewController: submission %@", submission);
            if (numberOfSubmission <= [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue]) {
                numberOfSubmission = [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue];
                indexOfStrongestSubmission = index;
                index++;
                NSLog(@"MoreViewController: index = %i and indexOfMostSubmitted = %i", index, indexOfStrongestSubmission);
            
            }else{
                index ++;
        }
    }
    self.mostSubmittedByLabel.text = self.mySubmittedAsPropertyList[indexOfStrongestSubmission][SUBMISSION_TYPE];
    }else{
        self.mostSubmittedByLabel.text = @"";
    }
    
    
}

-(NSString *)numberOfRolls{
    
    self.matchesAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_MATCH_OBJECTS_KEY] mutableCopy];
    
    NSLog(@"MoreViewCOntroller: matches as plist is %@", self.matchesAsPropertyList);
    
    int numberOfMatches = 0;
    for (NSDictionary *entry in self.matchesAsPropertyList){
        
        numberOfMatches = [entry[NUMBER_OF_MATCHES] intValue] + numberOfMatches;
        NSLog(@"MoreViewController: Number of Matches equals %i and entry was %@", numberOfMatches, entry);
    }
    
    NSString *numberOfMatchesAsString = [NSString stringWithFormat:@"You have rolled %i since using this app.", numberOfMatches];
    
    return numberOfMatchesAsString;
}

-(void)retrieveYouTubeVideoLinks{
    
    NSString *youtubeAPIKey = @"AIzaSyCNCsK_dknS6n1PokMBNC_BLumsza_LwxA";
    NSString *baseURL = @"https://www.googleapis.com/youtube/v3/search?part=snippet&q=";
    NSString *searchTerm = [NSString  stringWithFormat:@"%@ Jiu Jitsu escape", self.mostSubmittedByLabel.text];
    NSString *escapedSearchResult = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    NSString *searchURL = [NSString stringWithFormat:@"%@%@&maxResults=5&key=%@",baseURL, escapedSearchResult, youtubeAPIKey];
    
    NSURL *url = [NSURL URLWithString:searchURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        NSDictionary *youTubeJSONResponse = (NSDictionary*)responseObject;
        
        
        //need to parse JSON response into array
        for(NSDictionary *item in youTubeJSONResponse[@"items"]){
            
            [self.youTubeJSONResponseAsArray addObject:item];
            
        }
        
        NSLog(@"MoreViewController: The newArray response is %@", self.youTubeJSONResponseAsArray);
        NSLog(@"MoreViewController: Image URL %@", [self.youTubeJSONResponseAsArray[0] valueForKeyPath:@"snippet.thumbnails.high.url"]);
        
        [self.collectionView reloadData];
        
        
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Videos"
                                                            message:[error localizedDescription]
                                                           delegate:nil
                                                  cancelButtonTitle:@"Ok"
                                                  otherButtonTitles:nil];
        [alertView show];
        
    }];
    
     [operation start];
    
}


#pragma mark UICollectionViewDelegate

-(NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    
    if (section == 0) {
        
    return [self.youTubeJSONResponseAsArray count];
        
    }else if (section == 1){
        
        return 1;
    }
    
    return 2;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 2;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    MOCustomCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor whiteColor];
    
    if (indexPath.section == 0) {
    
        if(self.youTubeJSONResponseAsArray){
            dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
        
                NSLog(@"MoreViewController: Image Download begun");
                NSURL *imageURL = [NSURL URLWithString:[NSString stringWithFormat:@"%@", [self.youTubeJSONResponseAsArray[indexPath.row] valueForKeyPath:@"snippet.thumbnails.high.url"]]];
                NSData *imgData = [[NSData alloc] initWithContentsOfURL:imageURL];
        
                dispatch_async(dispatch_get_main_queue(), ^{
                    cell.imageView.image = [[UIImage alloc] initWithData:imgData];
                    cell.videoTitleLabel.text =[NSString stringWithFormat:@"%@", [self.youTubeJSONResponseAsArray[indexPath.row] valueForKeyPath:@"snippet.title"]];
                });
            });
        }
    }
    
    return cell;
    
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        MOUICollectionResuableViewHeader *header = [[MOUICollectionResuableViewHeader alloc] init];
        
        header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        
        if (indexPath.section == 0) {
            NSString *title = [NSString stringWithFormat:@"%@", self.strongestSubmissionLabel.text];
            NSLog(@"MoreViewController: title is %@", title);
            header.collectionViewHeader.text = title;
        }
        
        if (indexPath.section == 1) {
            NSString *title = [NSString stringWithFormat:@"%@ Escapes", self.mostSubmittedByLabel.text];
            NSLog(@"MoreViewController: title is %@", title);
            header.collectionViewHeader.text = title;
        }
        
        reusableView = header;
        reusableView.hidden = NO;
        NSLog(@"MoreViewController: reusableView %i", reusableView.hidden);
    }
    
    return reusableView;
    
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

#pragma mark IBActions

@end
