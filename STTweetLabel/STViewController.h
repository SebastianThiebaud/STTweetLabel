//
//  STViewController.h
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 12/15/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>

#import "STTweetLabel.h"

@interface STViewController : UIViewController <STLinkProtocol>

@property (strong, nonatomic) STTweetLabel *tweetLabel;
@property (strong, nonatomic) IBOutlet UILabel *displayLabel;

@end
