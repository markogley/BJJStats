//
//  MOMatchObject.h
//  BJJStats
//
//  Created by Mark Ogley on 2014-08-25.
//  Copyright (c) 2014 Mark Ogley. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "MOMatchData.h"

@interface MOMatchObject : NSObject

@property (strong, nonatomic) NSString *matchDate;
@property int numberOfMatches;


-(id)initMatchObjectWithData:(NSDictionary *)data;

@end
