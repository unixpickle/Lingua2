//
//  LGVerbalPhrase.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGVerbalPhrase.h"
#import "LGInfinitive.h"

@implementation LGVerbalPhrase

- (LGWord *)betterAlternativeForWord:(LGWord *)word {
    if (subPhrase) return [subPhrase betterAlternativeForWord:word];
    id lastToken = [tokens lastObject];
    Class newClass = Nil;
    
    // is + verb -> is + adjective
    if ([lastToken isKindOfClass:[LGVerb class]]) {
        if ([[(LGVerb *)lastToken root] isEqualToString:@"be"]) {
            if ([[word classPossibilities] containsObject:NSLinguisticTagAdjective] && [word isKindOfClass:[LGVerb class]]) {
                newClass = [LGAdjective class];
            }
        }
    }
    
    if (newClass) {
        LGWord * newWord = [[newClass alloc] initWithWord:word.word root:word.root range:word.characterRange];
        newWord.classPossibilities = word.classPossibilities;
        return newWord;
    }
    return nil;
}

- (BOOL)addWord:(LGWord *)word context:(LGParseContext *)context {
    if (hasVerb) {
        return [super addWord:word context:context];
    }
    if ([word isKindOfClass:[LGVerb class]]) {
        hasVerb = YES;
        NSArray * verbTakers = @[@"may", @"can", @"will", @"shall"];
        if ([verbTakers containsObject:[word root]]) acceptsVerbal = YES;
    } else if (![word isKindOfClass:[LGAdverb class]] && ![word isKindOfClass:[LGConjunction class]]) {
        [context rewind:1];
        return NO;
    }
    [tokens addObject:word];
    return YES;
}

- (BOOL)addPhrase:(LGPhrase *)phrase context:(LGParseContext *)context {
    if ([phrase isKindOfClass:[LGInfinitive class]]) {
        [tokens addObject:phrase];
    } else if ([phrase isVerbal] && acceptsVerbal) {
        [tokens addObject:phrase];
    } else {
        [context rewind:[phrase phraseWordCount]];
        return NO;
    }
    return YES;
}

- (BOOL)isVerbal {
    return YES;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"[%@]", [super description]];
}

@end
