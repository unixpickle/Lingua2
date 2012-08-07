//
//  LGName.m
//  Lingua2
//
//  Created by Alex Nichol on 8/7/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import "LGName.h"

@implementation LGName

+ (BOOL)isNameTag:(NSString *)tag {
    NSArray * tags = @[NSLinguisticTagPersonalName, NSLinguisticTagPlaceName, NSLinguisticTagOrganizationName];
    return [tags containsObject:tag];
}

@end
