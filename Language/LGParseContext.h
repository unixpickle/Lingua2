//
//  LGParseContext.h
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@class LGPhrase;

@interface LGParseContext : NSObject {
    NSMutableArray * words;
    NSInteger index;
    __unsafe_unretained Class rereadAs;
}

@property (nonatomic, unsafe_unretained) Class rereadAs;

+ (NSArray *)parseContextsForString:(NSString *)string;
- (void)addWord:(NSString *)word
          range:(NSRange)charRange
           root:(NSString *)root
        lexical:(NSArray *)theClasses
         scores:(NSArray *)scores;

- (LGPhrase *)phrase;
- (void)rewind:(NSInteger)count;

@end
