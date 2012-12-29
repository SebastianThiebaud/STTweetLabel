//
//  STViewController.h
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 12/15/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>

@class STTweetLabel;
@interface STViewController : UIViewController

@property (strong, nonatomic) STTweetLabel *tweetLabel;
@property (strong, nonatomic) IBOutlet UILabel *displayLabel;

@end
