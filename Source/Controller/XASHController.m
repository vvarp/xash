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

#import <WebKit/WebKit.h>

#import "XASHController.h"
#import "ASHelpXMLParser.h"
#import "ASHelpOutlineDataSource.h"
#import "ASHelpNode.h"
#import "FilterController.h"
#import "PreferenceController.h"
#import "NSFileManager+Additions.h"
#import "shared.h"

static XASHController *_sharedController;

@implementation XASHController
//----------------------------
//		Class Methods
//----------------------------
+(XASHController *) sharedController {
	return _sharedController;
}

+(void) initialize {
	//register default search paths
	NSMutableDictionary *defaults = [NSMutableDictionary dictionary];
	
	[defaults setValue:XASH_FLASH_PATH_8 forKey:XASH_FLASH_PATH_8_KEY];
	[defaults setValue:XASH_FLASH_PATH_7 forKey:XASH_FLASH_PATH_7_KEY];
	[defaults setValue:XASH_FLASH_INDEX_8 forKey:XASH_FLASH_INDEX_8_KEY];
	[defaults setValue:XASH_FLASH_INDEX_7 forKey:XASH_FLASH_INDEX_7_KEY];
	
	[defaults setValue:[NSNumber numberWithBool:YES] forKey:CASE_INSENSITIVE_SEARCH];
	[defaults setValue:[NSNumber numberWithBool:YES] forKey:AUTO_OPEN_HELP_WIN];
	[defaults setValue:[NSNumber numberWithBool:YES] forKey:XASH_USE_LAST_BOOK];
	
	NSArray *searchPaths = [NSArray arrayWithObject:[NSMutableDictionary dictionaryWithObject:[NSHomeDirectory() stringByAppendingString:@"/Library/Application Support/Macromedia/Flash MX 2004/en/Configuration/HelpPanel/Help/"] forKey:PATH_KEY]];
	[defaults setValue:searchPaths forKey:XASH_ADDITIONAL_SEARCH_PATHS];
	
	[[NSUserDefaultsController sharedUserDefaultsController] setInitialValues:defaults];
	[[NSUserDefaultsController sharedUserDefaultsController] setAppliesImmediately:YES];
}

//----------------------------
//		Functional Methods
//----------------------------
- (void) configFlashVersion {
	NSFileManager *manager = [NSFileManager defaultManager];
	NSString *f8Path = PREF_KEY_VALUE(XASH_FLASH_PATH_8_KEY), *f7Path = PREF_KEY_VALUE(XASH_FLASH_PATH_7_KEY);

	if([manager fileExistsAtPath:f8Path]) {
		_helpPath = f8Path;
		_helpIndex = PREF_KEY_VALUE(XASH_FLASH_INDEX_8_KEY);
	} else if([manager fileExistsAtPath:f7Path]) {
		_helpPath = f7Path;
		_helpIndex = PREF_KEY_VALUE(XASH_FLASH_INDEX_7_KEY);
	} else {//no flash help path found
		_helpPath = nil;
		//_helpIndex = nil;
	}
	
	//if no valid help files were found
	if(_helpPath == nil) {
		NSLog(@"No valid help files found");
		NSRunAlertPanel(NSLocalizedString(@"No Help Documents", nil), NSLocalizedString(@"We were unable to find any valid help documents in the search paths you specified. Please reconfigure your search paths using the preference pane.", nil), @"Ok", nil, nil);
	}
}

- (void) loadHelpFiles {
	//config the help file paths
	[self configFlashVersion];
	
	if(_helpPath == nil) 
		return;
	
	NSFileManager *manager = [NSFileManager defaultManager];
	NSArray *helpTopics = [manager directoryContentsAtPath:_helpPath], *helpFolders = PREF_KEY_VALUE(XASH_ADDITIONAL_SEARCH_PATHS);
	int l = [helpTopics count], l2;
	NSString *tempDir, *currHelpDir, *helpDirIndex;
	
	//reset the outline data
	[[ASHelpOutlineDataSource sharedSource] setRootNote:[[ASHelpNode new] autorelease]];
	
	//look through all the contents of the flash7/8 help folder and load any help indexes found
	while(l--) {
		if([manager pathIsDirectory:[_helpPath stringByAppendingPathComponent:tempDir = [helpTopics objectAtIndex:l]]]) {
			helpDirIndex = [NSString stringWithFormat:@"%@%@%@", _helpPath, tempDir, TOC_PATH];
			if([manager fileExistsAtPath:helpDirIndex]) {//check to make sure the file exists first
				ADD_XML_FILE(helpDirIndex);
			}
		}
	}
	
	//loop through all the additional search directories and load any help indexes found
	l = [helpFolders count];
	while(l--) {
		if(![manager pathIsDirectory:currHelpDir = [[helpFolders objectAtIndex:l] valueForKey:PATH_KEY]]) {
			NSLog(@"File/Folder %@ does not exist, or is not a directory.", currHelpDir);
			continue;
		}
		
		helpTopics = [manager directoryContentsAtPath:currHelpDir];
		l2 = [helpTopics count];
		
		//loop through all the additional folders in the additional directories
		while(l2--) {
			if([manager pathIsDirectory:tempDir = [currHelpDir stringByAppendingPathComponent:[helpTopics objectAtIndex:l2]]]) {
				helpDirIndex = [tempDir stringByAppendingString:TOC_PATH];
				if([manager fileExistsAtPath:helpDirIndex]) {
					ADD_XML_FILE(helpDirIndex);
				} else {
					NSLog(@"Table of contents index file %@ not found", helpDirIndex);
				}
			} else {
				NSLog(@"File/Folder %@ does not exist, or is not a directory.", tempDir);
			}
		}
	}
	
	//get all the help pages in a linear array and save a reference to it
	//this is used to easily find a URL even if it isn't visible in the tree
	[self setAllHelpPages:[[[ASHelpOutlineDataSource sharedSource] rootNode] allChildren]];
	
	//load the index page, tree data, and filter information
	[[oWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:_helpIndex]]];
	[[FilterController sharedFilter] reloadData];
	[oHelpTree reloadData];	
}

//----------------------------
//		Superclass Overides
//----------------------------
- (id) init {
	if (self = [super init]) {
		//set the shared controller
		extern XASHController *_sharedController;
		_sharedController = self;
		
		[[NSNotificationCenter defaultCenter] addObserver:self
												 selector:@selector(appDidBecomeActive:)
													 name:@"NSApplicationDidBecomeActiveNotification"
												   object:NSApp];
	}
	return self;
}

-(void) awakeFromNib {
	//exclude the main window from the 
	[oHelpWindow setExcludedFromWindowsMenu:YES];
	
	//help files loading
	[self loadHelpFiles];
	
	//toolbar setup
	[self setupToolbar];
}

-(void) appDidBecomeActive:(NSNotification *)note {
	if(PREF_KEY_BOOL(AUTO_OPEN_HELP_WIN))
		[oHelpWindow makeKeyAndOrderFront:self];
}

//----------------------------
//		Action Methods
//----------------------------
-(IBAction) setHelpPage:(id)sender {
	if(!isEmpty([(ASHelpNode*)[oHelpTree itemAtRow:[oHelpTree selectedRow]] helpPage])) {
#if DEBUG
		NSLog(@"Nil URL selected");
#endif
		[[oWebView mainFrame] loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:[(ASHelpNode*)[oHelpTree itemAtRow:[oHelpTree selectedRow]] helpPage]]]];
	}
}

-(IBAction) goToWebSite:(id)sender {
	OPEN_URL(HOME_URL);
}

-(IBAction) openPreferences:(id)sender {
	if(!_preferenceController) {
		_preferenceController = [[PreferenceController alloc] initWithWindowNibName:@"Preferences"];
	}

	[_preferenceController showWindow:self];
}

-(IBAction) selectSearchField:(id)sender {
	NSToolbar *toolbar = [[NSApp mainWindow] toolbar];
	if(![toolbar isVisible]) {
		[toolbar setVisible:YES];
	}
	
	[oSearchField selectText:self];
}

- (IBAction) selectTopSearchItem:(id)sender {
	if(![sender currentEditor]) {//then they pressed enter
		[oHelpTree selectRow:0 byExtendingSelection:NO];
		[[oHelpTree target] performSelector:[oHelpTree action] withObject:self];
	}
}

//----------------------------
//		Getter & Setter
//----------------------------
- (NSArray *) allHelpPages {
	return _allHelpPages;	
}

- (void) setAllHelpPages:(NSArray *) pages {
	[pages retain];
	[_allHelpPages release];
	_allHelpPages = pages;
}

//----------------------------
//		Delegate Methods
//----------------------------
- (void)webView:(WebView *)sender didStartProvisionalLoadForFrame:(WebFrame *)frame {
	NSString *currURL;
	if([currURL = [[[[frame provisionalDataSource] request] URL] absoluteString] isEqualToString:@"file://(null)"]) {//check for a null URL
#if DEBUG >= 1
		NSLog(@"A file://(null) URL was loaded into a web-view");
#endif
		return;
	}
		
	//get rid of an anchor if theres one in the string
	NSRange tempRange;
	if((tempRange = [currURL rangeOfString:@"#"]).location != NSNotFound && tempRange.location > [currURL rangeOfString:@"/" options:NSBackwardsSearch].location) {
		currURL = [currURL substringToIndex:tempRange.location];
	}
	
	//check to make sure the object is found
	int index = [_allHelpPages indexOfObject:currURL];
	if(index == NSNotFound) {
#if DEBUG >= 1
		NSLog(@"%@, not found in help page array", currURL);
#endif
		return;
	}
	
	ASHelpNode *targetNode, *tempNode;
	tempNode = targetNode = [_allHelpPages objectAtIndex:index];
	
	if(!targetNode) { //check to make sure we found the model object
#if DEBUG >= 1
		NSLog(@"No model object found for: %@", [[[[frame provisionalDataSource] request] URL] absoluteString]);
#endif
		return;
	}

	while(tempNode = [tempNode parent]) {
		[oHelpTree expandItem:tempNode];
	}
	
	[oHelpTree selectRow:[oHelpTree rowForItem:targetNode] byExtendingSelection:NO];
}

- (void)webView:(WebView *)sender didCommitLoadForFrame:(WebFrame *)frame {
	if([sender canGoBack]) {
		[oBackBtn setEnabled:YES];
	} else {
		[oBackBtn setEnabled:NO];
	}
	
	if([sender canGoForward]) {
		[oForwardBtn setEnabled:YES];
	} else {
		[oForwardBtn setEnabled:NO];
	}
}

- (void)webView:(WebView *)sender didReceiveTitle:(NSString *)title forFrame:(WebFrame *)frame {
	[oHelpWindow setTitle:[NSString stringWithFormat:@"%@ : %@", BASE_WIN_TITLE, title]];
}

- (void)webView:(WebView *)sender didFailProvisionalLoadWithError:(NSError *)error forFrame:(WebFrame *)frame {
#if DEBUG >= 1
	NSLog(@"Load error %@", error);
#endif
}

- (void)webView:(WebView *)sender decidePolicyForNewWindowAction:(NSDictionary *)actionInformation request:(NSURLRequest *)request newFrameName:(NSString *)frameName decisionListener:(id)listener {
	OPEN_URL([[request URL] absoluteString]);
	[listener ignore];
}

//delegate method for the split view, gives a minimum width to the outline view
- (float)splitView:(NSSplitView *)sender constrainMinCoordinate:(float)proposedMin ofSubviewAt:(int)offset {
	if(offset == 0) {
		return MIN_LEFT_PANEL_W;
	} else {
		return 0; //this never happens so....
	}
}

- (void)splitView:(NSSplitView *)sender resizeSubviewsWithOldSize:(NSSize)oldSize
{
    // how to resize a horizontal split view so that the left frame stays a constant size
    NSView *left = [[sender subviews] objectAtIndex:0];      // get the two sub views
    NSView *right = [[sender subviews] objectAtIndex:1];
    float dividerThickness = [sender dividerThickness];         // and the divider thickness
    NSRect newFrame = [sender frame];                           // get the new size of the whole splitView
    NSRect leftFrame = [left frame];                            // current size of the left subview
    NSRect rightFrame = [right frame];                          // ...and the right
    leftFrame.size.height = newFrame.size.height;               // resize the height of the left
    leftFrame.origin = NSMakePoint(0,0);                        // don't think this is needed
	leftFrame.size.width = MIN(leftFrame.size.width, newFrame.size.width - dividerThickness);
     // the rest of the width...
    rightFrame.size.width = newFrame.size.width - leftFrame.size.width - dividerThickness;
    rightFrame.size.height = newFrame.size.height;              // the whole height
    rightFrame.origin.x = leftFrame.size.width + dividerThickness;
    [left setFrame:leftFrame];
    [right setFrame:rightFrame];
}

//----------------------------
//		Toolbar Methods
//----------------------------

- (void)setupToolbar
{
	NSToolbar *toolbar = [[NSToolbar alloc] initWithIdentifier:@"mainToolbar"];
	[toolbar setDelegate:self];
	[toolbar setAllowsUserCustomization:YES];
	[toolbar setAutosavesConfiguration:YES];
	[oHelpWindow setToolbar:[toolbar autorelease]];
}
- (NSToolbarItem *)toolbar:(NSToolbar *)toolbar
	itemForItemIdentifier:(NSString *)itemIdentifier
	willBeInsertedIntoToolbar:(BOOL)flag
{
	NSToolbarItem *item = [[NSToolbarItem alloc] initWithItemIdentifier:itemIdentifier];
	
	if ([itemIdentifier isEqualToString:@"NavItem"]) {
		[item setLabel:@"Back/Forward"];
		[item setPaletteLabel:[item label]];
		[item setView:oNavView];
		
		NSRect fRect = [oNavView frame];
		[item setMinSize:fRect.size];
		[item setMaxSize:fRect.size];
	} else if ([itemIdentifier isEqualToString:@"SearchItem"]) {
		[item setLabel:@"Search"];
		[item setPaletteLabel:[item label]];
		[item setView:oSearchView];
		
		NSRect fRect = [oSearchView frame];
		[item setMinSize:fRect.size];
		[item setMaxSize:fRect.size];
	}
	
	return [item autorelease];
}
- (NSArray *)toolbarAllowedItemIdentifiers:(NSToolbar*)toolbar
{
	return [NSArray arrayWithObjects:NSToolbarSeparatorItemIdentifier,
				    NSToolbarSpaceItemIdentifier,
				    NSToolbarFlexibleSpaceItemIdentifier,
				    NSToolbarCustomizeToolbarItemIdentifier, 
				    @"AddItem", @"RemoveItem", @"SearchItem", nil];
}
- (NSArray *)toolbarDefaultItemIdentifiers:(NSToolbar*)toolbar
{
	return [NSArray arrayWithObjects:@"SearchItem",
					@"NavItem",
					NSToolbarFlexibleSpaceItemIdentifier,
					nil];
}

@end
