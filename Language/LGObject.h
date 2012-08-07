//
//  LGObject.h
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface LGObject : NSObject

- (BOOL)isNominal;
- (BOOL)isVerbal;
- (BOOL)headsRelativeClause;
- (BOOL)headsSubordinateClause;

@end
