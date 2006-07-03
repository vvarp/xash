//
//  PreferenceController.m
//  XASH
//
//  Created by Michael Bianco on 4/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "PreferenceController.h"

@implementation PreferenceController
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
	NSLog(@"%@", [[panel URL] path]);
	[oDNDController addObject:[NSMutableDictionary dictionaryWithObject:[[panel URL] path] forKey:PATH_KEY]];
}
@end
