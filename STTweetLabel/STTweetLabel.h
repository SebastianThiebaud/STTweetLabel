//
//  STTweetLabel.h
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 12/14/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>

#define DEPRECATED __attribute__ ((deprecated))

typedef enum {
    
    STLinkActionTypeAccount,
    STLinkActionTypeHashtag,
    STLinkActionTypeWebsite
    
} STLinkActionType;

typedef void(^STLinkCallbackBlock)(STLinkActionType actionType, NSString *link);

/*
 * Deprecated Delegate Callbacks.
 * Please use NSBlocks instead.
 */

@protocol STLinkProtocol <NSObject>

@optional
- (void)twitterAccountClicked:(NSString *)link DEPRECATED;
- (void)twitterHashtagClicked:(NSString *)link DEPRECATED;
- (void)websiteClicked:(NSString *)link        DEPRECATED;
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
@property (nonatomic, assign) float wordSpace;
@property (nonatomic, assign) float lineSpace;

@property (nonatomic, strong) id<STLinkProtocol> delegate DEPRECATED;

@property (nonatomic, copy) STLinkCallbackBlock callbackBlock;

@end
