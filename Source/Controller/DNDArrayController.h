//
//  DNDArrayController.h
//  XASH
//
//  Created by Michael Bianco on 4/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

//this is a super controller: this is the data source, the delegate, and the NSArrayController that the table view is bound to
//-(int)numberOfRowsInTableView: is to silence some error messages about data sources
//related links:
//	http://www.cocoabuilder.com/archive/message/cocoa/2004/12/22/124387
//	http://www.cocoabuilder.com/archive/message/cocoa/2005/1/26/126753


@interface DNDArrayController : NSArrayController {
	IBOutlet NSTableView *oAdditionalPaths;
}

//================================================= 
// Table View Drag n' Drop Support
//=================================================
- (NSDragOperation) tableView:(NSTableView*)tv validateDrop:(id <NSDraggingInfo>)info proposedRow:(int)row proposedDropOperation:(NSTableViewDropOperation)op;
- (BOOL) tableView:(NSTableView*)tv acceptDrop:(id <NSDraggingInfo>)info row:(int)row dropOperation:(NSTableViewDropOperation)op;

- (int)numberOfRowsInTableView:(NSTableView *)aTableView; //makes the error message dissapear... dunno why though
@end
