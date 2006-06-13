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

#import "FilterController.h"
#import "XASHController.h"
#import "NSString+Additions.h"
#import "ASHelpOutlineDataSource.h"
#import "ASHelpNode.h"
#import "PreferenceController.h"
#import "shared.h"

static FilterController *_sharedFilter;

@implementation FilterController

+(FilterController *) sharedFilter {
	extern FilterController *_sharedFilter;
	return _sharedFilter;
}

- (id) init {
	if (self = [super init]) {
		extern FilterController *_sharedFilter;
		_sharedFilter = self;
	}
	
	return self;
}


-(void) reloadData {//this is only called once after all the books have been loaded
	NSMutableArray *books = [[[[ASHelpOutlineDataSource sharedSource] rootNode] children] mutableCopy];
	[books insertObject:[ASHelpNode nodeWithName:@"All Books"
									 andHelpPage:nil] atIndex:0];

	[self setFilterArray:books];
}

-(IBAction) setFilteredBook:(id)sender {//called by the pop-up menu, the data source is watching the filterIndex so it knows once its changed
	[self setFilterIndex:[sender indexOfSelectedItem]];
	[self setSearchStr:oSearchField];
}

-(IBAction) setSearchStr:(id)sender {
	NSMutableArray *results = [NSMutableArray array];
	NSArray *allPages = _filterIndex == 0 ? [[XASHController sharedController] allHelpPages] : [[[[[ASHelpOutlineDataSource sharedSource] rootNode] children] objectAtIndex:_filterIndex - 1] allChildren];
	NSString *searchStr = [sender stringValue];
	ASHelpNode *temp;
	int l = [allPages count], a = 0;
	BOOL caseInsensitive = PREF_KEY_BOOL(CASE_INSENSITIVE_SEARCH);
	
	if(!isEmpty(searchStr)) {
		for(; a < l; a++) {
			if([[temp = [allPages objectAtIndex:a] name] containsString:searchStr ignoringCase:caseInsensitive]) {
				[results addObject:temp];
			}
		}
	}
	
	[self setSearchResults:results];
	[self setSearchString:searchStr];
}

//----------------------------
//		Getters & Setters
//----------------------------
-(NSMutableArray *) filterArray {
	return _filterArray;
}

-(void) setFilterArray:(NSMutableArray *) a {
	[a retain];
	[_filterArray release];
	_filterArray = a;
}

-(int) filterIndex {
	return _filterIndex;	
}

-(void) setFilterIndex:(int) index {
	_filterIndex = index;
}

-(NSString *) searchString {
	return _searchString;
}

-(void) setSearchString:(NSString *)str {
	[str retain];
	[_searchString release];
	_searchString = str;
}

-(NSArray *) searchResults {
	return _searchResults;
}

-(void) setSearchResults:(NSArray *) ar {
	[ar retain];
	[_searchResults release];
	_searchResults = ar;
}
@end
