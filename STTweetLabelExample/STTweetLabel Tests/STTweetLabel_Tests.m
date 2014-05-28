//
//  STTweetLabel_Tests.m
//  STTweetLabel Tests
//
//  Created by Sebastien Thiebaud on 10/5/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import <XCTest/XCTest.h>

#import "STTweetLabel.h"

@interface STTweetLabel_Tests : XCTestCase

@property (strong) STTweetLabel *tweetLabel;

@end

@implementation STTweetLabel_Tests

- (void)setUp
{
    [super setUp];
    
    _tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(0.0, 0.0, 320.0, 200.0)];
}

- (void)tearDown
{
    [super tearDown];
}

#pragma clang diagnostic push
#pragma clang diagnostic ignored "-Wundeclared-selector"

- (NSArray *)hotWordsListForSampleText:(NSString *)text
{
    return [_tweetLabel performSelector:@selector(hotWordsList)];
}

#pragma clang diagnostic pop

- (void)initiateTestFromSample:(NSString *)text results:(NSArray *)results
{
    [_tweetLabel setText:text];
    NSArray *hotWords = [self hotWordsListForSampleText:text];
    
    XCTAssertEqual(results.count, hotWords.count, @"Number of hot words should be %ld but %ld was returned instead.", results.count, hotWords.count);
    
    if (results.count == hotWords.count)
    {
        int i = 0;
        
        for (NSDictionary *hotWord in hotWords)
        {
            XCTAssertEqual([[results[i] objectForKey:@"hotWord"] intValue], [[hotWord objectForKey:@"hotWord"] intValue], @"Hot word's type should be %d but %d was returned instead.", [[results[i] objectForKey:@"hotWord"] intValue], [[hotWord objectForKey:@"hotWord"] intValue]);
            XCTAssertEqualObjects([results[i] objectForKey:@"range"], [hotWord objectForKey:@"range"], @"Hot word's range should be %@ but %@ was returned instead: \"%@\" against \"%@\".", NSStringFromRange([[results[i] objectForKey:@"range"] rangeValue]), NSStringFromRange([[hotWord objectForKey:@"range"] rangeValue]), [text substringWithRange:[[results[i] objectForKey:@"range"] rangeValue]], [text substringWithRange:[[hotWord objectForKey:@"range"] rangeValue]]);
            
            
            if ([hotWord objectForKey:@"protocol"])
            {
                XCTAssertEqualObjects([results[i] objectForKey:@"protocol"], [hotWord objectForKey:@"protocol"], @"Link's protocol should be %@ but %@ was returned instead.", [results[i] objectForKey:@"protocol"], [hotWord objectForKey:@"protocol"]);
            }
            
            i++;
        }
    }
}

#pragma mark -
#pragma mark Text attributes

- (void)test_setAndGetAttributesForText_setAttributes_attributes
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    
    [_tweetLabel setAttributes:attributes];
    
    XCTAssertEqualObjects(attributes, _tweetLabel.attributes, @"Text attributes should be %@ but %@ was returned instead.", attributes, _tweetLabel.attributes);
}

- (void)test_setAndGetAttributesForHandle_setAttributes_attributes
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    
    [_tweetLabel setAttributes:attributes hotWord:STTweetHandle];
    
    XCTAssertEqualObjects(attributes, [_tweetLabel attributesForHotWord:STTweetHandle], @"Handle attributes should be %@ but %@ was returned instead.", attributes, [_tweetLabel attributesForHotWord:STTweetHandle]);
}

- (void)test_setAndGetAttributesForHashtag_setAttributes_attributes
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    
    [_tweetLabel setAttributes:attributes hotWord:STTweetHashtag];
    
    XCTAssertEqualObjects(attributes, [_tweetLabel attributesForHotWord:STTweetHashtag], @"Hashtag attributes should be %@ but %@ was returned instead.", attributes, [_tweetLabel attributesForHotWord:STTweetHashtag]);
}

- (void)test_setAndGetAttributesForLink_setAttributes_attributes
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    
    [_tweetLabel setAttributes:attributes hotWord:STTweetLink];
    
    XCTAssertEqualObjects(attributes, [_tweetLabel attributesForHotWord:STTweetLink], @"Link attributes should be %@ but %@ was returned instead.", attributes, [_tweetLabel attributesForHotWord:STTweetLink]);
}

- (void)test_setAndGetAttributesForText_setValidAttributes_exceptionNotThrown
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    
    XCTAssertNoThrowSpecificNamed([_tweetLabel setAttributes:attributes], NSException, NSInvalidArgumentException, @"Attributes dictionary contains NSFontAttributeName and NSForegroundColorAttributeName and shouldn't raise an exception.");
}

- (void)test_setAndGetAttributesForHandleHashtagLink_setValidAttributes_exceptionNotThrown
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor redColor], NSFontAttributeName: [UIFont fontWithName:@"HelveticaNeue" size:14.0]};
    
    XCTAssertNoThrowSpecificNamed([_tweetLabel setAttributes:attributes hotWord:0], NSException, NSInvalidArgumentException, @"Attributes dictionary contains NSFontAttributeName and NSForegroundColorAttributeName and shouldn't raise an exception.");
}

#pragma mark -
#pragma mark Text alignment

- (void)test_setAndGetTextAlignment_setTextAlignment_textAlignment
{
    _tweetLabel.textAlignment = NSTextAlignmentRight;
    
    XCTAssertEqual(NSTextAlignmentRight, _tweetLabel.textAlignment, @"Text alignment should be %d but %d was resturned instead.", (int)NSTextAlignmentRight, (int)_tweetLabel.textAlignment);
}

#pragma mark -
#pragma mark Valid protocols

- (void)test_setAndGetValidProtocols_setProtocols_protocols
{
    NSArray *protocols = @[@"http", @"http", @"ssh", @"ftp", @"smtp"];

    [_tweetLabel setValidProtocols:protocols];
    
    XCTAssertEqual(protocols.count, _tweetLabel.validProtocols.count, @"Number of valid protocols should be %d but %d was returned instead.", (int)protocols.count, (int)_tweetLabel.validProtocols.count);
    XCTAssertEqualObjects(protocols, _tweetLabel.validProtocols, @"Valid protocols should be %@ but %@ was returned instead.", protocols, _tweetLabel.validProtocols);
}

#pragma mark -
#pragma mark Writing direction

- (void)test_setAndGetWritingDirection_setLeftToRight_leftToRight
{
    [_tweetLabel setLeftToRight:YES];
    
    XCTAssertEqual(YES, _tweetLabel.leftToRight, @"Writing direction (left to right) should be %d but %d was returned instead.", YES, _tweetLabel.leftToRight);
}

- (void)test_setAndGetWritingDirection_setRightToLeft_rightToLeft
{
    [_tweetLabel setLeftToRight:NO];
    
    XCTAssertEqual(NO, _tweetLabel.leftToRight, @"Writing direction (left to right) should be %d but %d was returned instead.", NO, _tweetLabel.leftToRight);
}

#pragma mark -
#pragma mark Text selection

- (void)test_setAndGetTextSelectable_setTextSelectable_textSelectable
{
    [_tweetLabel setTextSelectable:YES];
    
    XCTAssertEqual(YES, _tweetLabel.textSelectable, @"Text selectable should be %d but %d was returned instead.", YES, _tweetLabel.textSelectable);
}

- (void)test_setAndGetTextSelectable_setTextNotSelectable_textNotSelectable
{
    [_tweetLabel setTextSelectable:NO];
    
    XCTAssertEqual(NO, _tweetLabel.textSelectable, @"Text selectable should be %d but %d was returned instead.", NO, _tweetLabel.textSelectable);
}

- (void)test_setAndGetSelectionColor_setSelectionColor_selectionColor
{
    UIColor *redColor = [UIColor redColor];
    
    [_tweetLabel setSelectionColor:redColor];
    
    XCTAssertEqualObjects(redColor, _tweetLabel.selectionColor, @"Selection color should be %@ but %@ was returned instead.", redColor, _tweetLabel.selectionColor);
}

#pragma mark -
#pragma mark Data 

- (void)test_setTextAndGetHotWords_setTextWithSampleDemoText_hotWords
{
    NSString *string = @"Hi. This is a new tool for @you! Developed by @SebThiebaud for #iPhone #ObjC... and #iOS7 ;-) My GitHub page: https://t.co/pQXDoiYA";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetHandle), @"range": [NSValue valueWithRange:NSMakeRange(27, 4)]},
                         @{@"hotWord": @(STTweetHandle), @"range": [NSValue valueWithRange:NSMakeRange(46, 12)]},
                         @{@"hotWord": @(STTweetHashtag), @"range": [NSValue valueWithRange:NSMakeRange(63, 7)]},
                         @{@"hotWord": @(STTweetHashtag), @"range": [NSValue valueWithRange:NSMakeRange(71, 5)]},
                         @{@"hotWord": @(STTweetHashtag), @"range": [NSValue valueWithRange:NSMakeRange(84, 5)]},
                         @{@"hotWord": @(STTweetLink), @"range": [NSValue valueWithRange:NSMakeRange(110, 21)], @"protocol": @"https"}
                         ];
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithNoHotWords_hotWords
{
    NSString *string = @"This is a sample test.";
    NSArray *results = nil;
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneHandle_hotWords
{
    NSString *string = @"This is a sample test with @handle.";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetHandle), @"range": [NSValue valueWithRange:NSMakeRange(27, 7)]}
                         ];
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneInvalidHandle_hotWords
{
    NSString *string = @"This is a sample test with username@email.com";
    NSArray *results = nil;
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneDotAndHandle_hotWords
{
    NSString *string = @"This is a sample test. .@Ok";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetHandle), @"range": [NSValue valueWithRange:NSMakeRange(24, 3)]}
                         ];
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneLink_hotWords
{
    NSString *string = @"This is a sample test with http://www.link.com/";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetLink), @"range": [NSValue valueWithRange:NSMakeRange(27, 20)], @"protocol": @"http"}
                         ];
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneLinkHttps_hotWords
{
    NSString *string = @"This is a sample test with https://www.link.com/";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetLink), @"range": [NSValue valueWithRange:NSMakeRange(27, 21)], @"protocol": @"https"}
                         ];
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneHandleAndOneHashtag_hotWords
{
    NSString *string = @"This is a sample test with @handle and #hashtag.";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetHandle), @"range": [NSValue valueWithRange:NSMakeRange(27, 7)]},
                         @{@"hotWord": @(STTweetHashtag), @"range": [NSValue valueWithRange:NSMakeRange(39, 8)]}
                         ];
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneHashtagWithInvalidSpecialCharacters_hotWords
{
    NSString *string = @"This is a sample test with #hashtag-special.";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetHashtag), @"range": [NSValue valueWithRange:NSMakeRange(27, 8)]}
                         ];
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneHashtagWithValidSpecialCharacters_hotWords
{
    NSString *string = @"This is a sample test with #hashtag_special.";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetHashtag), @"range": [NSValue valueWithRange:NSMakeRange(27, 16)]}
                         ];
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneHandleAndOneHashtagAndOneSimpleLink_hotWords
{
    NSString *string = @"This is a sample test with @handle, #hashtag and http://link.com/hello-buddy.";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetHandle), @"range": [NSValue valueWithRange:NSMakeRange(27, 7)]},
                         @{@"hotWord": @(STTweetHashtag), @"range": [NSValue valueWithRange:NSMakeRange(36, 8)]},
                         @{@"hotWord": @(STTweetLink), @"range": [NSValue valueWithRange:NSMakeRange(49, 27)], @"protocol": @"http"}
                         ];
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneLinkWithSpecialCharacters_hotWords
{
    NSString *string = @"This is a sample test with http://www.link.com/directory/path/resources?timestamp=10303000&handle=dfhj[]";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetLink), @"range": [NSValue valueWithRange:NSMakeRange(27, 75)], @"protocol": @"http"}
                         ];
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneEncapsulateLinkWithSpecialCharacters_hotWords
{
    NSString *string = @"This is a sample test with (http://www.link.com/directory/path/resources?timestamp=10303000&handle=dfhj()&next(arg))";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetLink), @"range": [NSValue valueWithRange:NSMakeRange(28, 87)], @"protocol": @"http"}
                         ];
    
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOneLinkWithNoProtocol_hotWords
{
    NSString *string = @"This is a sample test with www.example.com/something";
    NSArray *results = @[
                         @{@"hotWord": @(STTweetLink), @"range": [NSValue valueWithRange:NSMakeRange(27, 25)], @"protocol": @"http"}
                         ];
    [self initiateTestFromSample:string results:results];
}

- (void)test_setTextAndGetHotWords_setTextWithOnlyAtSymbol_hotWords
{
    NSString *string = @"@";
    NSArray *results = nil;
    
    [self initiateTestFromSample:string results:results];
}


- (void)test_setTextAndGetHotWords_setTextWithOnlyHashtagSymbol_hotWords
{
    NSString *string = @"#";
    NSArray *results = nil;
    
    [self initiateTestFromSample:string results:results];
}

@end
