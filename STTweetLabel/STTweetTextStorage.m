//
//  STTweetTextStorage.m
//  STTweetLabelExample
//
//  Created by Sebastien Thiebaud on 10/5/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "STTweetTextStorage.h"

@implementation STTweetTextStorage
{
    NSMutableAttributedString *_backingStore;
}

- (id)init
{
    self = [super init];
    
    if (self)
    {
        _backingStore = [[NSMutableAttributedString alloc] init];
    }
    
    return self;
}

- (NSString *)string
{
    return [_backingStore string];
}

- (NSDictionary *)attributesAtIndex:(NSUInteger)location effectiveRange:(NSRangePointer)range
{
    return [_backingStore attributesAtIndex:location effectiveRange:range];
}

- (NSAttributedString *)attributedString
{
    return _backingStore;
}

- (void)setAttributes:(NSDictionary *)attrs range:(NSRange)range
{
    [self beginEditing];
    [_backingStore setAttributes:attrs range:range];
    [self edited:NSTextStorageEditedAttributes range:range changeInLength:0];
    [self endEditing];
}

- (void)replaceCharactersInRange:(NSRange)range withString:(NSString *)string
{
    [self beginEditing];
    [_backingStore replaceCharactersInRange:range withString:string];
    [self edited:(NSTextStorageEditedCharacters|NSTextStorageEditedAttributes) range:range changeInLength:string.length - range.length];
    [self endEditing];
}

@end
