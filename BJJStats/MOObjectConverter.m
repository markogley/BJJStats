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
    
    
    NSDictionary *submissionDictionary = @{SUBMISSION_TYPE : submissionObject.submissionType, SUBMISSION_POSITION: submissionObject.submissionPosition, SUBMISSION_TOP_OR_BOTTOM: submissionObject.topOrBottom, SUBMISSION_COUNTER : @(submissionObject.counter)};
    
    return submissionDictionary;
    
}


//converts dictionary saved to NSUserDefaults as a MOSubmissionObject
-(MOSubmissionObject *)submissionObjectForDictionary:(NSDictionary *)dictionary{
    
    MOSubmissionObject *submissionObject = [[MOSubmissionObject alloc] initWithData:dictionary];
    
    return submissionObject;
    
}

@end
