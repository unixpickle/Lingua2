//
//  LGParseContext.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGParseContext.h"
#import "LGPhrase.h"

@implementation LGParseContext

@synthesize rereadAs;

+ (NSArray *)parseContextsForString:(NSString *)string {
    NSMutableArray * contexts = [[NSMutableArray alloc] init];
    __block NSRange theRange = NSMakeRange(-1, 0);
    __block LGParseContext * context;
    
    NSArray * schemes = @[NSLinguisticTagSchemeNameTypeOrLexicalClass, NSLinguisticTagSchemeLemma];
    NSLinguisticTagger * tagger = [[NSLinguisticTagger alloc] initWithTagSchemes:schemes
                                                                         options:(NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerOmitOther | NSLinguisticTaggerJoinNames)];
    [tagger setString:string];
    [tagger enumerateTagsInRange:NSMakeRange(0, string.length)
                          scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass
                         options:(NSLinguisticTaggerOmitWhitespace | NSLinguisticTaggerJoinNames)
                      usingBlock:^(NSString * tag, NSRange tokenRange, NSRange sentenceRange, BOOL * stop) {
                          NSRange sentRange;
                          NSString * root = [tagger tagAtIndex:tokenRange.location
                                                        scheme:NSLinguisticTagSchemeLemma
                                                    tokenRange:nil
                                                 sentenceRange:&sentRange];
                          
                          NSArray * scores = nil;
                          NSArray * tags = [tagger possibleTagsAtIndex:tokenRange.location
                                                                scheme:NSLinguisticTagSchemeNameTypeOrLexicalClass
                                                            tokenRange:NULL sentenceRange:NULL
                                                                scores:&scores];
                          
                          if (!context || theRange.location != sentenceRange.location) {
                              theRange = sentenceRange;
                              context = [[LGParseContext alloc] init];
                              [contexts addObject:context];
                          }
                          
                          [context addWord:[string substringWithRange:tokenRange]
                                     range:tokenRange
                                      root:root
                                   lexical:tags
                                    scores:scores];
                      }];
    
    return contexts;
}

- (id)init {
    if ((self = [super init])) {
        words = [[NSMutableArray alloc] init];
    }
    return self;
}

- (void)addWord:(NSString *)word
          range:(NSRange)charRange
           root:(NSString *)root
        lexical:(NSArray *)theClasses
         scores:(NSArray *)scores {
    
    // TODO: do this in LGPrepositional or LGInfinitive
    LGWord * lastWord = [words lastObject];
    NSString * lexicalClass = [theClasses objectAtIndex:0];
    if ([lastWord isKindOfClass:[LGPreposition class]]) {
        if ([[lastWord root] isEqualToString:@"to"]) {
            if ([theClasses containsObject:NSLinguisticTagVerb]) {
                lexicalClass = NSLinguisticTagVerb;
            }
        }
    }
    
    Class class = Nil;
    NSArray * classes = @[[LGNoun class], [LGPreposition class], [LGVerb class], [LGAdverb class],
    [LGAdjective class], [LGDeterminer class], [LGPreposition class],
    [LGConjunction class], [LGInterjection class], [LGPronoun class]];
    for (Class c in classes) {
        if ([[c lexicalClass] isEqualToString:lexicalClass]) {
            class = c;
            break;
        }
    }
    if ([LGName isNameTag:lexicalClass] && class == Nil) {
        class = [LGName class];
    }
    if (class) {
        id obj = [[class alloc] initWithWord:word root:root range:charRange];
        [obj setClassPossibilities:theClasses];
        [words addObject:obj];
    }
}

- (LGPhrase *)phrase {
    LGPhrase * phrase = [[LGPhrase alloc] init];
    index = 0;
    do {
        for (index = index; index < [words count]; index++) {
            rereadAs = Nil;
            LGWord * word = [words objectAtIndex:index];
            LGWord * better = [phrase betterAlternativeForWord:word];
            if (better) {
                [words replaceObjectAtIndex:index withObject:better];
                word = better;
            }
            [phrase addWord:word context:self];
        }
    } while ([phrase contextComplete:self] != LGPhraseCompleteStatusDone);
    return phrase;
}

- (void)rewind:(NSInteger)count {
    index -= count;
}

@end
