//
//  MOSubmissionsPersistanceManager.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-26.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOSubmissionObject.h"
#import "MOSubmissionData.h"
#import "MOObjectConverter.h"

@interface MOSubmissionsPersistenceManager : NSObject

#define ADDED_SUBMISSION_OBJECTS_KEY @"Added Submission Objects Key"
#define ADDED_SUBMITTED_OBJECTS_KEY @"Added Submitted Objects Key"

-(void)addSubmissionObject:(MOSubmissionObject *)submissionObject;
-(void)addSubmittedObject:(MOSubmissionObject *)submissionObject;
-(NSMutableArray *)compareNewSubmissionObjectToSavedData:(NSMutableArray *)objectsAsPropertyList newSubmissionObject:(MOSubmissionObject *)newObject;
-(void)compareEditedSubmissionObjectToSavedData:(NSMutableArray *)objectsAsPropertyList newSubmissionObject:(MOSubmissionObject *)newObject sectionHeader:(NSString *)sectionHeader;

@end
