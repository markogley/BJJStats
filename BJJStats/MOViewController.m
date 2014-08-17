//
//  MOViewController.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-19.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOViewController.h"

@interface MOViewController ()

@property (strong,nonatomic) NSMutableArray *addedSubmissions;
@property (strong, nonatomic) NSMutableArray *addedSubmitted;
@property (strong, nonatomic) IBOutlet UILabel *quotesLabel;
@property (strong, nonatomic) IBOutlet UILabel *authorLabel;
@property (strong, nonatomic) IBOutlet UIView *quotesView;
@property (strong, nonatomic) IBOutlet UIView *buttonView;

@end

@implementation MOViewController



-(NSMutableArray *)addedSubmissions{
    if(!_addedSubmissions){
        _addedSubmissions = [[NSMutableArray alloc] init];
    }
    
    return _addedSubmissions;
}

-(NSMutableArray *)addedSubmitted{
    if(!_addedSubmitted){
        _addedSubmitted = [[NSMutableArray alloc] init];
    }
    
    return _addedSubmitted;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    [self.navigationController.navigationBar setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor colorWithRed:0.75 green:0.56 blue:0.83 alpha:1.0], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue-CondensedBold" size:18.0]}];
    self.view.backgroundColor = [UIColor colorWithRed:0.96 green:0.96 blue:0.96 alpha:1.0];
    self.navigationController.navigationBar.backgroundColor = [UIColor colorWithRed:0.29 green:0.47 blue:0.75 alpha:1.0];
    self.navigationController.navigationBar.tintColor = [UIColor colorWithRed:0.75 green:0.56 blue:0.83 alpha:1.0];
    
    [self setupView];
    [self addQuotesToHomePage];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)setupView{
    self.view.backgroundColor = [UIColor colorWithRed:242/255.0 green:242/255.0 blue:242/255.0 alpha:1.0];
    
    [self addShadowForView:self.quotesView];
    [self addShadowForView:self.buttonView];
    //do want to clip any subviews of the imageView
}

-(void)addShadowForView:(UIView *)view{
    
    //any subviews will be clipped
    view.layer.masksToBounds = NO;
    //rounds corners of the view
    view.layer.cornerRadius = 4;
    //size of shadow raidius
    view.layer.shadowRadius = 1;
    //tweak to allow iPhone 4 to load shadows without hindering performace of XYPieChart animations
    view.layer.shadowPath = [[UIBezierPath bezierPathWithRect:view.bounds] CGPath];
    //how the shadow is oriented to the view
    view.layer.shadowOffset = CGSizeMake(0, 1);
    //sets alpha for shadow
    view.layer.shadowOpacity = 0.25;
    
}


-(void)addQuotesToHomePage{
    
    NSArray *quotesArray = @[@{@"Quote" : @"If you think, you're late. If you're late, you muscle. If you muscle, you get tired. If you get tired, you die.", @"Author" : @"Saulo Ribeiro"}, @{@"Quote": @"Jiu-Jitsu skills don't pay the bills.", @"Author" : @"Keenan Cornielius"}, @{@"Quote" : @"My opponent is my teacher. My ego is my enemy", @"Author" : @"Renzo Gracie"}, @{@"Quote": @"Men are made in different shapes and sizes with different athletic ability, Jiu Jitsu makes us all equal.", @"Author" : @"Helio Gracie"}, @{@"Quote": @"There is no losing in Jiu-Jitsu. You either win or you learn.", @"Author" : @"Carlos Gracie Jr."}, @{@"Quote" : @"Keep it playful", @"Author" :@"Ryron Gracie"}];
    
    
    NSDictionary *myQuote = [quotesArray objectAtIndex:arc4random()%[quotesArray count]];
    
    self.quotesLabel.text = myQuote[@"Quote"];
    self.authorLabel.text = myQuote[@"Author"];
    
    
}



-(void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender{
    
    if ([segue.destinationViewController isKindOfClass:[MOSubmissionsViewController class]]) {
        MOSubmissionsViewController *addSubmissionVC = segue.destinationViewController;
        addSubmissionVC.delegate = self;
    }
    
    if ([segue.destinationViewController isKindOfClass:[MOSubmittedViewController class]]) {
        MOSubmittedViewController *addSubmittedVC = segue.destinationViewController;
        addSubmittedVC.delegate = self;
    }
    
}

#pragma mark MOAddSubmissionsViewControllerDelegate

-(void)didCancelSubmission{
    NSLog(@"didCancel");
    [self dismissViewControllerAnimated:YES completion:nil];
}

-(void)addSubmission:(MOSubmissionObject *)newSubmissionObject{
    
   
    MOSubmissionsPersistenceManager *manger = [[MOSubmissionsPersistenceManager alloc] init];
    
    [manger addSubmissionObject:newSubmissionObject];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark MOSubmittedViewControllerDelegate

-(void)addSubmitted:(MOSubmissionObject *)newSubmittedObject{
    
    MOSubmissionsPersistenceManager *manger = [[MOSubmissionsPersistenceManager alloc] init];
    [manger addSubmittedObject:newSubmittedObject];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

-(void)didCancelSubmitted{
    
    NSLog(@"Submitted Cancel Button Success");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark HelperMethods




@end
