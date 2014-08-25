//
//  MOObjectConverter.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-07-22.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOSubmissionObject.h"
#import "MOMatchObject.h"

@interface MOObjectConverter : NSObject

-(NSDictionary *)submissionObjectAsPropertyList:(MOSubmissionObject *)submissionObject;
-(MOSubmissionObject *)submissionObjectForDictionary:(NSDictionary *)dictionary;

-(NSDictionary *)matchObjectAsPropertyList:(MOMatchObject *)matchObject;
-(MOMatchObject *)matchObjectForDictionary:(NSDictionary *)dictionary;


@end
