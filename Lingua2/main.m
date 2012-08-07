//
//  main.m
//  Lingua2
//
//  Created by Alex Nichol on 7/31/12.
//  Copyright (c) 2012 Alex Nichol. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "LGParseContext.h"
#import "LGPhrase.h"

NSString * readLine();

int main(int argc, const char * argv[]) {
    @autoreleasepool {
        printf("Enter some text: ");
        NSString * text = readLine();
        NSArray * contexts = [LGParseContext parseContextsForString:text];
        for (LGParseContext * context in contexts) {
            LGPhrase * sentence = [context phrase];
            printf("%s\n", [[sentence description] UTF8String]);
        }
    }
    return 0;
}

NSString * readLine() {
    NSMutableString * string = [NSMutableString string];
    int c = 0;
    while ((c = fgetc(stdin)) != EOF) {
        if (c == '\n') break;
        else if (c != '\r') {
            [string appendFormat:@"%c", (char)c];
        }
    }
    return string;
}
