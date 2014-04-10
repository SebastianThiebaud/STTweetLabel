//
//  STCustomizeCell.h
//  STTweetLabelExample
//
//  Created by Sean on 4/10/14.
//  Copyright (c) 2014 Sebastien Thiebaud. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "STTweetLabel.h"

@interface STCustomizeCell : UITableViewCell

@property (nonatomic, strong) UIView *cellView;
@property (nonatomic, strong) STTweetLabel *contentLabel;

@end
