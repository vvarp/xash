//
//  NSString+Additions.m
//  XASH
//
//  Created by Michael Bianco on 4/3/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "NSString+Additions.h"

@implementation NSString (SearchingAdditions)

- (BOOL)containsString:(NSString *)aString {
    return [self containsString:aString ignoringCase:NO];
}

- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)flag {
    unsigned mask = (flag ? NSCaseInsensitiveSearch : 0);
    return [self rangeOfString:aString options:mask].length > 0;
}

@end