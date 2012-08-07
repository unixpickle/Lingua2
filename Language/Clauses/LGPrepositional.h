//
//  LGPrepositional.h
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGPhrase.h"
#import "LGSingleUnknown.h"
#import "LGNounPhrase.h"
#import "LGInfinitive.h"

@interface LGPrepositional : LGPhrase {
    BOOL hasPreposition;
    BOOL hasNounPhrase;
    BOOL potentialInfinitive;
}

@end
