//
//  NSString+Additions.h
//  XASH
//
//  Created by Michael Bianco on 4/3/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

@interface NSString (SearchingAdditions)

- (BOOL)containsString:(NSString *)aString;
- (BOOL)containsString:(NSString *)aString ignoringCase:(BOOL)flag;

@end