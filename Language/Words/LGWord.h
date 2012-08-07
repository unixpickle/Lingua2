//
//  LGWord.h
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGObject.h"

@interface LGWord : LGObject {
    NSArray * classPossibilities;
    NSString * root;
    NSString * word;
    NSRange characterRange;
}

@property (nonatomic, retain) NSArray * classPossibilities;
@property (nonatomic, retain) NSString * root;
@property (nonatomic, retain) NSString * word;
@property (readwrite) NSRange characterRange;

+ (NSString *)lexicalClass;
- (id)initWithWord:(NSString *)theWord root:(NSString *)theRoot range:(NSRange)range;

@end
