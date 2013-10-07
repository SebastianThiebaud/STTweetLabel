//
//  STTweetTextStorage.h
//  STTweetLabelExample
//
//  Created by Sebastien Thiebaud on 10/5/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface STTweetTextStorage : NSTextStorage

- (NSAttributedString *)attributedString;

- (void)addAttributes:(NSDictionary *)attrs range:(NSRange)range;
- (void)removeAttribute:(NSString *)name range:(NSRange)range;

@end
