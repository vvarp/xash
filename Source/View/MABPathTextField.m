/*
 Copyright (c) 2006 Michael Bianco, <software@mabwebdesign.com>
 
 Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), 
 to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, 
 and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:
 
 The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.
 
 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, 
 INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, 
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, 
 DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, 
 ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.
 */

#import "MABPathTextField.h"

static BOOL isDirectory(NSString *path) {
	BOOL isDir;
	if ([[NSFileManager defaultManager] fileExistsAtPath:path isDirectory:&isDir] && isDir) return YES;
	else return NO;
}

// initWithFrame: not getting called -	http://www.cocoabuilder.com/archive/message/cocoa/2002/2/26/57517
//										http://www.cocoabuilder.com/archive/message/cocoa/2001/4/7/25777

@implementation MABPathTextField
//---------------------------------
//	Superclass Overides
//---------------------------------
- (id) initWithFrame:(NSRect)rect {
	if(self = [super initWithFrame:rect]) {
		[self awakeFromNib];
	}
	
	return self;
}

-(void) drawRect:(NSRect)rect {
	[super drawRect:rect];

	if(_dropIndicator) {//draw the focus indicator
		[[NSColor blackColor] set];
		[NSBezierPath setDefaultLineWidth:4.0];
		[NSBezierPath strokeRect:[self bounds]];
	}
}

- (void) awakeFromNib {
	[self registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
	[self setEditable:NO];
	[self setSelectable:YES];
	[[self cell] setScrollable:YES];
}

//---------------------------------
//	Dragging Destination Methods
//---------------------------------
- (unsigned int) draggingEntered:(id <NSDraggingInfo>)sender {
	if([[sender draggingPasteboard] availableTypeFromArray:[NSArray arrayWithObject:NSFilenamesPboardType]] != nil) {
		_dropIndicator = YES;
		[self setNeedsDisplay:YES];
		return NSDragOperationCopy;
	}
	
	return NSDragOperationNone;
}

- (BOOL) prepareForDragOperation:(id <NSDraggingInfo>)sender {
	NSString *tempPath = [NSString stringWithString:[[[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType] objectAtIndex:0]];
	
	[self draggingExited:sender];
	
	if(_directoryOnly && !isDirectory(tempPath))
		return NO;
	
	return YES;
}

- (BOOL) performDragOperation:(id <NSDraggingInfo>)sender {
	if(_pathType == MABStringPathType) {
		[self setStringValue:[[[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType] objectAtIndex:0]];
	} else if(_pathType == MABURLPathType) {
		[self setStringValue:[[[sender draggingPasteboard] propertyListForType:NSURLPboardType] objectAtIndex:0]];
	}
		
	return YES;
}

-(void)textDidEndEditing:(NSNotification*)note {
	NSLog(@"NOte %@", note);
	[super textDidEndEditing:note];
}

- (void) concludeDragOperation:(id <NSDraggingInfo>)sender {
	//NSLog(@"Conclude");
}

- (void) draggingExited:(id <NSDraggingInfo>)sender {
	_dropIndicator = NO;
	[self setNeedsDisplay:YES];
}

//---------------------------------
//	Setter & Getter
//---------------------------------

- (BOOL) allowsDirectoriesOnly {
	return _directoryOnly;
}

- (void) setAllowsDirectoriesOnly:(BOOL)allow {
	_directoryOnly = allow;
}

- (int) pathOutputType {
	return _pathType;
}

- (void) setPathOutputType:(int)type {
	_pathType = type;
}
@end
