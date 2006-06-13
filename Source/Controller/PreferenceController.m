//
//  PreferenceController.m
//  XASH
//
//  Created by Michael Bianco on 4/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PreferenceController.h"

@implementation PreferenceController
/*
-(unsigned int) draggingEntered:(id <NSDraggingInfo>)sender {
	NSLog(@"Drag entered");
	//if(([sender draggingSourceOperationMask] & NSDragOperationCopy) == NSDragOperationCopy) {//How to mask for drag operations
	if([[sender draggingPasteboard] availableTypeFromArray:[NSArray arrayWithObject:NSFilenamesPboardType]] != nil) {
		return NSDragOperationCopy;
	}
	
	return NSDragOperationNone;
}

-(BOOL)prepareForDragOperation:(id <NSDraggingInfo>)sender {
	NSString *tempPath = [NSString stringWithString:[[[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType] objectAtIndex:0]];
	NSString *ext = [tempPath pathExtension];
	return YES;
}

-(BOOL)performDragOperation:(id <NSDraggingInfo>)sender {
	NSLog(@"Perform Drag: %@", [[[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType] objectAtIndex:0]);
	//[self setStringValue:[[[sender draggingPasteboard] propertyListForType:NSFilenamesPboardType] objectAtIndex:0]];
	return YES;
}

-(void)concludeDragOperation:(id <NSDraggingInfo>)sender {
	NSLog(@"Conclude");
}

-(void) draggingExited:(id <NSDraggingInfo>)sender {
	NSLog(@"exit");
}
*/
@end
