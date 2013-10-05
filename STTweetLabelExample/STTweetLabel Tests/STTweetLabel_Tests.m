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

- (void)test_setAndGetAttributesForText_setInvalidAttributes_exceptionThrown
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor redColor]};
    
    XCTAssertThrowsSpecificNamed([_tweetLabel setAttributes:attributes], NSException, NSInvalidArgumentException, @"Attributes dictionary must contains NSFontAttributeName and NSForegroundColorAttributeName");
}

- (void)test_setAndGetAttributesForHandleHashtagLink_setInvalidAttributes_exceptionThrown
{
    NSDictionary *attributes = @{NSForegroundColorAttributeName: [UIColor redColor]};
    
    XCTAssertThrowsSpecificNamed([_tweetLabel setAttributes:attributes hotWord:0], NSException, NSInvalidArgumentException, @"Attributes dictionary must contains NSFontAttributeName and NSForegroundColorAttributeName");
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

@end
