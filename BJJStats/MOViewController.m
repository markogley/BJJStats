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

@end

@implementation MOViewController



-(NSMutableArray *)addedSubmissions{
    if(!_addedSubmissions){
        _addedSubmissions = [[NSMutableArray alloc] init];
    }
    
    return _addedSubmissions;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
	// Do any additional setup after loading the view, typically from a nib.
    
    
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
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

//create method to to persist submitted/submissions, check for duplicates for both 



@end
