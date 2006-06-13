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

//data node for the outline view

@interface ASHelpNode : NSObject {
	ASHelpNode *_parent;
	NSMutableArray *_children;
	NSString *_helpPage, *_name;
}
//----------------------------
//		Class Methods
//----------------------------
+(ASHelpNode *) nodeWithName:(NSString *)n andHelpPage:(NSString *) path;

//----------------------------
//		Setter & Getters
//----------------------------
-(NSMutableArray *) children;
-(NSMutableArray *) allChildren;
-(NSString *) name;
-(NSString *) helpPage;
-(ASHelpNode *) parent;

-(void) addChild:(ASHelpNode *) node;
-(void) setName:(NSString *) name;
-(void) setHelpPage:(NSString *) path;
-(void) setParent:(ASHelpNode *) p;
@end
