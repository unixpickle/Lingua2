//
//  LGWord.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGWord.h"

@implementation LGWord

@synthesize classPossibilities;
@synthesize root;
@synthesize word;
@synthesize characterRange;

+ (NSString *)lexicalClass {
    return nil;
}

- (id)initWithWord:(NSString *)theWord root:(NSString *)theRoot range:(NSRange)range {
    if ((self = [super init])) {
        word = theWord;
        root = theRoot;
        characterRange = range;
    }
    return self;
}

- (NSString *)description {
    return [NSString stringWithFormat:@"\"%@\" <%@>", word, [[self class] lexicalClass]];
}

@end
