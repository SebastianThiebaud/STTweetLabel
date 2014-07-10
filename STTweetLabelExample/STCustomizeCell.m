//
//  STCustomizeCell.m
//  STTweetLabelExample
//
//  Created by Sean on 4/10/14.
//  Copyright (c) 2014 Sebastien Thiebaud. All rights reserved.
//

#import "STCustomizeCell.h"

@implementation STCustomizeCell

@synthesize cellView;
@synthesize contentLabel;

- (id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier
{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        // Initialization code
        
        [self.contentView addSubview:[self drawCustomizeCellView]];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated
{
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

#pragma mark - 

- (UIView *)drawCustomizeCellView {
    cellView = [[UIView alloc] init];
    
    contentLabel = [[STTweetLabel alloc] init];
    contentLabel.numberOfLines = 0;
    contentLabel.textAlignment = NSTextAlignmentLeft;
    contentLabel.lineBreakMode = NSLineBreakByCharWrapping;
    
    [contentLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        NSArray *hotWords = @[@"Handle", @"Hashtag", @"Link"];
        
        NSLog(@"%@", [NSString stringWithFormat:@"%@ [%d,%d]: %@%@", hotWords[hotWord], (int)range.location, (int)range.length, string, (protocol != nil) ? [NSString stringWithFormat:@" *%@*", protocol] : @""]);
    }];
    
    [cellView addSubview:contentLabel];
    
    return cellView;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    CGSize sizeComment = [contentLabel suggestedFrameSizeToFitEntireStringConstraintedToWidth:[[UIScreen mainScreen] bounds].size.width - 20.0f];
    contentLabel.frame = CGRectMake(10.0f, 30.0f, [[UIScreen mainScreen] bounds].size.width - 20.0f, sizeComment.height);
    cellView.frame = CGRectMake(0.0f, 0.0f, [[UIScreen mainScreen] bounds].size.width, contentLabel.frame.size.height + 50.0f);
}

@end
