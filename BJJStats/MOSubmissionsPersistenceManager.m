//
//  MOSubmissionsPersistanceManager.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-26.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOSubmissionsPersistenceManager.h"

@implementation MOSubmissionsPersistenceManager


-(void)addSubmissionObject:(MOSubmissionObject *)submissionObject{

    
    //open preveous submissions saved in NSUserDefaults
    NSMutableArray *submissionObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults]arrayForKey:ADDED_SUBMISSION_OBJECTS_KEY] mutableCopy];
    //if submissionsObjectAsPropertyList does not exist allocate and initialize it
    if (!submissionObjectsAsPropertyLists) {
        submissionObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    }
    
    //comapres the new object to the already saved data and either increments or adds the newObject to the array to be saved to NSUserDefaults.
    submissionObjectsAsPropertyLists = [self compareNewSubmissionObjectToSavedData:submissionObjectsAsPropertyLists newSubmissionObject:submissionObject];
    
    NSLog(@"submission Objects %@", submissionObjectsAsPropertyLists);
    
    [[NSUserDefaults standardUserDefaults] setObject:submissionObjectsAsPropertyLists forKey:ADDED_SUBMISSION_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];

}

-(void)addSubmittedObject:(MOSubmissionObject *)submissionObject{
    
    
    //open preveous submissions saved in NSUserDefaults
    NSMutableArray *submittedObjectsAsPropertyLists = [[[NSUserDefaults standardUserDefaults] arrayForKey:ADDED_SUBMITTED_OBJECTS_KEY] mutableCopy];
    //if submissionsObjectAsPropertyList does not exist allocate and initialize it
    if (!submittedObjectsAsPropertyLists) {
        submittedObjectsAsPropertyLists = [[NSMutableArray alloc] init];
    }
    

    //comapres the new object to the already saved data and either increments or adds the newObject to the array to be saved to NSUserDefaults.
    submittedObjectsAsPropertyLists =  [self compareNewSubmissionObjectToSavedData:submittedObjectsAsPropertyLists newSubmissionObject:submissionObject];
    
    NSLog(@"submitted Objects %@", submittedObjectsAsPropertyLists);
    
    [[NSUserDefaults standardUserDefaults] setObject:submittedObjectsAsPropertyLists forKey:ADDED_SUBMITTED_OBJECTS_KEY];
    [[NSUserDefaults standardUserDefaults] synchronize];
    
}

-(NSMutableArray *)compareNewSubmissionObjectToSavedData:(NSMutableArray *)objectsAsPropertyList newSubmissionObject:(MOSubmissionObject *)newObject{
    
    
    //creates new converter from MOObjectConverter class
    MOObjectConverter *converter = [[MOObjectConverter alloc] init];
    NSDictionary *newSub = [converter submissionObjectAsPropertyList:newObject];
    
    //NSMutableDictionary *objectsAsPropertyListDictionary = [[NSMutableDictionary alloc] init];
    
    //for (MOSubmissionObject *object in objectsAsPropertyList){
        //[objectsAsPropertyListDictionary addEntriesFromDictionary:[converter submissionObjectAsPropertyList:object]];
    //}
    
    BOOL alreadyInArray = NO;
    int index = 0;
    
    for (NSDictionary *entry in objectsAsPropertyList) {
        //need to compare submissionType, submissionPosition and submissionTopOrBottom but not counter
        if ([[entry valueForKey:SUBMISSION_POSITION] isEqualToString:[newSub valueForKey:SUBMISSION_POSITION]] && [[entry valueForKey:SUBMISSION_TYPE] isEqualToString: [newSub valueForKey:SUBMISSION_TYPE]] && [[entry valueForKey:SUBMISSION_TOP_OR_BOTTOM] isEqualToString:[newSub valueForKey:SUBMISSION_TOP_OR_BOTTOM]] ) {
            alreadyInArray = YES;
            NSLog(@"This submission is already in the array");
        }else{
            
            index++;
            NSLog(@"index is %d", index);
        }
    }
    
    if (alreadyInArray == NO) {
        [objectsAsPropertyList addObject:[converter submissionObjectAsPropertyList:newObject]];
        NSLog(@"Submission added to the array");
    }
    //object is being initialized with counter of 1
    if (alreadyInArray == YES) {
        MOSubmissionObject *updatedEntry = [converter submissionObjectForDictionary:objectsAsPropertyList[index]];
        [updatedEntry incrementCounter];
        NSLog(@"object counter %d", updatedEntry.counter);
        
        NSDate *date = [NSDate date];
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSString *today = [dateFormatter stringFromDate:date];
        for (NSString *dates in updatedEntry.datesArray){
            if ([dates isEqualToString:today]) {
                NSDictionary *updatedEntryComplete = [converter submissionObjectAsPropertyList:updatedEntry];
                //objectsAsPropertyList[index] = updatedEntryComplete;
                [objectsAsPropertyList replaceObjectAtIndex:index withObject:updatedEntryComplete];
        }else{
        
        NSMutableArray *newDatesArray = updatedEntry.datesArray;
        for (NSString *i in newObject.datesArray) {
            [newDatesArray addObject:i];
        }
        NSLog(@"newDatesArray%@", newDatesArray);
        updatedEntry.datesArray = [newDatesArray mutableCopy];
        NSLog(@"object dates are %@", updatedEntry.datesArray);
        NSDictionary *updatedEntryComplete = [converter submissionObjectAsPropertyList:updatedEntry];
        //objectsAsPropertyList[index] = updatedEntryComplete;
        [objectsAsPropertyList replaceObjectAtIndex:index withObject:updatedEntryComplete];
            }
        }
    }
    return objectsAsPropertyList;
}


@end



