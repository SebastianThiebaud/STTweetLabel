//
//  STTweetLabel.h
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 12/14/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum {
    STLinkActionTypeAccount,
    STLinkActionTypeHashtag,
    STLinkActionTypeWebsite
} STLinkActionType;

typedef void(^STLinkCallbackBlock)(STLinkActionType actionType, NSString *link);



/**
 The STLinkProtocol protocol is adopted by an object that receives the user interactions for a STTweetLabel.
 */

@protocol STLinkProtocol <NSObject>

@optional

/**
 Tells the delegate that the specified @Mention is now selected.
 @param link The mention
 */
- (void)twitterAccountClicked:(NSString *)link __attribute__ ((deprecated));

/**
 Tells the delegate that the specified #Hashtag is now selected.
 @param link The hashtag
 */
- (void)twitterHashtagClicked:(NSString *)link __attribute__ ((deprecated));

/**
 Tells the delegate that the specified link is now selected.
 @param link The web link
 */
- (void)websiteClicked:(NSString *)link __attribute__ ((deprecated));
@end



typedef enum {
    STVerticalAlignmentTop,
    STVerticalAlignmentMiddle,
    STVerticalAlignmentBottom
} STVerticalAlignment;

typedef enum {
    STHorizontalAlignmentLeft,
    STHorizontalAlignmentCenter,
    STHorizontalAlignmentRight
} STHorizontalAlignment;



/**
 A custom UILabel view controller for iOS with certain words tappable like Twitter (#Hashtag, @People and http://www.link.com/page)
 */
@interface STTweetLabel : UILabel
{
    NSMutableArray *sizeLines;
    
    NSMutableArray *touchLocations;
    NSMutableArray *touchWords;
}



/** @name Customizing the Text */

/**
 The font of the different links.
 
 The default value for this property is the font of the text.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, strong) UIFont *fontLink;

/**
 The font of the different hashtags and mentions.
 
 The default value for this property is the font of the text.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, strong) UIFont *fontHashtag;

/**
 The color of the different links.
 
 The default value for this property is `RGB(170,170,170)`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, strong) UIColor *colorLink;

/**
 The color of the different hashtags and mentions.
 
 The default value for this property is `RGB(129,171,193)`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, strong) UIColor *colorHashtag;

/**
 The color of the shadow text.
 
 The default value for this property is `RGB(0,0,0)`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, strong) UIColor *shadowColor;

/**
 The size of the shadow text.
 
 The default value for this property is `CGSizeZero`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, assign) CGSize shadowOffset;



/** @name Configuring the Spaces and Alignments */

/**
 The space between each word.
 
 The default value for this property is `0`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, assign) float wordSpace;

/**
 The space between each line.
 
 The default value for this property is `0`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, assign) float lineSpace;

/**
 The horizontal alignment of the text.
 
 The default value for this property is `STHorizontalAlignmentLeft`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, assign) STHorizontalAlignment horizontalAlignment;

/**
 The vertical alignment of the text.
 
 The default value for this property is `STVerticalAlignmentTop`.
 
 @warning You must specify a value for this parameter before `setText:`
 */
@property (nonatomic, assign) STVerticalAlignment verticalAlignment;



/** @name Managing the Delegate and Callback Block */

/**
 The object that acts as the delegate of the receiving tweet label view. (Deprecated in 2.0. Use callbackBlock instead.)
 
 The delegate must adopt the STLinkProtocol protocol.
 */
@property (nonatomic, strong) id<STLinkProtocol> delegate __attribute__ ((deprecated));

/**
 The block called when an user interaction is caught
 
 You can declare a STLinkCallbackBlock with `void(^STLinkCallbackBlock)(STLinkActionType actionType, NSString *link);`:
 
     STLinkCallbackBlock callbackBlock = ^(STLinkActionType actionType, NSString *link) {
        // Do something...
     };
 */
@property (nonatomic, copy) STLinkCallbackBlock callbackBlock;

@end
