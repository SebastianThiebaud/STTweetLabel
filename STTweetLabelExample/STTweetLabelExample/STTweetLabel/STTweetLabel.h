//
//  STTweetLabel.h
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 12/14/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol STLinkProtocol <NSObject>

@optional
- (void)twitterAccountClicked:(NSString *)link;
- (void)twitterHashtagClicked:(NSString *)link;
- (void)websiteClicked:(NSString *)link;

@end

@interface STTweetLabel : UILabel
{
    NSMutableArray *touchLocations;
    NSMutableArray *touchWords;
}

@property (nonatomic, strong) UIFont *fontLink;
@property (nonatomic, strong) UIFont *fontHashtag;
@property (nonatomic, strong) UIColor *colorLink;
@property (nonatomic, strong) UIColor *colorHashtag;

@property (nonatomic, strong) id<STLinkProtocol> delegate;

@end
