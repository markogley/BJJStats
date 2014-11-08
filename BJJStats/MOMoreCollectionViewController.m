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
#import "MOCollectionViewDetailViewController.h"
#import "UIViewController+MJPopupViewController.h"
#import "FPPopoverController.h"



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
    
    self.collectionView.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//-(void)setupView{
    //self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    //[self addShadowForView:];
    //[self addShadowForView:self.buttonView];
    //do want to clip any subviews of the imageView
//}

//-(void)addShadowForView:(UIView *)view{
    
    //any subviews will be clipped
    //view.layer.masksToBounds = NO;
    //rounds corners of the view
    //view.layer.cornerRadius = 8;
    //size of shadow raidius
    //view.layer.shadowRadius = 1;
    //tweak to allow iPhone 4 to load shadows without hindering performace of XYPieChart animations
    //view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
    //how the shadow is oriented to the view
    //view.layer.shadowOffset = CGSizeMake(0, 1);
    //sets alpha for shadow
    //view.layer.shadowOpacity = 0.25;
    
//}


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
    
        
    //NSString *youTubeVideoLink = [NSString stringWithFormat:@"<iframe width= %f height= %f src=http://www.youtube.com/embed/%@ frameborder=0 allowfullscreen></iframe>", cell.youtubeVideoWebView.frame.size.width, cell.youtubeVideoWebView.frame.size.height, item[@"id"][@"videoId"]];
    
    NSURL *url = [NSURL URLWithString:item[@"snippet"][@"thumbnails"][@"high"][@"url"]];
    
    NSData *imageData = [NSData dataWithContentsOfURL:url];
    
    cell.youtubeImageView.image = [UIImage imageWithData:imageData];
    
        
        
    //[cell.youtubeVideoWebView loadHTMLString:youTubeVideoLink baseURL:nil];
        
    cell.layer.masksToBounds = NO;
    cell.layer.cornerRadius = 8;
    cell.layer.shadowRadius = 1;
    cell.layer.shadowOffset = CGSizeMake(0, 1);
    cell.layer.shadowOpacity = 0.25;
    
    //MOCustomCollectionViewCell *header = [collectionView dequeueReusableCellWithReuseIdentifier:@"Header" forIndexPath:indexPath];
    
    //for (NSDictionary *item in self.youTubeJSONResponseAsArray) {
        
        //NSString *title = item[@"title"];
        
        //header.videoTitleLabel.text = title;
        
        
        //return header;
        //}
    //[self webViewDidFinishLoad:cell.youtubeVideoWebView];
    

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
        
        cell.layer.masksToBounds = NO;
        cell.layer.cornerRadius = 8;
        cell.layer.shadowRadius = 1;
        cell.layer.shadowOffset = CGSizeMake(0, 1);
        cell.layer.shadowOpacity = 0.25;
        
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


//Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSDictionary *item = self.youTubeJSONResponseAsArray[indexPath.section];
    
    //create access to your storyboard
    UIStoryboard *mainStoryBoard = [UIStoryboard storyboardWithName:@"Main" bundle:nil];
    
    //instantiate you view from the storyboard access
    MOCollectionViewDetailViewController *details =[mainStoryBoard instantiateViewControllerWithIdentifier:@"collectionViewDetailView"];
    
    details.title = item[@"snippet"][@"title"];
    
    
    //create toy FPPopOverClass view
    FPPopoverController *test = [[FPPopoverController alloc] initWithViewController:details];
    
    test.contentSize = CGSizeMake(304, 200
                                  );
    test.tint = FPPopoverLightGrayTint;
    test.border = NO;
    test.alpha = 0.95;
    
    
    NSLog(@"POPOver: %@", item[@"snippet"][@"title"]);
    
    //sets the animation to come from the cell
    UIView *cellView = [collectionView cellForItemAtIndexPath:indexPath];
    
    
    //presents the FPPopOverView
    [test presentPopoverFromView:cellView];
    
}

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
