//
//  DNDArrayController.m
//  XASH
//
//  Created by Michael Bianco on 4/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "DNDArrayController.h"
#import "NSFileManager+Additions.h"
#import "PreferenceController.h"

@implementation DNDArrayController
-(void) awakeFromNib {
	[oAdditionalPaths registerForDraggedTypes:[NSArray arrayWithObject:NSFilenamesPboardType]];
	[super awakeFromNib];
}

- (NSDragOperation) tableView:(NSTableView*)tv 
				 validateDrop:(id <NSDraggingInfo>)info 
				  proposedRow:(int)row 
		proposedDropOperation:(NSTableViewDropOperation)op {
	if([[info draggingPasteboard] availableTypeFromArray:[NSArray arrayWithObject:NSFilenamesPboardType]] == nil)
		return NSDragOperationNone;
	
	if(![[NSFileManager defaultManager] pathIsDirectory:[[NSURL URLFromPasteboard:[info draggingPasteboard]] path]])
		return NSDragOperationNone;
	
	return NSDragOperationGeneric;
}

- (BOOL) tableView:(NSTableView*)tv 
		acceptDrop:(id <NSDraggingInfo>)info 
			   row:(int)row 
	 dropOperation:(NSTableViewDropOperation)op {
	
	[self addObject:[NSMutableDictionary dictionaryWithObject:[[NSURL URLFromPasteboard:[info draggingPasteboard]] path] forKey:PATH_KEY]];
	
	return YES;
}

- (int) numberOfRowsInTableView:(NSTableView *)aTableView {//silence the error message
	return [[self arrangedObjects] count];
}

@end
