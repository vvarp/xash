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

//class to handle the parsing of xml files
//one time use class, after the initalization of XASH these classes are discarded and never used again

#define LINK_KEY @"href"
#define NAME_KEY @"name"

#define HELP_URL ([_basePath stringByAppendingPathComponent:[attributeDict valueForKey:LINK_KEY]])

@class ASHelpNode;

@interface ASHelpXMLParser : NSObject {
	ASHelpNode *_rootNode, *_level1, *_level2, *_level3, *_level4;
	NSXMLParser *_parser;
	NSString *_basePath;
}

-(id) initWithASXMLFile:(NSString *) path withRootNode:(ASHelpNode *) root;

//---------------------------------------
//		XMLParser Delegate Methods
//---------------------------------------
- (void)parser:(NSXMLParser *)parser didStartElement:(NSString *)elementName 
  namespaceURI:(NSString *)namespaceURI 
 qualifiedName:(NSString *)qualifiedName 
	attributes:(NSDictionary *)attributeDict;
@end
