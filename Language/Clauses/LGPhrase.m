//
//  LGPhrase.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGPhrase.h"
#import "LGNounPhrase.h"
#import "LGVerbalPhrase.h"
#import "LGPrepositional.h"
#import "LGRelativePhrase.h"

@implementation LGPhrase

@synthesize tokens;
@synthesize subPhrase;

- (id)init {
    if ((self = [super init])) {
        tokens = [[NSMutableArray alloc] init];
    }
    return self;
}

- (LGWord *)betterAlternativeForWord:(LGWord *)word {
    if (subPhrase) return [subPhrase betterAlternativeForWord:word];
    return nil;
}

- (BOOL)addWord:(LGWord *)word context:(LGParseContext *)context {
    if (subPhrase) {
        if ([subPhrase addWord:word context:context]) {
            return YES;
        } else {
            if (context.rereadAs != Nil) {
                subPhrase = [[context.rereadAs alloc] init];
                context.rereadAs = Nil;
                return YES;
            }
            LGPhrase * addPhrase = subPhrase;
            subPhrase = nil;
            return [self addPhrase:addPhrase context:context];
        }
    } else {
        if ([word isKindOfClass:[LGNoun class]] || [word isKindOfClass:[LGAdjective class]] || [word isKindOfClass:[LGAdverb class]] || [word isKindOfClass:[LGDeterminer class]]) {
            subPhrase = [[LGNounPhrase alloc] init];
            if (![subPhrase addWord:word context:context]) {
                @throw [NSException exceptionWithName:NSInternalInconsistencyException
                                               reason:@"LGNounPhrase should accept a noun/adjective!"
                                             userInfo:nil];
            }
        } else if ([word isKindOfClass:[LGVerb class]]) {
            subPhrase = [[LGVerbalPhrase alloc] init];
            [context rewind:1];
        } else if ([word isKindOfClass:[LGPreposition class]]) {
            subPhrase = [[LGPrepositional alloc] init];
            [context rewind:1];
        } else {
            [tokens addObject:word];
        }
    }
    return YES;
}

- (BOOL)addPhrase:(LGPhrase *)phrase context:(LGParseContext *)context {
    if ([phrase headsRelativeClause]) {
        subPhrase = [[LGRelativePhrase alloc] init];
        // should always be YES
        NSAssert([subPhrase addPhrase:phrase context:context] == YES, @"subphrase should take subphrase head");
        return YES;
    } else {
        [tokens addObject:phrase];
        return YES;
    }
}

- (LGPhraseCompleteStatus)contextComplete:(LGParseContext *)context {
    if (subPhrase) {
        LGPhraseCompleteStatus subResult = [subPhrase contextComplete:context];
        if (subResult == LGPhraseCompleteStatusDone || subResult == LGPhraseCompleteStatusTerminated) {
            BOOL stat = [self addPhrase:subPhrase context:context];
            subPhrase = nil;
            if (stat) {
                if (subResult == LGPhraseCompleteStatusTerminated) {
                    return LGPhraseCompleteStatusSustained;
                } else {
                    return LGPhraseCompleteStatusDone;
                }
            } else if (context.rereadAs != Nil) {
                return LGPhraseCompleteStatusReread;
            } else {
                return LGPhraseCompleteStatusTerminated;
            }
        } else if (subResult == LGPhraseCompleteStatusSustained) {
            return LGPhraseCompleteStatusSustained;
        } else if (subResult == LGPhraseCompleteStatusReread) {
            if (context.rereadAs != Nil) {
                //NSLog(@"reread as %@", NSStringFromClass(context.rereadAs));
                subPhrase = [[context.rereadAs alloc] init];
                context.rereadAs = Nil;
            }
            return LGPhraseCompleteStatusReread;
        }
    }
    return LGPhraseCompleteStatusDone;
}

- (NSInteger)phraseWordCount {
    NSInteger count = 0;
    for (id token in tokens) {
        if ([token isKindOfClass:[LGPhrase class]]) {
            count += [token phraseWordCount];
        } else count += 1;
    }
    return count;
}

- (NSString *)description {
    NSMutableString * desc = [[NSMutableString alloc] init];
    for (NSInteger i = 0; i < [tokens count]; i++) {
        [desc appendFormat:@"%@%@", [tokens objectAtIndex:i], (i + 1 == [tokens count] ? @"" : @" ")];
    }
    return desc;
}

@end
