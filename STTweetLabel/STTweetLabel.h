//
//  STTweetLabel.h
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 09/29/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

typedef enum {
    STTweetHandle = 1,
    STTweetHashtag,
    STTweetLink
} STTweetHotWord;

@interface STTweetLabel : UILabel

@property (nonatomic, strong) UIColor *handleColor;
@property (nonatomic, strong) UIColor *hashtagColor;
@property (nonatomic, strong) UIColor *linkColor;

- (void)setText:(NSString *)text;
- (NSString *)text;

- (void)setTextColor:(UIColor *)textColor;
- (UIColor *)textColor;

@end
