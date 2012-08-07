//
//  LGRelativePhrase.m
//  Lingua2
//
//  Created by Alex Nichol on 8/7/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGRelativePhrase.h"

@implementation LGRelativePhrase

- (BOOL)addPhrase:(LGPhrase *)phrase context:(LGParseContext *)context {
    if ([phrase isKindOfClass:[LGVerbalPhrase class]]) {
        if (hasVerbal) {
            [context rewind:[phrase phraseWordCount]];
            return NO;
        } else {
            hasVerbal = YES;
        }
    }
    [tokens addObject:phrase];
    return YES;
    // TODO: do some stuff so that we can call [super addPhrase:context:]
}

- (NSString *)description {
    return [NSString stringWithFormat:@"(%@)", [super description]];
}

@end
