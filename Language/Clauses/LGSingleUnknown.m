//
//  LGSingleUnknown.m
//  Lingua2
//
//  Created by Alex Nichol on 8/2/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGSingleUnknown.h"

@implementation LGSingleUnknown

- (BOOL)addWord:(LGWord *)word context:(LGParseContext *)context {
    if ([tokens count] > 0) {
        [context rewind:1];
        return NO;
    }
    [tokens addObject:word];
    return YES;
}

@end
