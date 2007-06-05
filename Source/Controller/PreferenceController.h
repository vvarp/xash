//
//  PreferenceController.h
//  XASH
//
//  Created by Michael Bianco on 4/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define SET_PREF_KEY_VALUE(x, y) [[[NSUserDefaultsController sharedUserDefaultsController] values] setValue:(y) forKey:(x)]
#define PREF_KEY_VALUE(x) [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:(x)]
#define PREF_KEY_BOOL(x) [(PREF_KEY_VALUE(x)) boolValue]

#define CASE_INSENSITIVE_SEARCH @"caseInsensitiveSearching"
#define AUTO_OPEN_HELP_WIN @"autoWinOpen"
#define XASH_ADDITIONAL_SEARCH_PATHS @"additionalSearchPaths"
#define XASH_USE_LAST_BOOK @"useLastBook"
#define XASH_LAST_BOOK_NAME @"lastBook"

#define PATH_KEY @"path"

@class MABPathTextField;

@interface PreferenceController : NSWindowController {
	IBOutlet NSArrayController *oDNDController;
	IBOutlet MABPathTextField *oFlashIndex;
	IBOutlet MABPathTextField *oFlashPath;
}

//======================================
//		Action Methods
//======================================
- (IBAction) addPreferencePath:(id)sender;
- (IBAction) reloadHelpFiles:(id)sender;

//======================================
//		Delegate Methods
//======================================
- (void) openPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo;
- (void) windowWillClose:(NSNotification *)aNotification;
@end
