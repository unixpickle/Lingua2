//
//  LGVerb.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGVerb.h"

@implementation LGVerb

+ (NSString *)lexicalClass {
    return NSLinguisticTagVerb;
}

- (BOOL)isVerbal {
    return YES;
}

@end
