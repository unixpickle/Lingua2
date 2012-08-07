//
//  LGInfinitive.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGInfinitive.h"

@implementation LGInfinitive

- (BOOL)addWord:(LGWord *)word context:(LGParseContext *)context {
    if ([word isKindOfClass:[LGPreposition class]] && [tokens count] == 0) {
        [tokens addObject:word];
        hasPreposition = YES;
        return YES;
    } else {
        return [super addWord:word context:context];
    }
}

@end
