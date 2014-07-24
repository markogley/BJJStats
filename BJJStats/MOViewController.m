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
    
    [self.addedSubmissions addObject:newSubmissionObject];
    //creates new converter from MOObjectConverter class
    MOObjectConverter *converter = [[MOObjectConverter alloc] init];
    
    
    //open preveous submissions saved in NSUserDefaults
    NSMutableArray *submissionObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
    //if submissionsObjectAsPropertyList does not exist allocate and initialize it
    if (!submissionObjectsAsPropertyLists) {
        submissionObjectsAsPropertyLists = [[NSMutableArray alloc] init];
        
    }
    
    //converts newSubmissionObject to NSDictionary using converter
    NSDictionary *newSub = [converter submissionObjectAsPropertyList:newSubmissionObject];
    
    BOOL alreadyInArray = NO;
    int index = 0;
    
    for (NSDictionary *entry in submissionObjectsAsPropertyLists) {
        //need to compare submissionType, submissionPosition and submissionTopOrBottom but not counter
        if ([[entry valueForKey:SUBMISSION_POSITION] isEqualToString:[newSub valueForKey:SUBMISSION_POSITION]] && [[entry valueForKey:SUBMISSION_TYPE] isEqualToString: [newSub valueForKey:SUBMISSION_TYPE]] && [[entry valueForKey:SUBMISSION_TOP_OR_BOTTOM] isEqualToString:[newSub valueForKey:SUBMISSION_TOP_OR_BOTTOM]] ) {
            //if ([entry isEqualToDictionary:newSub]) {
            alreadyInArray = YES;
            NSLog(@"This submission is already in the array");
        }else{
            
            index++;
        }
    }
    
    if (alreadyInArray == NO) {
        [submissionObjectsAsPropertyLists addObject:[converter submissionObjectAsPropertyList:newSubmissionObject]];
        NSLog(@"Submission added to the array");
    }
    
    if (alreadyInArray == YES) {
        MOSubmissionObject *updatedEntry = [converter submissionObjectForDictionary:submissionObjectsAsPropertyLists[index]];
        [updatedEntry incrementCounter];
        NSDictionary *updatedEntryComplete = [converter submissionObjectAsPropertyList:updatedEntry];
        submissionObjectsAsPropertyLists[index] = updatedEntryComplete;
    }
    
    [[NSUserDefaults standardUserDefaults] setObject:submissionObjectsAsPropertyLists forKey:ADDED_SUBMISSION_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
     NSLog(@"%@ %lu", submissionObjectsAsPropertyLists, (unsigned long)[submissionObjectsAsPropertyLists count]);
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}

#pragma mark MOSubmittedViewControllerDelegate

-(void)addSubmitted:(MOSubmissionObject *)newSubmittedObject{
    
    
}

-(void)didCancelSubmitted{
    
    NSLog(@"Submitted Cancel Button Success");
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark HelperMethods

//create method to to persist submitted/submissions, check for duplicates for both 



@end
