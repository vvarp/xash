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

int lengthSort(id ob1, id ob2, void *context) {
	int l1 = [[ob1 name] length], l2 = [[ob2 name] length];
	
	if(l1 < l2)
		return NSOrderedAscending;
	else if(l1 > l2)
		return NSOrderedDescending;
	else
		return NSOrderedSame;
}

@implementation FilterController

+(FilterController *) sharedFilter {
	extern FilterController *_sharedFilter;
	return _sharedFilter;
}

- (id) init {
	if (self = [super init]) {
		extern FilterController *_sharedFilter;
		_sharedFilter = self;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(applicationDidFinishLaunching:)
													 name:NSApplicationDidFinishLaunchingNotification
												   object:NSApp];
	}
	
	return self;
}

- (void) applicationDidFinishLaunching:(NSNotification *)note {
	if(PREF_KEY_BOOL(XASH_USE_LAST_BOOK)) {
		int a = 0, l = [_filterArray count];
		NSString *bookName = PREF_KEY_VALUE(XASH_LAST_BOOK_NAME);
		
		if(!isEmpty(bookName))
			for(; a < l; a++) {
				if([bookName isEqualToString:[[_filterArray objectAtIndex:a] name]]) {
					break;
				}
			}
				
		if(a != l) {
			[self setFilterIndex:a];
			[self setSearchString:_searchString];
			[oBookFilter selectItemWithTitle:bookName];
		}
	}
}

-(void) reloadData {//this is only called once after all the books have been loaded
	NSMutableArray *books = [[[[ASHelpOutlineDataSource sharedSource] rootNode] children] mutableCopy];
	[books insertObject:[ASHelpNode nodeWithName:@"All Books" andHelpPage:nil] atIndex:0];

	[self setFilterArray:[books autorelease]];
}

-(IBAction) setFilteredBook:(id)sender {//called by the pop-up menu, the data source is watching the filterIndex so it knows once its changed
	[self setFilterIndex:[sender indexOfSelectedItem]];
	[self setSearchString:_searchString];
	
	
	SET_PREF_KEY_VALUE(XASH_LAST_BOOK_NAME, [[_filterArray objectAtIndex:[self filterIndex]] name]);
}

//----------------------------
//		Getters & Setters
//----------------------------
- (NSMutableArray *) filterArray {
	return _filterArray;
}

- (void) setFilterArray:(NSMutableArray *) a {
	[a retain];
	[_filterArray release];
	_filterArray = a;
}

- (int) filterIndex {
	return _filterIndex;	
}

- (void) setFilterIndex:(int) index {
	_filterIndex = index;
}

- (NSString *) searchString {
	return _searchString;
}

- (void) setSearchString:(NSString *)str {
	//even if the string are the same we must set them and re-run the searching alg'r
	//the user might of changed the book filtering
	
	[str retain];
	[_searchString release];
	_searchString = str;
	
	NSMutableArray *results = [NSMutableArray array];
	
	if(!isEmpty(_searchString)) {
		NSArray *allPages = _filterIndex == 0 ? [[XASHController sharedController] allHelpPages] : [[[[[ASHelpOutlineDataSource sharedSource] rootNode] children] objectAtIndex:_filterIndex - 1] allChildren];
		ASHelpNode *temp;
		int l = [allPages count], a = 0;
		BOOL caseInsensitive = PREF_KEY_BOOL(CASE_INSENSITIVE_SEARCH);		
	
		for(; a < l; a++) {
			if([[temp = [allPages objectAtIndex:a] name] containsString:_searchString ignoringCase:caseInsensitive]) {
				[results addObject:temp];
			}
		}
	}
	
	results = [results sortedArrayUsingFunction:lengthSort context:NULL];
	
	[self setSearchResults:results];	
}

- (NSArray *) searchResults {
	return _searchResults;
}

- (void) setSearchResults:(NSArray *) ar {
	[ar retain];
	[_searchResults release];
	_searchResults = ar;
}
@end
