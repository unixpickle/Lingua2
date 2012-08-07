//
//  LGPhrase.h
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGWord.h"
#import "LGNoun.h"
#import "LGPronoun.h"
#import "LGVerb.h"
#import "LGAdverb.h"
#import "LGAdjective.h"
#import "LGDeterminer.h"
#import "LGPreposition.h"
#import "LGConjunction.h"
#import "LGInterjection.h"
#import "LGParseContext.h"
#import "LGName.h"

typedef enum {
    LGPhraseCompleteStatusDone,
    LGPhraseCompleteStatusReread,
    LGPhraseCompleteStatusTerminated,
    LGPhraseCompleteStatusSustained
} LGPhraseCompleteStatus;

@interface LGPhrase : LGObject {
    NSMutableArray * tokens; // array of LGObjects
    
    // used during parsing
    LGPhrase * subPhrase;
}

@property (readonly) NSMutableArray * tokens;
@property (readonly) LGPhrase * subPhrase;

- (LGWord *)betterAlternativeForWord:(LGWord *)word;
- (BOOL)addWord:(LGWord *)word context:(LGParseContext *)context;
- (BOOL)addPhrase:(LGPhrase *)phrase context:(LGParseContext *)context;
- (LGPhraseCompleteStatus)contextComplete:(LGParseContext *)context;
- (NSInteger)phraseWordCount;

@end
