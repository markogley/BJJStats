//
//  MOMoreCollectionViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-09-23.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOMoreCollectionViewController.h"
#import "MOSubmissionsPersistenceManager.h"
#import "MOSubmissionObject.h"
#import "MOMatchObject.h"
#import "UIImageView+AFNetworking.h"
#import "AFNetworking.h"
#import "MOCustomCollectionViewCell.h"
#import "CSStickyHeaderFlowLayout.h"
#import "CSStickyHeaderFlowLayoutAttributes.h"


@interface MOMoreCollectionViewController ()

@property (strong, nonatomic) NSMutableArray *youTubeJSONResponseAsArray;
//@property (strong, nonatomic) UINib *headerNib;

@end


@implementation MOMoreCollectionViewController


-(NSMutableArray *)youTubeJSONResponseAsArray{
    
    if (!_youTubeJSONResponseAsArray) {
        _youTubeJSONResponseAsArray = [[NSMutableArray alloc] init];
    }
    
    return _youTubeJSONResponseAsArray ;
}



- (void)viewDidLoad {
    [super viewDidLoad];
    
    // Uncomment the following line to preserve selection between presentations
    // self.clearsSelectionOnViewWillAppear = NO;
    self.navigationTitle.title = self.labelFromCell;
    
    // Register cell classes
    CSStickyHeaderFlowLayout *layout = (id)self.collectionViewLayout;
    if ([layout isKindOfClass:[CSStickyHeaderFlowLayout class]]) {
        layout.parallaxHeaderReferenceSize = CGSizeMake(320, 200);
    }
    
    UINib *headerNib = [UINib nibWithNibName:@"CollectionViewHeader" bundle:nil];
    


    [self.collectionView registerNib:headerNib forSupplementaryViewOfKind:CSStickyHeaderParallaxHeader withReuseIdentifier:@"Header"];
    
    
    [[AFNetworkReachabilityManager sharedManager] startMonitoring];
    [[AFNetworkReachabilityManager sharedManager] setReachabilityStatusChangeBlock:^(AFNetworkReachabilityStatus status) {
        //NSLog(@"Reachability: %@", AFStringFromNetworkReachabilityStatus(status));
        if (status == AFNetworkReachabilityStatusReachableViaWiFi || status == AFNetworkReachabilityStatusReachableViaWWAN){
            
            [self retrieveYouTubeVideoLinks];
            
        }else if (status == AFNetworkReachabilityStatusNotReachable){
            
            UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"No Internet Connection" message:@"This application needs to be on the internet to be used to its fullest." delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alertView show];
            
        }
        
        
    }];
    
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeStarted:) name:@"UIMoviePlayerControllerDidEnterFullscreenNotification" object:nil];
    //[[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(youTubeFinished:) name:@"UIMoviePlayerControllerDidExitFullscreenNotification" object:nil];
    
    self.navigationController.title = self.labelFromCell;
    
    self.collectionView.dataSource = self;
    self.collectionView.delegate = self;

    //[self retrieveYouTubeVideoLinks];
    NSLog(@"MoreCollectionViewController: JSONResponse %@", self.youTubeJSONResponseAsArray);
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {

    
    return [self.youTubeJSONResponseAsArray count];
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    //NSLog(@"MoreCollectionView: JSONResponse is %@", self.youTubeJSONResponseAsArray);
    return  1;//[self.youTubeJSONResponseAsArray count];
    
    
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    //static NSString *reuseIdentifier = @"Cell";
    
    
    
    NSDictionary *item = self.youTubeJSONResponseAsArray[indexPath.section];
    
    MOCustomCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    
    //cell.backgroundColor = [UIColor blackColor];
    
        
    NSString *youTubeVideoLink = [NSString stringWithFormat:@"<iframe width= %f height= %f src=http://www.youtube.com/embed/%@ frameborder=0 allowfullscreen></iframe>", cell.youtubeVideoWebView.frame.size.width, cell.youtubeVideoWebView.frame.size.height, item[@"id"][@"videoId"]];
        
        
    [cell.youtubeVideoWebView loadHTMLString:youTubeVideoLink baseURL:nil];
        
    
    
    //MOCustomCollectionViewCell *header = [collectionView dequeueReusableCellWithReuseIdentifier:@"Header" forIndexPath:indexPath];
    
    //for (NSDictionary *item in self.youTubeJSONResponseAsArray) {
        
        //NSString *title = item[@"title"];
        
        //header.videoTitleLabel.text = title;
        
        
        //return header;
        //}

    return cell;


}

    //dispatch_queue_t youtubeQueue = dispatch_queue_create("YouTube Queue", NULL);
    
    
    
    //if(self.youTubeJSONResponseAsArray){
        
        
        //dispatch_async(youtubeQueue, ^{
            
            //NSString *youTubeVideoLink = [NSString stringWithFormat:@"<iframe width= %f height= %f src=http://www.youtube.com/embed/%@ frameborder=0 allowfullscreen></iframe>", cell.youtubeVideoWebView.frame.size.width, cell.youtubeVideoWebView.frame.size.height, self.youTubeJSONResponseAsArray[indexPath.row][@"id"][@"videoId"]];
            
            //dispatch_async(dispatch_get_main_queue(), ^{
                
                //cell.videoTitleLabel.text =[NSString stringWithFormat:@"%@", [self.youTubeJSONResponseAsArray[indexPath.row] valueForKeyPath:@"snippet.title"]];
                //[cell.youtubeVideoWebView  ]
                //[cell.youtubeVideoWebView loadHTMLString:youTubeVideoLink baseURL:nil];
                //[[cell.youtubeVideoWebView scrollView] setScrollEnabled:NO];
                


-(UICollectionReusableView *)collectionView:(UICollectionView *)collectionView viewForSupplementaryElementOfKind:(NSString *)kind atIndexPath:(NSIndexPath *)indexPath{
    
    //UICollectionReusableView *reusableView = nil;
    
    if ([kind isEqualToString:CSStickyHeaderParallaxHeader]) {
    
        UICollectionReusableView *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"Header" forIndexPath:indexPath];
        
        
        return cell;
    
    }else if ([kind isEqualToString:UICollectionElementKindSectionHeader]) {
        
        MOCustomCollectionViewCell *cell = [collectionView dequeueReusableSupplementaryViewOfKind:kind withReuseIdentifier:@"sectionHeader" forIndexPath:indexPath];
        NSDictionary *item = self.youTubeJSONResponseAsArray[indexPath.section];
        
        NSString *title = [[NSString alloc] init];
        title = item[@"snippet"][@"title"];
        NSLog(@"CollectionView: Title per cell: %@", title);
        
        cell.videoTitleLabel.text = title;
        return cell;
    }
    
    return nil;
    
        
}



#pragma mark <UICollectionViewDelegate>

/*
// Uncomment this method to specify if the specified item should be highlighted during tracking
- (BOOL)collectionView:(UICollectionView *)collectionView shouldHighlightItemAtIndexPath:(NSIndexPath *)indexPath {
	return YES;
}
*/

/*
// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}
*/

/*
// Uncomment these methods to specify if an action menu should be displayed for the specified item, and react to actions performed on the item
- (BOOL)collectionView:(UICollectionView *)collectionView shouldShowMenuForItemAtIndexPath:(NSIndexPath *)indexPath {
	return NO;
}

- (BOOL)collectionView:(UICollectionView *)collectionView canPerformAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	return NO;
}

- (void)collectionView:(UICollectionView *)collectionView performAction:(SEL)action forItemAtIndexPath:(NSIndexPath *)indexPath withSender:(id)sender {
	
}
*/

-(void)retrieveYouTubeVideoLinks{
    
    //self.randomIndex = (arc4random() % self.mySubmissionsAsPropertyList.count);
    
    NSString *youtubeAPIKey = @"AIzaSyCNCsK_dknS6n1PokMBNC_BLumsza_LwxA";
    NSString *baseURL = @"https://www.googleapis.com/youtube/v3/search?part=snippet&q=";
    NSString *searchTerm;
    
    if (self.segmentIndexCollectionView == 0) {
        searchTerm = [NSString stringWithFormat:@"%@", self.labelFromCell];
    }else if (self.segmentIndexCollectionView == 1){
        searchTerm = [NSString stringWithFormat:@"%@ Escapes", self.labelFromCell];
    }
    
    
    NSLog(@"MoreViewController: searchTerm is %@", searchTerm);
    
    NSString *escapedSearchResult = [searchTerm stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding];
    
    
    NSString *searchURL = [NSString stringWithFormat:@"%@%@&maxResults=10&key=%@",baseURL, escapedSearchResult, youtubeAPIKey];
    
    NSURL *url = [NSURL URLWithString:searchURL];
    
    NSURLRequest *request = [NSURLRequest requestWithURL:url];
    

    AFHTTPRequestOperation *operation = [[AFHTTPRequestOperation alloc] initWithRequest:request];
    
    
    operation.responseSerializer = [AFJSONResponseSerializer serializer];
    
    
    
    [operation setCompletionBlockWithSuccess:^(AFHTTPRequestOperation *operation, id responseObject) {
        
        
        NSLog(@"MoreViewController: responseObject for submission request %@", responseObject);
        
        NSDictionary *youTubeJSONResponse = (NSDictionary *)responseObject;
        
        NSLog(@"MoreViewCOntroller: youtubeJSONResponse[items][0] is %@", youTubeJSONResponse[@"items"][0]);
        
        for(NSDictionary *item in youTubeJSONResponse[@"items"]){
            
            NSLog(@"item %@", item);
            
            [self.youTubeJSONResponseAsArray addObject:item];
            
        }
        
        NSLog(@"MoreViewController: The newArraySubmission response is %@ and the count is %lu", self.youTubeJSONResponseAsArray, (unsigned long)self.youTubeJSONResponseAsArray.count);
        
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


@end
