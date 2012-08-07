//
//  LGPronoun.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGPronoun.h"

@implementation LGPronoun

+ (NSString *)lexicalClass {
    return NSLinguisticTagPronoun;
}

- (BOOL)headsRelativeClause {
    NSArray * roots = @[@"who", @"which", @"whose"];
    return [roots containsObject:self.root];
}

@end
