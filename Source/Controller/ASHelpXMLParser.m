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

#import "ASHelpXMLParser.h"
#import "ASHelpNode.h"

@implementation ASHelpXMLParser
-(id) initWithASXMLFile:(NSString *) path withRootNode:(ASHelpNode *) root {
	if(self = [self init]) {
		_rootNode = [root retain];
		_basePath = [[path stringByDeletingLastPathComponent] retain];
		_parser = [[NSXMLParser alloc] initWithContentsOfURL:[NSURL fileURLWithPath:path]];
		[_parser setShouldResolveExternalEntities:YES];
		[_parser setDelegate:self];
		[_parser parse];
	}
	
	return self;
}

-(void) dealloc {
	[_rootNode release];
	[_basePath release];
	[_parser release];
	[super dealloc];
}

//---------------------------------------
//		XMLParser Delegate Methods
//---------------------------------------
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict {
	if([elementName isEqualToString:@"book"]) {//a book tag is the root node
		ASHelpNode *tempNode = [[ASHelpNode nodeWithName:[attributeDict valueForKey:@"title"]
											 andHelpPage:nil] retain];
		[_rootNode addChild:tempNode];
		_rootNode = tempNode;
	} else if([elementName isEqualToString:@"level1"]) {
		[_rootNode addChild:_level1 = [ASHelpNode nodeWithName:[attributeDict valueForKey:NAME_KEY]
											 andHelpPage:HELP_URL]];
	} else if([elementName isEqualToString:@"level2"]) {
		[_level1 addChild:_level2 = [ASHelpNode nodeWithName:[attributeDict valueForKey:NAME_KEY]
											   andHelpPage:HELP_URL]];
	} else if([elementName isEqualToString:@"level3"]) {
		[_level2 addChild:_level3 = [ASHelpNode nodeWithName:[attributeDict valueForKey:NAME_KEY]
												 andHelpPage:HELP_URL]];
	} else if([elementName isEqualToString:@"level4"]) {
		[_level3 addChild:_level4 = [ASHelpNode nodeWithName:[attributeDict valueForKey:NAME_KEY]
												 andHelpPage:HELP_URL]];
	} else {
#if DEBUG >= 1
		NSLog(@"Uncaught XML node name: %@", elementName);
#endif
	}
}
@end
