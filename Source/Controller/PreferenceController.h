//
//  PreferenceController.h
//  XASH
//
//  Created by Michael Bianco on 4/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import <Cocoa/Cocoa.h>

#define PREF_KEY_VALUE(x) [[[NSUserDefaultsController sharedUserDefaultsController] values] valueForKey:(x)]
#define PREF_KEY_BOOL(x) [(PREF_KEY_VALUE(x)) boolValue]

#define CASE_INSENSITIVE_SEARCH @"caseInsensitiveSearching"
#define AUTO_OPEN_HELP_WIN @"autoWinOpen"
#define XASH_FLASH_PATH_8_KEY @"f8Path"
#define XASH_FLASH_PATH_7_KEY @"f7Path"
#define XASH_FLASH_INDEX_7_KEY @"f7Index"
#define XASH_FLASH_INDEX_8_KEY @"f8Index"
#define XASH_ADDITIONAL_SEARCH_PATHS @"additionalSearchPaths"

#define PATH_KEY @"path"

@interface PreferenceController : NSWindowController {}
@end
