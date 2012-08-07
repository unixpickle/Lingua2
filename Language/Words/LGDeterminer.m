//
//  LGDeterminer.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGDeterminer.h"

@implementation LGDeterminer

- (BOOL)headsRelativeClause {
    if ([[word lowercaseString] isEqualToString:@"whose"]) return YES;
    return [super headsRelativeClause];
}

+ (NSString *)lexicalClass {
    return NSLinguisticTagDeterminer;
}

@end
