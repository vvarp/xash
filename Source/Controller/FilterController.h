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

#import <Cocoa/Cocoa.h>

@interface FilterController : NSObject {
	IBOutlet NSSearchField *oSearchField;
	NSMutableArray *_filterArray;
	NSArray *_searchResults;
	NSString *_searchString;
	int _filterIndex;
}

+(FilterController *) sharedFilter;
-(IBAction) setFilteredBook:(id)sender; //called by the book list NSPopUpMenu
-(IBAction) setSearchStr:(id)sender; //SearchStr to prevent conflicts with the setter method
-(void) reloadData;

//----------------------------
//		Getters & Setters
//----------------------------
-(NSMutableArray *) filterArray;
-(void) setFilterArray:(NSMutableArray *) a;
-(int) filterIndex;
-(void) setFilterIndex:(int) index;
-(NSString *) searchString;
-(void) setSearchString:(NSString *)str;
-(NSArray *) searchResults;
-(void) setSearchResults:(NSArray *) ar;
@end
