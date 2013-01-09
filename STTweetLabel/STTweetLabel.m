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

    // Regex to catch newline
    NSRegularExpression *regexNewLine = [NSRegularExpression regularExpressionWithPattern:@">newLine" options:NSRegularExpressionCaseInsensitive error:&error];
    
    BOOL loopWord = NO;
    
    for (NSString *wordArray in words)
    {
        NSString *word = @"";
        NSMutableString *alreadyPrintedWord = [[NSMutableString alloc] init];
        
        do
        {
            word = [wordArray substringFromIndex:[alreadyPrintedWord length]];
            
            CGSize sizeWord = [word sizeWithFont:self.font];
            
            if (sizeWord.width <= rect.size.width)
            {
                loopWord = NO;
            }
            
            // If the word is larger than the container's size
            while (sizeWord.width > rect.size.width)
            {
                NSString *cutWord = [self cutTheString:word atPoint:drawPoint];
                
                [alreadyPrintedWord appendString:cutWord];
                
                word = cutWord;
                sizeWord = [word sizeWithFont:self.font];
                
                loopWord = YES;
            }
            
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
                // Shadow case
                if (self.shadowColor != NULL)
                {
                    [self.shadowColor set];
                    [preCharacters drawAtPoint:CGPointMake(drawPoint.x + self.shadowOffset.width, drawPoint.y + self.shadowOffset.height) withFont:self.font];
                }

                [self.textColor set];
                CGSize sizePreCharacters = [preCharacters sizeWithFont:self.font];
                [preCharacters drawAtPoint:drawPoint withFont:self.font];
                        
                drawPoint = CGPointMake(drawPoint.x + sizePreCharacters.width, drawPoint.y);
            }
            
            // Draw the touchable word
            if (![wordCharacters isEqualToString:@""])
            {            
                // Shadow case
                if (self.shadowColor != NULL)
                {
                    [self.shadowColor set];
                    [wordCharacters drawAtPoint:CGPointMake(drawPoint.x + self.shadowOffset.width, drawPoint.y + self.shadowOffset.height) withFont:self.font];
                }

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
                NSTextCheckingResult *matchNewLine = [regexNewLine firstMatchInString:postCharacters options:0 range:NSMakeRange(0, [postCharacters length])];

                // If a newline is match
                if (matchNewLine)
                {
                    // Shadow case
                    if (self.shadowColor != NULL)
                    {
                        [self.shadowColor set];
                        [[postCharacters substringToIndex:matchNewLine.range.location] drawAtPoint:CGPointMake(drawPoint.x + self.shadowOffset.width, drawPoint.y + self.shadowOffset.height) withFont:self.font];
                    }

                    [self.textColor set];

                    [[postCharacters substringToIndex:matchNewLine.range.location] drawAtPoint:drawPoint withFont:self.font];
                    drawPoint = CGPointMake(0.0, drawPoint.y + sizeWord.height);
     
                    // Shadow case
                    if (self.shadowColor != NULL)
                    {
                        [self.shadowColor set];
                        [[postCharacters substringFromIndex:matchNewLine.range.location + matchNewLine.range.length] drawAtPoint:CGPointMake(drawPoint.x + self.shadowOffset.width, drawPoint.y + self.shadowOffset.height) withFont:self.font];
                    }
                    
                    [self.textColor set];

                    [[postCharacters substringFromIndex:matchNewLine.range.location + matchNewLine.range.length] drawAtPoint:drawPoint withFont:self.font];
                    drawPoint = CGPointMake(drawPoint.x + [[postCharacters substringFromIndex:matchNewLine.range.location + matchNewLine.range.length] sizeWithFont:self.font].width, drawPoint.y);
                }
                else
                {
                    // Shadow case
                    if (self.shadowColor != NULL)
                    {
                        [self.shadowColor set];
                        [postCharacters drawAtPoint:CGPointMake(drawPoint.x + self.shadowOffset.width, drawPoint.y + self.shadowOffset.height) withFont:self.font];
                    }
                    
                    [self.textColor set];
                    CGSize sizePostCharacters = [postCharacters sizeWithFont:self.font];
                    [postCharacters drawAtPoint:drawPoint withFont:self.font];
                    
                    drawPoint = CGPointMake(drawPoint.x + sizePostCharacters.width, drawPoint.y);
                }
            }
            
            if (!loopWord)
            {
                drawPoint = CGPointMake(drawPoint.x + sizeSpace.width, drawPoint.y);
            }
        } while (loopWord);
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
                
                if (_callbackBlock != NULL) {
                    
                    _callbackBlock(STLinkActionTypeAccount, url);
                    
                }
                
            }
            else if ([[touchWords objectAtIndex:idx] hasPrefix:@"#"])
            {
                //Twitter hashtag clicked
                if ([_delegate respondsToSelector:@selector(twitterHashtagClicked:)]) {
                    [_delegate twitterHashtagClicked:url];
                }
                
                if (_callbackBlock != NULL) {
                    
                    _callbackBlock(STLinkActionTypeHashtag, url);
                    
                }
            }
            else if ([[touchWords objectAtIndex:idx] hasPrefix:@"http"])
            {
                
                //Twitter hashtag clicked
                if ([_delegate respondsToSelector:@selector(websiteClicked:)]) {
                    [_delegate websiteClicked:url];
                }
                
                if (_callbackBlock != NULL) {
                    
                    _callbackBlock(STLinkActionTypeWebsite, url);
                    
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
    
    // Newline character (if you have a better idea...)
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"\n"  withString:@">newLine"];
   
    // Extras
    htmlString = [htmlString stringByReplacingOccurrencesOfString:@"<3" withString:@"♥"];
    
    return htmlString;
}

// Cut a string to display just the beginning in the container
- (NSString *)cutTheString:(NSString *)word atPoint:(CGPoint)drawPoint
{
    NSString *substring;
    
    for (int i = 1; i < [word length]; i++)
    {
        substring = [word substringToIndex:[word length] - i];
        CGSize sizeSubstring = [substring sizeWithFont:self.font];
        
        if (drawPoint.x + sizeSubstring.width <= self.frame.size.width)
        {
            break;
        }
    }
    
    return substring;
}

@end
