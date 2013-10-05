//
//  STViewController.h
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 09/29/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

@class STTweetLabel;

@interface STViewController : UIViewController

@property (strong, nonatomic) STTweetLabel *tweetLabel;
@property (strong, nonatomic) IBOutlet UILabel *displayLabel;

@end
