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
@property (strong) NSMutableArray *locationsOfHotWords;

@property (nonatomic, strong) NSDictionary *attributesText;
@property (nonatomic, strong) NSDictionary *attributesHandle;
@property (nonatomic, strong) NSDictionary *attributesHashtag;
@property (nonatomic, strong) NSDictionary *attributesLink;

- (void)setupLabel;
- (void)determineHotWords;
- (void)determineLinks;
- (void)updateText;
- (NSString *)temporaryStringWithSize:(int)size;

@end

@implementation STTweetLabel
{
    CGPoint _startTouchPoint;
}

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
	// Set the basic properties
	[self setBackgroundColor:[UIColor clearColor]];
	[self setClipsToBounds:NO];
	[self setUserInteractionEnabled:YES];
	[self setNumberOfLines:0];
    
    _leftToRight = YES;
    
    _attributesText = @{NSForegroundColorAttributeName: self.textColor, NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    _attributesHandle = @{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    _attributesHashtag = @{NSForegroundColorAttributeName: [[UIColor alloc] initWithWhite:170.0/255.0 alpha:1.0], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    _attributesLink = @{NSForegroundColorAttributeName: [[UIColor alloc] initWithRed:129.0/255.0 green:171.0/255.0 blue:193.0/255.0 alpha:1.0], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    
    self.validProtocols = @[@"http://", @"https://", @"ssh://"];
}

#pragma mark -
#pragma mark Printing and calculating text

- (void)determineHotWords
{
    // Need a text
    if (_cleanText == nil)
    {
        return;
    }
    
    NSMutableString *tmpText = [[NSMutableString alloc] initWithString:_cleanText];
    
    // Support RTL
    if (!_leftToRight)
    {
        tmpText = [[NSMutableString alloc] init];
        [tmpText appendString:@"\u200F"];
        [tmpText appendString:_cleanText];
    }
    
    // Define a character set for hot characters (@ handle, # hashtag)
    NSString *hotCharacters = @"@#";
    NSCharacterSet *hotCharactersSet = [NSCharacterSet characterSetWithCharactersInString:hotCharacters];
    
    // Define a character set for the complete world (determine the end of the hot word)
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
            default:
                break;
        }

        [tmpText replaceCharactersInRange:range withString:@"%"];
        
        // If the hot character is not preceded by a alphanumeric characater, ie email (sebastien@world.com)
        if (range.location > 0 && [tmpText characterAtIndex:range.location - 1] != ' ')
            continue;

        // Determine the length of the hot word
        int length = (int)range.length;
        
        while (range.location + length < tmpText.length && [validCharactersSet characterIsMember:[tmpText characterAtIndex:range.location + length]])
        {
            length++;
        }
        
        // Register the hot word and its range
        [_rangesOfHotWords addObject:@{@"hotWord": @(hotWord), @"range": NSStringFromRange(NSMakeRange(range.location, length))}];
    }
    
    [self determineLinks];
    
    [self updateText];
}

- (void)determineLinks
{
    NSMutableString *tmpText = [[NSMutableString alloc] initWithString:_cleanText];

    // Define a character set for the complete world (determine the end of the hot word)
    NSMutableCharacterSet *validCharactersSet = [NSMutableCharacterSet alphanumericCharacterSet];
    [validCharactersSet removeCharactersInString:@"!@#$%^&*()-={[]}|;:',<>.?/"];
    [validCharactersSet addCharactersInString:@"!*'();:@&=+$,/?#[].-"];

    for (int index = 0; index < _validProtocols.count; index++)
    {
        NSString *substring = _validProtocols[index];
        
        while ([tmpText rangeOfString:substring].location < tmpText.length)
        {
            NSRange range = [tmpText rangeOfString:substring];
            
            [tmpText replaceCharactersInRange:range withString:[self temporaryStringWithSize:(int)range.length]];
            
            // If the hot character is not preceded by a alphanumeric characater, ie email (sebastien@world.com)
            if (range.location > 0 && [tmpText characterAtIndex:range.location - 1] != ' ')
                continue;

            // Determine the length of the hot word
            int length = (int)range.length;
            
            while (range.location + length < tmpText.length && [validCharactersSet characterIsMember:[tmpText characterAtIndex:range.location + length]])
            {
                length++;
            }

            // Register the hot word and its range
            [_rangesOfHotWords addObject:@{@"hotWord": @(STTweetLink), @"protocol": _validProtocols[index], @"range": NSStringFromRange(NSMakeRange(range.location, length))}];
        }
    }
}

- (void)updateText
{
    NSMutableAttributedString *attributedString = [[NSMutableAttributedString alloc] initWithString:_cleanText];
    [attributedString setAttributes:_attributesText range:NSMakeRange(0, _cleanText.length)];
    
    for (NSDictionary *dictionary in _rangesOfHotWords)
    {
        NSRange range = NSRangeFromString([dictionary objectForKey:@"range"]);
        
        STTweetHotWord hotWord = (STTweetHotWord)[[dictionary objectForKey:@"hotWord"] intValue];
        
        [attributedString setAttributes:[self attributesForHotWord:hotWord] range:range];
    }
    
    [self setAttributedText:attributedString];
    
    CGSize suggestedFrameSize = [self suggestedFrameSizeToFitEntireStringConstraintedToWidth:self.frame.size.width];
    CGRect frame = self.frame;
    frame.size = suggestedFrameSize;
    self.frame = frame;
    
    _locationsOfHotWords = [[NSMutableArray alloc] init];
    
    for (NSDictionary *dictionary in _rangesOfHotWords)
    {
        NSRange range = NSRangeFromString([dictionary objectForKey:@"range"]);
        
        NSMutableAttributedString *tmpAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
        [tmpAttributedString deleteCharactersInRange:NSMakeRange(range.location, tmpAttributedString.length - range.location)];

        CGRect originBounds = [tmpAttributedString boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//        NSLog(@"%@", NSStringFromCGRect(originBounds));
        
        tmpAttributedString = [[NSMutableAttributedString alloc] initWithAttributedString:attributedString];
        [tmpAttributedString deleteCharactersInRange:NSMakeRange(range.location + range.length, tmpAttributedString.length - (range.location + range.length))];
        [tmpAttributedString deleteCharactersInRange:NSMakeRange(0, range.location)];
        
        CGRect sizeBounds = [tmpAttributedString boundingRectWithSize:CGSizeMake(self.frame.size.width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
//        NSLog(@"%@", NSStringFromCGRect(sizeBounds));

        CGRect bounds = CGRectMake(originBounds.size.width, originBounds.size.height - sizeBounds.size.height, sizeBounds.size.width, sizeBounds.size.height);
        NSLog(@"%@: %@",tmpAttributedString.string,  NSStringFromCGRect(bounds));
        [_locationsOfHotWords addObject:[NSValue valueWithCGRect:bounds]];
    }

}

- (NSString *)temporaryStringWithSize:(int)size
{
    NSMutableString *string = [NSMutableString string];
    
    for (int i = 0; i < size; i++)
    {
        [string appendString:@"%"];
    }
    
    return string;
}

#pragma mark -
#pragma mark Public methods

- (CGSize)suggestedFrameSizeToFitEntireStringConstraintedToWidth:(CGFloat)width
{
    if (_cleanText == nil)
    {
        return CGSizeZero;
    }

    CGRect bounds = [self.attributedText boundingRectWithSize:CGSizeMake(width, CGFLOAT_MAX) options:NSStringDrawingUsesLineFragmentOrigin context:nil];
    
    return bounds.size;
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

- (void)setValidProtocols:(NSArray *)validProtocols
{
    _validProtocols = validProtocols;
    
    [self determineHotWords];
}

- (void)setAttributes:(NSDictionary *)attributes
{
    if ([attributes objectForKey:NSFontAttributeName] == nil || [attributes objectForKey:NSForegroundColorAttributeName] == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Attributes dictionary must contains NSFontAttributeName and NSForegroundColorAttributeName"];
    }

    _attributesText = attributes;
    
    [self determineHotWords];
}

- (void)setAttributes:(NSDictionary *)attributes hotWord:(STTweetHotWord)hotWord
{
    if ([attributes objectForKey:NSFontAttributeName] == nil || [attributes objectForKey:NSForegroundColorAttributeName] == nil)
    {
        [NSException raise:NSInvalidArgumentException format:@"Attributes dictionary must contains NSFontAttributeName and NSForegroundColorAttributeName"];
    }
    
    switch (hotWord)
    {
        case STTweetHandle:
            _attributesHandle = attributes;
            break;
        case STTweetHashtag:
            _attributesHashtag = attributes;
            break;
        case STTweetLink:
            _attributesLink = attributes;
            break;
        default:
            break;
    }
}

- (void)setLeftToRight:(BOOL)leftToRight
{
    _leftToRight = leftToRight;
    
    [self determineHotWords];
}

#pragma mark -
#pragma mark Getters

- (NSString *)text
{
    return _cleanText;
}

- (NSDictionary *)attributes
{
    return _attributesText;
}

- (NSDictionary *)attributesForHotWord:(STTweetHotWord)hotWord
{
    switch (hotWord)
    {
        case STTweetHandle:
            return _attributesHandle;
            break;
        case STTweetHashtag:
            return _attributesHashtag;
            break;
        case STTweetLink:
            return _attributesLink;
            break;
        default:
            break;
    }
}

- (BOOL)isLeftToRight
{    
    return _leftToRight;
}

#pragma mark -
#pragma mark UIView events

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesBegan:touches withEvent:event];
    
    _startTouchPoint = [[touches anyObject] locationInView:self];
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];
    
    UITouch *touch = event.allTouches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    
    if (fabs(_startTouchPoint.x - touchPoint.x) > 5 || fabs(_startTouchPoint.y - touchPoint.y) > 5)
    {
        [super touchesCancelled:touches withEvent:event];
        return;
    }
    
    if ([_locationsOfHotWords count] == 0)
    {
        [super touchesEnded:touches withEvent:event];
        return;
    }
    
    __block BOOL touchableWordNotFound = YES;
    
    [_locationsOfHotWords enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        CGRect touchZone = [obj CGRectValue];

        if (CGRectContainsPoint(touchZone, touchPoint))
        {
            NSLog(@"Found");
            
            //Stop search.
            touchableWordNotFound = NO;
            *stop = YES;
        }
     }];
    
    if (touchableWordNotFound)
    {
        [super touchesEnded:touches withEvent:event];
    }
    else
    {
        [super touchesCancelled:touches withEvent:event];
    }
}

@end