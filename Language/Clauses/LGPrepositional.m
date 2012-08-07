//
//  LGPrepositional.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGPrepositional.h"

@implementation LGPrepositional

- (id)init {
    self = [super init];
    return self;
}

- (BOOL)addWord:(LGWord *)word context:(LGParseContext *)context {
    if (hasNounPhrase) {
        [context rewind:1];
        return NO;
    }
    if (!hasPreposition && ![word isKindOfClass:[LGPreposition class]]) {
        [context rewind:1];
        return NO;
    } else if ([word isKindOfClass:[LGPreposition class]]) {
        [tokens addObject:word];
        if (!hasPreposition) {
            if ([[word root] isEqualToString:@"to"]) potentialInfinitive = YES;
        }
        hasPreposition = YES;
        return YES;
    }
    return [super addWord:word context:context];
}

- (BOOL)addPhrase:(LGPhrase *)phrase context:(LGParseContext *)context {
    // if it's a noun phrase, we're done
    if ([phrase isKindOfClass:[LGNounPhrase class]]) {
        hasNounPhrase = YES;
        [tokens addObject:phrase];
        return YES;
    } else {
        if (potentialInfinitive) {
            context.rereadAs = [LGInfinitive class];
            [context rewind:([phrase phraseWordCount] + [self phraseWordCount])];
        } else {
            context.rereadAs = [LGSingleUnknown class];
            [context rewind:([phrase phraseWordCount] + [self phraseWordCount])];
        }
        return NO;
    }
}

- (BOOL)headsRelativeClause {
    return [[tokens lastObject] headsRelativeClause];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"~%@~", [super description]];
}

@end
