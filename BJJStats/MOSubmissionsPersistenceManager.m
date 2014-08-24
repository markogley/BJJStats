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
    NSLog(@"The new submissionObject as dict is %@", newSub);
    
    
    BOOL alreadyInArray = NO;
    int index = 0;
    //compares the oldSubmission object already saved to the new one submitted to the method by three criteria: submission position/ToporBottom/Type
    for (NSDictionary *entry in objectsAsPropertyList) {
        //need to compare submissionType, submissionPosition and submissionTopOrBottom but not counter
        if ([[entry valueForKey:SUBMISSION_POSITION] isEqualToString:[newSub valueForKey:SUBMISSION_POSITION]] && [[entry valueForKey:SUBMISSION_TYPE] isEqualToString: [newSub valueForKey:SUBMISSION_TYPE]] && [[entry valueForKey:SUBMISSION_TOP_OR_BOTTOM] isEqualToString:[newSub valueForKey:SUBMISSION_TOP_OR_BOTTOM]] ) {
            alreadyInArray = YES;
            NSLog(@"This submission is already in the array");
            break;
        }else{
            
            index++;
            NSLog(@"index is %d", index);
        }
    }
    
    if (alreadyInArray == NO) {
        [objectsAsPropertyList insertObject: [converter submissionObjectAsPropertyList:newObject] atIndex:index];
        NSLog(@"Submission added to the array");
    }
    //if the object is already in the array its counter is incremented by 1 and the date is added. The dates can be checked later to see how many times they appear and can be subtracted from the total counter to get a picture of when and how many times on that date the submission happened. This is a work around till I figure out a better data model or a better method to compare.
    if (alreadyInArray == YES) {
        MOSubmissionObject *entryToUpdate = [converter submissionObjectForDictionary:objectsAsPropertyList[index]];
        //increments the counter
        [entryToUpdate incrementCounter];
        
        //creates a new array to dump the old dates array in to.
        NSMutableArray *newDatesArray = [entryToUpdate.datesArray mutableCopy];
        //copies the date from the new submission submitted to the compare method
        [newDatesArray addObject:newSub[SUBMISSION_COUNTER_AND_DATE][SUBMISSION_DATE][0]];
        //sets the newDates array to the old one on the submissionObject that needed to be updated using mutabkle copy
        entryToUpdate.datesArray = [newDatesArray mutableCopy];
        //converts the updated submissionObject back to a dictionary
        NSDictionary *updatedEntryComplete = [converter submissionObjectAsPropertyList:entryToUpdate];
        //replaces the new dictionary over the old one in the same index spot
        [objectsAsPropertyList replaceObjectAtIndex:index withObject:updatedEntryComplete];
    }
    
    return objectsAsPropertyList;
}

//used to compare an edited object from the deleted view controller series to its original form
-(void)compareEditedSubmissionObjectToSavedData:(NSMutableArray *)objectsAsPropertyList newSubmissionObject:(MOSubmissionObject *)newObject sectionHeader:(NSString *)sectionHeader{
    
    //creates new converter from MOObjectConverter class
    MOObjectConverter *converter = [[MOObjectConverter alloc] init];
    NSDictionary *newSub = [converter submissionObjectAsPropertyList:newObject];
    NSLog(@"Persistance Manager: The new submissionObject as dict is %@", newSub);
    
    
    BOOL alreadyInArray = NO;
    int index = 0;
    //compares the oldSubmission object already saved to the new one submitted to the method by three criteria: submission position/ToporBottom/Type
    for (NSDictionary *entry in objectsAsPropertyList) {
        //need to compare submissionType, submissionPosition and submissionTopOrBottom but not counter
        if ([[entry valueForKey:SUBMISSION_POSITION] isEqualToString:[newSub valueForKey:SUBMISSION_POSITION]] && [[entry valueForKey:SUBMISSION_TYPE] isEqualToString: [newSub valueForKey:SUBMISSION_TYPE]] && [[entry valueForKey:SUBMISSION_TOP_OR_BOTTOM] isEqualToString:[newSub valueForKey:SUBMISSION_TOP_OR_BOTTOM]] ) {
            alreadyInArray = YES;
            NSLog(@"Persistance Manager: This submission is already in the array");
            break;
        }else{
            
            index++;
            NSLog(@"index is %d", index);
        }
    }
    
    //if (alreadyInArray == NO) {
        //[objectsAsPropertyList addObject:[converter submissionObjectAsPropertyList:newObject]];
        //NSLog(@"Persistance Manager: Submission added to the array");
    //}
    //if the object is already in the array its counter is incremented by 1 and the date is added. The dates can be checked later to see how many times they appear and can be subtracted from the total counter to get a picture of when and how many times on that date the submission happened. This is a work around till I figure out a better data model or a better method to compare.
    if (alreadyInArray == YES) {
        MOSubmissionObject *entryToUpdate = [converter submissionObjectForDictionary:objectsAsPropertyList[index]];
        
        if (entryToUpdate.counter > newObject.counter) {
            NSLog(@"Persistance Manager: entryToUpdate Counter is larger than newObject");
            NSMutableArray *newDatesArray = [newObject.datesArray mutableCopy];
            //sets entry counter to equal new counter
            entryToUpdate.counter = newObject.counter;
            NSLog(@"Persistence Manager: entryToUpdate counter is now %i", entryToUpdate.counter);
            
            if(entryToUpdate.counter == 0){
                
                [objectsAsPropertyList removeObjectAtIndex:index];
                NSLog(@"Persistance Manager: The counter is 0 and the object as propertylist is %@", objectsAsPropertyList);
                //return objectsAsPropertyList;
            }
            //sets the newDates array to the old one on the submissionObject that needed to be updated using mutabkle copy
            entryToUpdate.datesArray = [newDatesArray copy];
            //converts the updated submissionObject back to a dictionary
            NSDictionary *updatedEntryComplete = [converter submissionObjectAsPropertyList:entryToUpdate];
            //replaces the new dictionary over the old one in the same index spot
            [objectsAsPropertyList replaceObjectAtIndex:index withObject:updatedEntryComplete];
            
        }
    }
    
    if ([sectionHeader isEqualToString:@"SUBMISSIONS"]) {
        [[NSUserDefaults standardUserDefaults] setObject:objectsAsPropertyList forKey:ADDED_SUBMISSION_OBJECTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
        
        
    }else if ([sectionHeader isEqualToString:@"Submitted"]){
        [[NSUserDefaults standardUserDefaults] setObject:objectsAsPropertyList forKey:ADDED_SUBMITTED_OBJECTS_KEY];
        [[NSUserDefaults standardUserDefaults] synchronize];
    }
    
}


@end



