//
//  STTweetLabel.m
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 09/29/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "STTweetLabel.h"

#pragma mark -
#pragma mark STTweetLabel

@interface STTweetLabel ()

@property (nonatomic, strong) NSString *cleanText;
@property (strong) NSMutableArray *rangesOfHotWords;

- (void)setupLabel;
- (void)determineHotWords;

@end

@implementation STTweetLabel

#pragma mark -
#pragma mark Lifecycle

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    
    if (self)
    {
        [self setupLabel];
    }
    
    return self;
}

- (void)awakeFromNib
{
    [super awakeFromNib];
    
    [self setupLabel];
}

#pragma mark -
#pragma mark Setup

- (void)setupLabel
{
    _cleanText = @"LOL";
    
	// Set the basic properties
	[self setBackgroundColor:[UIColor clearColor]];
	[self setClipsToBounds:NO];
	[self setUserInteractionEnabled:YES];
	[self setNumberOfLines:0];
    
    _hashtagColor = [UIColor redColor];
    _linkColor = [UIColor purpleColor];
    _handleColor = [UIColor cyanColor];
}

#pragma mark -
#pragma mark Printing and calculating text
//
//- (void)drawTextInRect:(CGRect)rect
//{
//    
//}

- (void)determineHotWords
{
    (_cleanText == nil) ? _cleanText = [NSString string] : 0 ;
    
    NSMutableString *tmpText = [[NSMutableString alloc] initWithString:_cleanText];
    
    NSString *hotCharacters = @"@#";
    NSCharacterSet *hotCharactersSet = [NSCharacterSet characterSetWithCharactersInString:hotCharacters];
    
    NSMutableCharacterSet *validCharactersSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [validCharactersSet removeCharactersInString:@"!@#$%^&*()-={[]}|;:',<>.?/"];
    
    _rangesOfHotWords = [[NSMutableArray alloc] init];
    
    while ([tmpText rangeOfCharacterFromSet:hotCharactersSet].location < tmpText.length)
    {
        NSRange range = [tmpText rangeOfCharacterFromSet:hotCharactersSet];
 
        STTweetHotWord hotWord;
        
        switch ([tmpText characterAtIndex:range.location])
        {
            case '@':
                hotWord = STTweetHandle;
                break;
            case '#':
                hotWord = STTweetHashtag;
                break;
            case 'h':
                hotWord = STTweetHandle;
                break;
            default:
                break;
        }

        [tmpText replaceCharactersInRange:range withString:@"%"];
        
        int length = 1;
        
        while ([validCharactersSet characterIsMember:[tmpText characterAtIndex:range.location + length]])
        {
            length++;
        }
        
        [_rangesOfHotWords addObject:@{@"hotWord": @(hotWord), @"range": NSStringFromRange(NSMakeRange(range.location, length))}];
    }
    
    NSLog(@"%@", _rangesOfHotWords);
    
    [self updateText];
}

- (void)updateText
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_cleanText];
    [attributedString setAttributes:@{NSForegroundColorAttributeName: self.textColor} range:NSMakeRange(0, _cleanText.length)];
    
    for (NSDictionary *dictionary in _rangesOfHotWords)
    {
        NSRange range = NSRangeFromString([dictionary objectForKey:@"range"]);
        
        [attributedString setAttributes:@{NSForegroundColorAttributeName: [self colorForHotWord:[[dictionary objectForKey:@"hotWord"] intValue]]} range:range];
    }
    
    [self setAttributedText:attributedString];
    NSLog(@"%@", attributedString);
}
         
 - (UIColor *)colorForHotWord:(STTweetHotWord)hotWord
 {
     switch (hotWord)
     {
         case STTweetHandle:
             return _handleColor;
             break;
         case STTweetHashtag:
             return _hashtagColor;
             break;
         case STTweetLink:
             return _linkColor;
             break;
         default:
             return self.textColor;
             break;
     }
 }

#pragma mark -
#pragma mark Setters

- (void)setText:(NSString *)text
{
    _cleanText = text;
    
    [self determineHotWords];
}
         
- (void)setTextColor:(UIColor *)textColor
{
    [super setTextColor:textColor];
    
    [self determineHotWords];
}

#pragma mark -
#pragma mark Getters

- (NSString *)text
{
    return _cleanText;
}
         
//- (UIColor *)textColor
//{
//    return self.textColor;
//}
//
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
