//
//  MOSubmissionObject.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-20.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOSubmissionObject.h"

@implementation MOSubmissionObject


-(id)init{
    
    self = [self initWithData:nil];
    return self;
    
}

-(id)initWithData:(NSDictionary *)data{
    
    self = [super init];
    
    self.submissionType = data[SUBMISSION_TYPE];
    self.submissionPosition = data[SUBMISSION_POSITION];
    self.topOrBottom = data[SUBMISSION_TOP_OR_BOTTOM];
    self.counter = [data[SUBMISSION_COUNTER] intValue];
    
    
    return self;
    
}

-(void)incrementCounter{
    self.counter = self.counter + 1;
}


@end
