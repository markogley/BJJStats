//
//  MOObjectConverter.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-22.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOObjectConverter.h"

@implementation MOObjectConverter


//converts MOSubmissionObjects to PropertyLists
-(NSDictionary *)submissionObjectAsPropertyList:(MOSubmissionObject *)submissionObject {
    
    
    NSDictionary *submissionDictionary = @{SUBMISSION_TYPE : submissionObject.submissionType, SUBMISSION_POSITION: submissionObject.submissionPosition, SUBMISSION_TOP_OR_BOTTOM: submissionObject.topOrBottom, SUBMISSION_COUNTER_AND_DATE : @{SUBMISSION_COUNTER : @(submissionObject.counter), SUBMISSION_DATE: [submissionObject.datesArray mutableCopy]}};

    
    return submissionDictionary;
    
}


//converts dictionary saved to NSUserDefaults as a MOSubmissionObject
-(MOSubmissionObject *)submissionObjectForDictionary:(NSDictionary *)dictionary{
    
    MOSubmissionObject *submissionObject = [[MOSubmissionObject alloc] initWithData:dictionary];
    
    return submissionObject;
    
}

-(NSDictionary *)matchObjectAsPropertyList:(MOMatchObject *)matchObject{
    
    NSDictionary *matchDictionary = @{MATCH_DATE : matchObject.matchDate, NUMBER_OF_MATCHES : @(matchObject.numberOfMatches)};
    
    return matchDictionary;
    
    
}

-(MOMatchObject *)matchObjectForDictionary:(NSDictionary *)dictionary{
    
    
    MOMatchObject *matchObject = [[MOMatchObject alloc] initMatchObjectWithData:dictionary];
    
    return matchObject;
}


@end
