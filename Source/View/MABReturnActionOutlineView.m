//
//  MABReturnActionTableView.m
//  XASH
//
//  Created by Michael Bianco on 9/21/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "MABReturnActionOutlineView.h"

// http://www.cocoadev.com/index.pl?NSTableViewTutorial

@implementation MABReturnActionOutlineView
- (void) keyDown:(NSEvent *)theEvent {
	if([theEvent keyCode] == 36) {
		[[self target] performSelector:[self action] withObject:self];
	} else {
		[super keyDown:theEvent];
	}
}
@end
