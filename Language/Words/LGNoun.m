//
//  LGNoun.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGNoun.h"

@implementation LGNoun

+ (NSString *)lexicalClass {
    return NSLinguisticTagNoun;
}

- (BOOL)isNominal {
    return YES;
}

@end
