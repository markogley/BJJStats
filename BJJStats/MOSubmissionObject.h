//
//  MOSubmissionObject.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-20.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOSubmissionData.h"

@interface MOSubmissionObject : NSObject

@property (strong, nonatomic) NSString *submissionType;
@property (strong, nonatomic) NSString *submissionPosition;
@property (strong, nonatomic) NSString *topOrBottom;
@property int counter;


-(id)initWithData:(NSDictionary *)data;
-(void)incrementCounter;



@end
