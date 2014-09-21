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
#import "MOAppDelegate.h"

@interface MOMoreViewController ()
//@property (strong, nonatomic) IBOutlet UILabel *numberOfMatchesLabel;

//@property (strong, nonatomic) NSMutableArray *mySubmissionsAsPropertyList;
//@property (strong, nonatomic) NSMutableArray *mySubmittedAsPropertyList;
//@property (strong, nonatomic) NSMutableArray *matchesAsPropertyList;
@property (strong, nonatomic) NSMutableArray *youTubeJSONResponseAsArray;
//@property (strong, nonatomic) NSMutableArray *youTubeJSONResponseAsArraySubmitted;
//@property int randomIndex;



//@property (strong, nonatomic) IBOutlet UIWebView *testUiWebView;




@end

@implementation MOMoreViewController

//-(NSMutableArray *)mySubmissionsAsPropertyList{
//    
//    if (!_mySubmissionsAsPropertyList) {
//        _mySubmissionsAsPropertyList = [[NSMutableArray alloc] init];
//    }
//    
//    return _mySubmissionsAsPropertyList;
//}
//
//-(NSMutableArray *)mySubmittedAsPropertyList{
//    
//    if (!_mySubmittedAsPropertyList) {
//        _mySubmittedAsPropertyList = [[NSMutableArray alloc] init];
//    }
//    
//    return _mySubmittedAsPropertyList;
//}

//-(NSMutableArray *)matchesAsPropertyList{
//    
//    if (!_matchesAsPropertyList) {
//        _matchesAsPropertyList = [[NSMutableArray alloc] init];
//    }
//    
//    return _matchesAsPropertyList;
//}

-(NSMutableArray *)youTubeJSONResponseAsArray{
    
    if (!_youTubeJSONResponseAsArray) {
        _youTubeJSONResponseAsArray = [[NSMutableArray alloc] init];
    }
    
    return _youTubeJSONResponseAsArray ;
}

//-(NSMutableArray *)youTubeJSONResponseAsArraySubmission{
//    
//    if(!_youTubeJSONResponseAsArraySubmission){
//        
//        _youTubeJSONResponseAsArraySubmission = [[NSMutableArray alloc] init];
//    }
//    
//    return _youTubeJSONResponseAsArraySubmission;
//    
//}

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
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    
    _collectionView.dataSource = self;
    _collectionView.delegate = self;
    
    self.collectionView.backgroundColor = [UIColor grayColor];
    
    
    
    //Gets the data stored in NSUserDefaults for submissions
//    self.mySubmissionsAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
//    
//    //Gets the data stored in NSUserDefaults for submitted
//    self.mySubmittedAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
    
    //[self strongestSubmission];
    //[self submittedTheMostBy];
    //self.numberOfMatchesLabel.text = [self numberOfRolls];
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


#pragma mark ViewHelperMethods

//-(void)strongestSubmission{
//    int index = 0;
//    int indexOfStrongestSubmission = 0;
//    int numberOfSubmission = 0;
//    NSDictionary *submission = [[NSDictionary alloc] init];
//    if (self.mySubmissionsAsPropertyList.count) {
//        for (submission in self.mySubmissionsAsPropertyList) {
//            
//            if (numberOfSubmission <= [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue]) {
//                numberOfSubmission = [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue];
//                indexOfStrongestSubmission = index;
//                index++;
//                
//            }else{
//                index ++;
//            }
//            self.strongestSubmissionLabel.text = self.mySubmissionsAsPropertyList[indexOfStrongestSubmission][SUBMISSION_TYPE];
//        }
//    }else{
//        
//        self.strongestSubmissionLabel.text = @"";
//    }
//
//}

//-(void)submittedTheMostBy{
//    
//    int index = 0;
//    int indexOfStrongestSubmission = 0;
//    int numberOfSubmission = 0;
//    NSDictionary *submission;
//    if (self.mySubmittedAsPropertyList.count) {
//        for (submission in self.mySubmittedAsPropertyList) {
//            
//            if (numberOfSubmission <= [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue]) {
//                numberOfSubmission = [submission[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_COUNTER] intValue];
//                indexOfStrongestSubmission = index;
//                index++;
//            
//            }else{
//                index ++;
//        }
//    }
//    self.mostSubmittedByLabel.text = self.mySubmittedAsPropertyList[indexOfStrongestSubmission][SUBMISSION_TYPE];
//    }else{
//        self.mostSubmittedByLabel.text = @"";
//    }
//    
//
//}
//
//-(NSString *)numberOfRolls{
//    
//    self.matchesAsPropertyList = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_MATCH_OBJECTS_KEY] mutableCopy];
//    
//    NSLog(@"MoreViewCOntroller: matches as plist is %@", self.matchesAsPropertyList);
//    
//    int numberOfMatches = 0;
//    for (NSDictionary *entry in self.matchesAsPropertyList){
//        
//        numberOfMatches = [entry[NUMBER_OF_MATCHES] intValue] + numberOfMatches;
//        NSLog(@"MoreViewController: Number of Matches equals %i and entry was %@", numberOfMatches, entry);
//    }
//    
//    NSString *numberOfMatchesAsString = [NSString stringWithFormat:@"You have rolled %i since using this app.", numberOfMatches];
//    
//    return numberOfMatchesAsString;
//}
//
//-(void)loadWebViewTest{
    
    //NSString *youTubeVideoLink = [NSString stringWithFormat:@"<iframe width= %f height= %f src=http://www.youtube.com/embed/%@ frameborder=0 allowfullscreen></iframe>",self.testUiWebView.frame.size.width, self.testUiWebView.frame.size.height, self.youTubeJSONResponseAsArray[0][@"id"][@"videoId"]];
    
    //NSLog(@"%@", youTubeVideoLink);
    
    //NSURL *testURL = [NSURL URLWithString:youTubeVideoLink];
    
    //NSURLRequest *request = [NSURLRequest requestWithURL:testURL];
    
    //[self.testUiWebView setMediaPlaybackRequiresUserAction:NO];
    //[self.testUiWebView loadRequest:request];
    //[self. loadHTMLString:youTubeVideoLink baseURL:nil];
    
    
//}

-(void)retrieveYouTubeVideoLinks{
    
    //self.randomIndex = (arc4random() % self.mySubmissionsAsPropertyList.count);
    
    NSString *youtubeAPIKey = @"AIzaSyCNCsK_dknS6n1PokMBNC_BLumsza_LwxA";
    NSString *baseURL = @"https://www.googleapis.com/youtube/v3/search?part=snippet&q=";
    
    NSString *searchTerm = [NSString stringWithFormat:@"%@", self.labelFromCell]; //self.mySubmissionsAsPropertyList[self.randomIndex][SUBMISSION_TYPE]];
    NSLog(@"MoreViewController: searchTerm is %@", searchTerm);
    
    //NSString *searchTermSubmitted = [NSString  stringWithFormat:@"%@ Jiu Jitsu Escape", self.mostSubmittedByLabel.text];
    
    
    //NSString *escapedSearchResultSubmitted = [searchTermSubmitted stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    NSString *escapedSearchResult = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    
    
    //NSString *searchURLSubmitted = [NSString stringWithFormat:@"%@%@&maxResults=5&key=%@",baseURL, escapedSearchResultSubmitted, youtubeAPIKey];
    NSString *searchURL = [NSString stringWithFormat:@"%@%@&maxResults=5&key=%@",baseURL, escapedSearchResult, youtubeAPIKey];
    
    
    //NSURL *urlSubmitted = [NSURL URLWithString:searchURLSubmitted];
    NSURL *url = [NSURL URLWithString:searchURL];
    
    //NSURLRequest *requestSubmitted = [NSURLRequest requestWithURL:urlSubmitted];
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    
    //NSOperationQueue *operationQueue = [[NSOperationQueue alloc] init];
    //[operationQueue setMaxConcurrentOperationCount:2];
    
    //AFHTTPRequestOperation *operationSubmitted = [[AFHTTPRequestOperation alloc] initWithRequest:requestSubmitted];
    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    //operationSubmitted.responseSerializer = [AFJSONResponseSerializer serializer];
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    //[operationSubmitted setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        //NSDictionary *youTubeJSONResponseSubmitted = (NSDictionary*)responseObject;
        
        
        //need to parse JSON response into array
        //for(NSDictionary *item in youTubeJSONResponseSubmitted[@"items"]){
            
            //[self.youTubeJSONResponseAsArraySubmitted addObject:item];
            
        //}
        
        //NSLog(@"MoreViewController: The newArraySubmitted response is %@", self.youTubeJSONResponseAsArraySubmitted);
        
        //[self.collectionView reloadData];
        //[self loadWebViewTest];
        
        
    //} failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        //UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"Error Retrieving Videos"
                                                            //message:[error localizedDescription]
                                                           //delegate:nil
                                                  //cancelButtonTitle:@"Ok"
                                                  //otherButtonTitles:nil];
        //[alertView show];
        
    //}];
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"MoreViewController: responseObject for submission request %@", responseObject);
        
        NSDictionary *youTubeJSONResponse = (NSDictionary *)responseObject;
        
        NSLog(@"MoreViewCOntroller: youtubeJSONResponse[items][0] is %@", youTubeJSONResponse[@"items"][0]);
        
        for(NSDictionary *item in youTubeJSONResponse[@"items"]){
            
            NSLog(@"item %@", item);
            
            [self.youTubeJSONResponseAsArray addObject:item];
            
        }
        
        NSLog(@"MoreViewController: The newArraySubmission response is %@", self.youTubeJSONResponseAsArray);
        
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
    
    //if (section == 0) {
        
        NSLog(@"MoreViewController Submission YouTube Count %lu", (unsigned long)[self.youTubeJSONResponseAsArray count]);
    return [self.youTubeJSONResponseAsArray count];
        
    //}else if (section == 1){
        //NSLog(@"MoreViewController Submitted YouTube Count %lu", (unsigned long)[self.youTubeJSONResponseAsArraySubmitted count]);
        //return [self.youTubeJSONResponseAsArraySubmitted count];
    //}
    
    //return 2;
}

-(NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    
    return 1;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    static NSString *CellIdentifier = @"Cell";
    
    MOCustomCollectionViewCell  *cell = [collectionView dequeueReusableCellWithReuseIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.backgroundColor = [UIColor blackColor];
    
    dispatch_queue_t youtubeQueue = dispatch_queue_create("YouTube Queue", NULL);
    
    //if (indexPath.section == 0) {
        
        
        if(self.youTubeJSONResponseAsArray){
            
            
            dispatch_async(youtubeQueue, ^{
                
                NSString *youTubeVideoLink = [NSString stringWithFormat:@"<iframe width= %f height= %f src=http://www.youtube.com/embed/%@ frameborder=0 allowfullscreen></iframe>", cell.youtubeVideoWebView.frame.size.width, cell.youtubeVideoWebView.frame.size.height, self.youTubeJSONResponseAsArray[indexPath.row][@"id"][@"videoId"]];
                
                dispatch_async(dispatch_get_main_queue(), ^{
                    
                    cell.videoTitleLabel.text =[NSString stringWithFormat:@"%@", [self.youTubeJSONResponseAsArray[indexPath.row] valueForKeyPath:@"snippet.title"]];
                    //[cell.youtubeVideoWebView  ]
                    [cell.youtubeVideoWebView loadHTMLString:youTubeVideoLink baseURL:nil];
                    [[cell.youtubeVideoWebView scrollView] setScrollEnabled:NO];
                    
                });
                
            });
        }
    //}

    
    
    //if (indexPath.section == 1) {
        
        
        //if(self.youTubeJSONResponseAsArraySubmitted){
            
            
            //dispatch_async(youtubeQueue, ^{
                
                //NSString *youTubeVideoLink = [NSString stringWithFormat:@"<iframe width= %f height= %f src=http://www.youtube.com/embed/%@ frameborder=0 allowfullscreen></iframe>", cell.youtubeVideoWebView.frame.size.width, cell.youtubeVideoWebView.frame.size.height, self.youTubeJSONResponseAsArraySubmitted[indexPath.row][@"id"][@"videoId"]];
                
                //dispatch_async(dispatch_get_main_queue(), ^{
                    
                    //cell.videoTitleLabel.text =[NSString stringWithFormat:@"%@", [self.youTubeJSONResponseAsArraySubmitted[indexPath.row] valueForKeyPath:@"snippet.title"]];
                    //[cell.youtubeVideoWebView  ]
                    //[cell.youtubeVideoWebView loadHTMLString:youTubeVideoLink baseURL:nil];
                    //[[cell.youtubeVideoWebView scrollView] setScrollEnabled:NO];
                    
                //});
                
            //});
        //}
    //}
    
    return cell;
    
    
}

-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    UICollectionReusableView *reusableView = nil;
    
    if (kind == UICollectionElementKindSectionHeader) {
        MOUICollectionResuableViewHeader *header = [[MOUICollectionResuableViewHeader alloc] init];
        
        header = [collectionView dequeueReusableSupplementaryViewOfKind:UICollectionElementKindSectionHeader withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        
        //if (indexPath.section == 0) {
        NSLog(@"MoreViewController: labelFromCell %@", self.labelFromCell);
        //NSString *title = [NSString stringWithFormat:@"%@", self.labelFromCell]; //self.mySubmissionsAsPropertyList[self.randomIndex][SUBMISSION_TYPE]];
        header.collectionViewHeader.text = self.labelFromCell;
        //}
        
        //if (indexPath.section == 1) {
            //NSString *title = [NSString stringWithFormat:@"%@ Escapes", self.mostSubmittedByLabel.text];
            //header.collectionViewHeader.text = title;
        //}
        
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

#pragma mark Test
//-(void)youTubeStarted:(NSNotification *)notification{
    // Entered Fullscreen code goes here..
    //MOAppDelegate *appDelegate = (MOAppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.fullScreenVideoIsPlaying = YES;
//}

//-(void)youTubeFinished:(NSNotification *)notification{
    // Left fullscreen code goes here...
    //MOAppDelegate *appDelegate = (MOAppDelegate *)[[UIApplication sharedApplication] delegate];
    //appDelegate.fullScreenVideoIsPlaying = NO;
    
    //CODE BELOW FORCES APP BACK TO PORTRAIT ORIENTATION ONCE YOU LEAVE VIDEO.
    //[[UIApplication sharedApplication] setStatusBarOrientation:UIInterfaceOrientationPortrait animated:NO];
    //present/dismiss viewcontroller in order to activate rotating.
    //MOMoreViewController *mVC = [[MOMoreViewController alloc] init];
    //[self presentViewController:mVC animated:NO completion:nil];
    //[self dismissViewControllerAnimated:NO completion:nil];
//}




@end
