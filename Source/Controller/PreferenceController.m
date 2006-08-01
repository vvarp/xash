//
//  PreferenceController.m
//  XASH
//
//  Created by Michael Bianco on 4/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PreferenceController.h"
#import "MABPathTextField.h"

@implementation PreferenceController
- (void) awakeFromNib {
	[oFlashPath setAllowsDirectoriesOnly:YES];
	[oFlashIndex setPathOutputType:MABURLPathType];
	[oFlashIndex setAllowsDirectoriesOnly:NO];
}

- (IBAction) addPreferencePath:(id) sender {
	NSOpenPanel *panel = [NSOpenPanel openPanel];
	[panel setCanChooseFiles:NO];
	[panel setCanChooseDirectories:YES];
	[panel setAllowsMultipleSelection:NO];
	[panel setTitle:@"Add Additional Search Path"];
	[panel beginSheetForDirectory:nil
							 file:nil
							types:nil
				   modalForWindow:[self window]
					modalDelegate:self
				   didEndSelector:@selector(openPanelDidEnd:returnCode:contextInfo:)
					  contextInfo:nil];
}

- (void) openPanelDidEnd:(NSOpenPanel *)panel returnCode:(int)returnCode  contextInfo:(void  *)contextInfo {
	if(returnCode == NSOKButton)
		[oDNDController addObject:[NSMutableDictionary dictionaryWithObject:[[panel URL] path] forKey:PATH_KEY]];
}

- (void) windowWillClose:(NSNotification *)aNotification {
	SET_PREF_KEY_VALUE(XASH_FLASH_PATH_8_KEY, [oFlashPath stringValue]);
	SET_PREF_KEY_VALUE(XASH_FLASH_INDEX_8_KEY, [oFlashIndex stringValue]);
	[[NSUserDefaultsController sharedUserDefaultsController] save:self];
}
@end
