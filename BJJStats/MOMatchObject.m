//
//  MOMatchObject.m
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-25.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import "MOMatchObject.h"

@implementation MOMatchObject


-(id)init{
    
    self = [self initMatchObjectWithData:nil];
    return self;
}

-(id)initMatchObjectWithData:(NSDictionary *)data{
    
    self = [super init];
    
    self.numberOfMatches = [data[NUMBER_OF_MATCHES] intValue];
    self.matchDate = data[MATCH_DATE];
    
    return self;
    
}

@end
