//
//  STTweetLabel.m
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 09/29/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "STTweetLabel.h"

@interface STTweetLabel ()

@end

@implementation STTweetLabel

#pragma mark -
#pragma mark Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setUpLabel];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setUpLabel];
}

#pragma mark -
#pragma mark Setup

- (void)setUpLabel
{
	// Set the basic properties
	[self setBackgroundColor:[UIColor clearColor]];
	[self setClipsToBounds:NO];
	[self setUserInteractionEnabled:YES];
	[self setNumberOfLines:0];
}

#pragma mark -
#pragma mark Printing text

- (void)drawTextInRect:(CGRect)rect
{
    
}

#pragma mark -
#pragma mark UIView events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
}

@end
