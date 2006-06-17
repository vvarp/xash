/*
 Application: XASH, Flash Help for Xcode
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

#import <Cocoa/Cocoa.h>

#define CELL_INDENT 16.0F

@class ASHelpNode;

@interface ASHelpOutlineDataSource : NSObject {
	ASHelpNode *_rootNode;
	IBOutlet NSOutlineView *oHelpTree;
	int _lastIndex;
	BOOL _isSearching;
}
//----------------------------
//		Class Methods
//----------------------------
+(ASHelpOutlineDataSource *) sharedSource;

//----------------------------
//		KVO Methods
//----------------------------
- (void) observeValueForKeyPath:(NSString *)keyPath ofObject:(id)object change:(NSDictionary *)change context:(void *)context;

//----------------------------
//		Getter & Setter
//----------------------------
-(ASHelpNode *) rootNode;

//----------------------------
//		Data Source Methods
//----------------------------
-(id) outlineView:(NSOutlineView *)outlineView child:(int)index ofItem:(id)item;
-(BOOL) outlineView:(NSOutlineView *)outlineView isItemExpandable:(id)item;
-(int) outlineView:(NSOutlineView *)outlineView numberOfChildrenOfItem:(id)item;
-(id) outlineView:(NSOutlineView *)outlineView objectValueForTableColumn:(NSTableColumn *)tableColumn byItem:(id)item;

//----------------------------
//		Delegate Methods
//----------------------------
- (void)outlineView:(NSOutlineView *)outlineView willDisplayCell:(id)cell forTableColumn:(NSTableColumn *)tableColumn item:(id)item;

@end
