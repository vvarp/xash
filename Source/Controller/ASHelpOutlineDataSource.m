/*
 Application: XASH, Xcode-like Flash Help File Viewer
 Copyright (C) 2005 Michael Bianco <software@mabwebdesign.com>
 
 This program is free software; you can redistribute it and/or
 modify it under the terms of the GNU General Public License
 as published by the Free Software Foundation; either version 2
 of the License, or (at your option) any later version.
 
 This program is distributed in the hope that it will be useful,
 but WITHOUT ANY WARRANTY; without even the implied warranty of
 MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
 GNU General Public License for more details.
 
 You should have received a copy of the GNU General Public License
 along with this program; if not, write to the Free Software
 Foundation, Inc., 59 Temple Place - Suite 330, Boston, MA  02111-1307, USA.
 */

#import "ASHelpOutlineDataSource.h"
#import "FilterController.h"
#import "XASHController.h"
#import "ASHelpNode.h"
#import "shared.h"

//checks whether 'item' is nil, if it it adjusts the 'item' accordingly. If we are filtering it also adjusts the item
#define DATA_SOURCE_CHECK_NIL \
if(item == nil) { \
	item = _rootNode; \
	if(_lastIndex != 0) {/* then we have to filter some books */ \
		item = [[_rootNode children] objectAtIndex:_lastIndex - 1 /* -1 for the 'all books' filtering menu item */]; \
	} \
}

static ASHelpOutlineDataSource *_sharedSource;

@implementation ASHelpOutlineDataSource
//----------------------------
//		Class Methods
//----------------------------
+(ASHelpOutlineDataSource *) sharedSource {
	extern ASHelpOutlineDataSource *_sharedSource;
	return _sharedSource;
}

//----------------------------
//		Superclass Overides
//----------------------------
- (id) init {
	if (self = [super init]) {
		extern ASHelpOutlineDataSource *_sharedSource;
		_sharedSource = self; //only one instance of this ob, so set the shared ob to itself
		
		[self setRootNote:[[ASHelpNode new] autorelease]];
	}
	
	return self;
}

-(void) awakeFromNib {
	//register observers to objects that are stored in a nib after the nib is loaded
	//listen for changes in the filtering and searching parameters to change the data accordingly
	[[FilterController sharedFilter] addObserver:self
									  forKeyPath:@"filterIndex"
										 options:0
										 context:nil];
	
	[[FilterController sharedFilter] addObserver:self
									  forKeyPath:@"searchString"
										 options:0
										 context:nil];
}

//----------------------------
//		KVO Methods
//----------------------------
- (void)observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context {
	if([keyPath isEqualToString:@"searchString"]) {
		//if we have an empty string then we arent searching anymore
		if(isEmpty([[FilterController sharedFilter] searchString])) {
			ASHelpNode *targetNode, *tempNode, *relRoot = _rootNode;
			
			_isSearching = NO;
			[oHelpTree setIndentationPerLevel:CELL_INDENT];
			[oHelpTree setUsesAlternatingRowBackgroundColors:NO];
			targetNode = tempNode = [oHelpTree itemAtRow:[oHelpTree selectedRow]]; //store the currently selected node
			
			[oHelpTree reloadData]; //reload the data so the linear search view is replaced by the outline view
			
			//select the previously selected row in the tree view
			while(tempNode = [tempNode parent]) {
				if(relRoot == [targetNode parent]) {//if the relRoot is the parent of the target node then we are done
					break;
				}
				
				//NSLog(@"%@ Expand? %i:%i", tempNode, [oHelpTree isExpandable:tempNode], [tempNode parent] == relRoot);
				if([oHelpTree isExpandable:tempNode] && [tempNode parent] == relRoot) {
					[oHelpTree expandItem:tempNode];
					
					relRoot = tempNode; //set the root the current tempNode
					tempNode = targetNode; //reset the tempNode
				}
			}
			
			[oHelpTree selectRow:[oHelpTree rowForItem:targetNode] byExtendingSelection:NO];
		} else {//now we are searching
			_isSearching = YES;
			[oHelpTree setIndentationPerLevel:0.0];
			[oHelpTree setUsesAlternatingRowBackgroundColors:YES];
			[oHelpTree reloadData];
		}		
	} else if([keyPath isEqualToString:@"filterIndex"]) {
		int tempIndex = [[FilterController sharedFilter] filterIndex];
		if(tempIndex == _lastIndex) return;
		
		_lastIndex = tempIndex;
		[oHelpTree reloadData];
	}
}

//----------------------------
//		Getter & Setter
//----------------------------
- (ASHelpNode *) rootNode {
	return _rootNode;
}

- (void) setRootNote:(ASHelpNode *)node {
	[node retain];
	[_rootNode release];
	_rootNode = node;
}

//----------------------------
//		Data Source Methods
//----------------------------

//if item  == nil then we are starting at the root, this goes for all datasource methods

- (id) outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item {
	DATA_SOURCE_CHECK_NIL;

	if(_isSearching) return [[[FilterController sharedFilter] searchResults] objectAtIndex:index];
	
	return [[item children] objectAtIndex:index];
}

- (BOOL) outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item {
	DATA_SOURCE_CHECK_NIL;
	
	//when we are searching no items are expandable
	if(_isSearching) return NO;
	
	return [[item children] count] != 0;
}

- (int) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item {
	if(_isSearching) {
		if(item != nil) {//while searching there is never any children
			return 0;
		}
		
		return [[[FilterController sharedFilter] searchResults] count];
	}
	
	DATA_SOURCE_CHECK_NIL;
	
	return [[(ASHelpNode*)item children] count]; 
}

- (id) outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item {
	return [item name];
}

- (void) outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item {
	[cell setControlSize:NSSmallControlSize];
	[cell setFont:[NSFont systemFontOfSize:[NSFont systemFontSizeForControlSize:NSSmallControlSize]]];
}
@end