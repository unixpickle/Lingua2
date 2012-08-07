//
//  LGNounPhrase.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGNounPhrase.h"
#import "LGVerbalPhrase.h"

@implementation LGNounPhrase

- (LGWord *)betterAlternativeForWord:(LGWord *)word {
    if (subPhrase) return [subPhrase betterAlternativeForWord:word];
    Class newClass = Nil;
    if (hasNoun && [word isKindOfClass:[LGNoun class]]) {
        if ([[word word] hasSuffix:@"s"]) {
            // a common mistake for NSLinguisticTagger (e.g. "the fox {jumps} over the lazy dog")
            if ([[word classPossibilities] containsObject:NSLinguisticTagVerb]) {
                newClass = [LGVerb class];
            }
        }
    }
    if (newClass) {
        LGWord * nWord = [[newClass alloc] initWithWord:word.word root:word.root range:word.characterRange];
        nWord.classPossibilities = word.classPossibilities;
        return nWord;
    } else {
        return nil;
    }
}

- (BOOL)addWord:(LGWord *)word context:(LGParseContext *)context {
    if (hasNoun) {
        [context rewind:1];
        return NO;
    }
    if ([word isKindOfClass:[LGNoun class]]) {
        hasNoun = YES;
    } else if ([word isKindOfClass:[LGVerb class]]) {
        BOOL hasAdj = NO;
        for (LGWord * word in tokens) {
            if ([word isKindOfClass:[LGAdjective class]] || [word isKindOfClass:[LGDeterminer class]]) {
                hasAdj = YES;
                break;
            }
        }
        if (!hasAdj) {
            context.rereadAs = [LGVerbalPhrase class];
            [context rewind:([self phraseWordCount] + 1)];
            return NO;
        } else {
            [context rewind:1];
            return NO;
        }
    } else if (![word isKindOfClass:[LGAdjective class]] && ![word isKindOfClass:[LGDeterminer class]] && ![word isKindOfClass:[LGConjunction class]] && ![word isKindOfClass:[LGAdverb class]]) {
        [context rewind:1];
        return NO;
    }
    [tokens addObject:word];
    return YES;
}

- (LGPhraseCompleteStatus)contextComplete:(LGParseContext *)context {
    if (hasNoun) return LGPhraseCompleteStatusDone;
    BOOL hasAdj = NO;
    for (LGWord * word in tokens) {
        if ([word isKindOfClass:[LGAdjective class]]) {
            hasAdj = YES;
            break;
        }
    }
    if (hasAdj) return LGPhraseCompleteStatusDone;
    
    context.rereadAs = [LGVerbalPhrase class];
    [context rewind:([self phraseWordCount])];
    return LGPhraseCompleteStatusReread;
}

- (BOOL)isNominal {
    return YES;
}

- (BOOL)headsRelativeClause {
    if ([tokens count] > 0) {
        return [[tokens objectAtIndex:0] headsRelativeClause];
    }
    return [super headsRelativeClause];
}

- (NSString *)description {
    return [NSString stringWithFormat:@"{%@}", [super description]];
}

@end
