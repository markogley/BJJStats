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
#define ADDED_DRAW_OBJECTS_KEY @"Added Draw Objects Key"
#define ADDED_MATCH_OBJECTS_KEY @"Added Match Object Key"

-(void)addSubmissionObject:(MOSubmissionObject *)submissionObject;
-(void)addSubmittedObject:(MOSubmissionObject *)submissionObject;
//-(void)addDrawObject:(MOSubmissionObject *)submissionObject;
-(void)addMatchObject:(MOMatchObject *)matchObject;

-(NSMutableArray *)compareNewSubmissionObjectToSavedData:(NSMutableArray *)objectsAsPropertyList newSubmissionObject:(MOSubmissionObject *)newObject;
-(void)compareEditedSubmissionObjectToSavedData:(NSMutableArray *)objectsAsPropertyList newSubmissionObject:(MOSubmissionObject *)newObject sectionHeader:(NSString *)sectionHeader;


-(NSMutableArray *)compareNewMatchObjectToSavedMatchData:(NSMutableArray *)objectAsPropertyList newMatchObject:(MOMatchObject *)newObject;
-(void)compareEditedMatchObjectToSavedData:(NSMutableArray *)objectAsPropertyList newMatchObject:(MOMatchObject *)newObject;

@end
