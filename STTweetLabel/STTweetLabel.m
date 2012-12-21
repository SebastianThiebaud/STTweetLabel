//
//  STTweetLabel.m
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 12/14/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import "STTweetLabel.h"

@implementation STTweetLabel

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        // Set the basic properties
        [self setBackgroundColor:[UIColor clearColor]];
        [self setUserInteractionEnabled:YES];
        [self setNumberOfLines:0];
        [self setLineBreakMode:NSLineBreakByWordWrapping];
        
        // Alloc and init the arrays which stock the touchable words and their location
        touchLocations = [[NSMutableArray alloc] init];
        touchWords = [[NSMutableArray alloc] init];
        
        // Init touchable words colors
        _colorHashtag = [UIColor colorWithWhite:170.0/255.0 alpha:1.0];
        _colorLink = [UIColor colorWithRed:129.0/255.0 green:171.0/255.0 blue:193.0/255.0 alpha:1.0];
    }
    return self;
}

- (void)drawTextInRect:(CGRect)rect
{
    if (_fontHashtag == nil)
    {
        _fontHashtag = self.font;
    }
    
    if (_fontLink == nil)
    {
        _fontLink = self.font;
    }
    
    [touchLocations removeAllObjects];
    [touchWords removeAllObjects];
    
    // Separate words by spaces and lines
    NSArray *words = [[self htmlToText:self.text] componentsSeparatedByCharactersInSet:[NSCharacterSet whitespaceAndNewlineCharacterSet]];
    
    // Init a point which is the reference to draw words
    CGPoint drawPoint = CGPointMake(0.0, 0.0);
    // Calculate the size of a space with the actual font
    CGSize sizeSpace = [@" " sizeWithFont:self.font constrainedToSize:rect.size lineBreakMode:self.lineBreakMode];

    [self.textColor set];

    // Regex to catch @mention #hashtag and link http(s)://
    NSError *error;
    NSRegularExpression *regex = [NSRegularExpression regularExpressionWithPattern:@"((@|#)([A-Z0-9a-z(é|ë|ê|è|à|â|ä|á|ù|ü|û|ú|ì|ï|î|í)_]+))|(http(s)?://([A-Z0-9a-z._-]*(/)?)*)" options:NSRegularExpressionCaseInsensitive error:&error];

    for (NSString *word in words)
    {
        CGSize sizeWord = [word sizeWithFont:self.font];
        
        // Test if the new word must be in a new line
        if (drawPoint.x + sizeWord.width > rect.size.width)
        {
            drawPoint = CGPointMake(0.0, drawPoint.y + sizeWord.height);
        }
        
        NSTextCheckingResult *match = [regex firstMatchInString:word options:0 range:NSMakeRange(0, [word length])];
        
        // Dissolve the word (for example a hashtag: #youtube!, we want only #youtube)
        NSString *preCharacters = [word substringToIndex:match.range.location];
        NSString *wordCharacters = [word substringWithRange:match.range];
        NSString *postCharacters = [word substringFromIndex:match.range.location + match.range.length];
        
        // Draw the prefix of the word (if it has a prefix)
        if (![preCharacters isEqualToString:@""])
        {
            [self.textColor set];
            CGSize sizePreCharacters = [preCharacters sizeWithFont:self.font];
            [preCharacters drawAtPoint:drawPoint withFont:self.font];
            drawPoint = CGPointMake(drawPoint.x + sizePreCharacters.width, drawPoint.y);
        }
        
        // Draw the touchable word
        if (![wordCharacters isEqualToString:@""])
        {
            // Set the color for mention/hashtag OR weblink
            if ([wordCharacters hasPrefix:@"#"] || [wordCharacters hasPrefix:@"@"])
            {
                [_colorHashtag set];
            }
            else if ([wordCharacters hasPrefix:@"http"])
            {
                [_colorLink set];
            }
            
            CGSize sizeWordCharacters = [wordCharacters sizeWithFont:self.font];
            [wordCharacters drawAtPoint:drawPoint withFont:self.font];
            
            // Stock the touchable zone
            [touchWords addObject:wordCharacters];
            [touchLocations addObject:[NSValue valueWithCGRect:CGRectMake(drawPoint.x, drawPoint.y, sizeWordCharacters.width, sizeWordCharacters.height)]];
            
            drawPoint = CGPointMake(drawPoint.x + sizeWordCharacters.width, drawPoint.y);
        }
        
        // Draw the suffix of the word (if it has a suffix) else the word is not touchable
        if (![postCharacters isEqualToString:@""])
        {
            [self.textColor set];
            CGSize sizePostCharacters = [postCharacters sizeWithFont:self.font];
            [postCharacters drawAtPoint:drawPoint withFont:self.font];
            drawPoint = CGPointMake(drawPoint.x + sizePostCharacters.width, drawPoint.y);
        }
        
        drawPoint = CGPointMake(drawPoint.x + sizeSpace.width, drawPoint.y);
    }
}
    
- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = event.allTouches.anyObject;
    CGPoint touchPoint = [touch locationInView:self];
    
    [touchLocations enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop)
    {
        CGRect touchZone = [obj CGRectValue];
        
        if (CGRectContainsPoint(touchZone, touchPoint))
        {
            //A touchable word is found
            
            NSString *url = [touchWords objectAtIndex:idx];
            
            if ([[touchWords objectAtIndex:idx] hasPrefix:@"@"])
            {
                //Twitter account clicked
                if ([_delegate respondsToSelector:@selector(twitterAccountClicked:)]) {
                    [_delegate twitterAccountClicked:url];
                }
            }
            else if ([[touchWords objectAtIndex:idx] hasPrefix:@"#"])
            {
                //Twitter hashtag clicked
                if ([_delegate respondsToSelector:@selector(twitterHashtagClicked:)]) {
                    [_delegate twitterHashtagClicked:url];
                }
            }
            else if ([[touchWords objectAtIndex:idx] hasPrefix:@"http"])
            {
                
                //Twitter hashtag clicked
                if ([_delegate respondsToSelector:@selector(websiteClicked:)]) {
                    [_delegate websiteClicked:url];
                }
            }
        }
    }];
}

- (NSString *)htmlToText:(NSString *)htmlString
{
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&amp;"  withString:@"&"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&lt;"  withString:@"<"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&gt;"  withString:@">"];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&quot;" withString:@""""];
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"&#039;"  withString:@"'"];
    
    // Extras
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<3" withString:@"♥"];
    
    return htmlString;
}

@end
