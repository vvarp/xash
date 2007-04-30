//
//  XASHSplitView.m
//  XASH
//
//  Created by Juan Carlos Anorga on 6/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "XASHSplitView.h"

@implementation XASHSplitView

- (float) dividerThickness {
	return 8.0;
}

- (void)drawDividerInRect:(NSRect)aRect {
	NSImage *bar = [NSImage imageNamed:@"Split_Bar"];
	[bar setSize:aRect.size];
	NSSize barSize = [bar size];
	
	NSRect barRect = NSMakeRect(0, 0, barSize.width, barSize.height);
	
	//[bar setFlipped:YES];
	[self lockFocus];
	[bar drawAtPoint:aRect.origin fromRect:barRect operation:NSCompositeSourceOver fraction:1.0];
	[self unlockFocus];
	
	[bar release];
}

@end
