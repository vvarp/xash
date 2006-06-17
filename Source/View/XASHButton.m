//
//  XASHButton.m
//  XASH
//
//  Created by Juan Carlos Anorga on 6/5/06.
//  Copyright 2006 __MyCompanyName__. All rights reserved.
//

#import "XASHButton.h"

@implementation XASHButton
- (id)initWithCoder:(NSCoder*)aDecoder
{
   if(self = [super initWithCoder:aDecoder])
   {
      [[self cell] setImageDimsWhenDisabled:NO];
      [self setValue:[NSImage imageNamed:[self alternateTitle]] forKey:@"disabledImage"];
      [self setAlternateTitle:@""];
      if([self isEnabled] == NO)
         [self setImage:disabledImage];
   }
   return self;
}
 
- (void)setEnabled:(BOOL)flag
{
   if(flag != [self isEnabled])
   {
      if(!normalImage)
         [self setValue:[self image] forKey:@"normalImage"];
      [self setImage:flag ? normalImage : disabledImage];
      [super setEnabled:flag];
   }
}
 
- (void)dealloc
{
   [self setValue:nil forKey:@"disabledImage"];
   [self setValue:nil forKey:@"normalImage"];
   [super dealloc];
}
@end