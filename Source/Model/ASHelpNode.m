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

#import "ASHelpNode.h"

@implementation ASHelpNode
//----------------------------
//		Class Methods
//----------------------------
+(ASHelpNode *) nodeWithName:(NSString *)n andHelpPage:(NSString *) path {
	ASHelpNode *tempNode = [[ASHelpNode new] autorelease];
	[tempNode setName:n];
	[tempNode setHelpPage:path];
	return tempNode;
}

//----------------------------
//		Superclass Overides
//----------------------------
- (id) init {
	if (self = [super init]) {
		_children = [NSMutableArray new];
	}
	return self;
}

-(BOOL) isEqual:(id) ob {
	if([super isEqual:ob]) {
		return YES;
	} else if([ob isMemberOfClass:[ASHelpNode class]]) {//then compare the names
		if([[ob name] isEqualToString:[self name]]) {
			return YES;	
		} else {
			return NO;
		}
	} else if([ob isKindOfClass:[NSString class]]) {//then compare the help URL's
		if([ob isEqualToString:[self helpPage]]) {
			return YES;
		} else {
			return NO;
		}
	}
			  
	return NO;
}

-(NSString *) description {
	return [NSString stringWithFormat:@"ASHelpNode Name: %@", _name];
}

-(void) dealloc {
	[_children release];
	[_name release];
	[_helpPage release];
	[super dealloc];
}


//----------------------------
//		Setter & Getters
//----------------------------
-(NSMutableArray *) children {
	return _children;
}

-(NSMutableArray *) allChildren {
	NSMutableArray *allChilds = [NSMutableArray array];
	ASHelpNode *tempNode;
	
	int l = [_children count];
	while(l--) {
		[allChilds addObject:tempNode = [_children objectAtIndex:l]];
		[allChilds addObjectsFromArray:[tempNode allChildren]];
	}

	return allChilds;
}

-(NSString *) name {
	return _name;
}

-(NSString *) helpPage {
	return _helpPage;
}

-(ASHelpNode *) parent {
	return _parent;	
}

//------- Setters -------

-(void) addChild:(ASHelpNode *) node {
	[_children addObject:node];
	[node setParent:self];
}

-(void) setName:(NSString *) name {//only used once no need to manage memory
	_name = [name copy];
}

-(void) setHelpPage:(NSString *) path {//only used once no need to manage memory
	_helpPage = [[[NSString stringWithFormat:@"%@%@", @"file://", path] stringByAddingPercentEscapesUsingEncoding:NSASCIIStringEncoding] retain];
}

-(void) setParent:(ASHelpNode *) p {
	_parent = p;
}
@end
