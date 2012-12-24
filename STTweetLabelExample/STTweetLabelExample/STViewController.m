//
//  STViewController.m
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 12/15/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

#import "STViewController.h"

#import "STTweetLabel.h"

@interface STViewController ()

@end

@implementation STViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    if (self) {
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Do any additional setup after loading the view from its nib.

    _tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 280.0, 200.0)];
    
    [_tweetLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
    [_tweetLabel setTextColor:[UIColor blackColor]];
    [_tweetLabel setDelegate:self];
    [_tweetLabel setText:@"Hi. This is a new tool for @you! Developed by->@SebThiebaud for #iPhone #ObjC... ;-)\nMy GitHub page: https://t.co/pQXDoiYA"];
    [self.view addSubview:_tweetLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark -
#pragma mark STLink Protocol

- (void)twitterAccountClicked:(NSString *)link {

    NSString *string = [NSString stringWithFormat:@"Twitter account:\n%@", link];
    [_displayLabel setText:string];

}
- (void)twitterHashtagClicked:(NSString *)link {

    NSString *string = [NSString stringWithFormat:@"Twitter hashtag:\n%@", link];
    [_displayLabel setText:string];

}
- (void)websiteClicked:(NSString *)link {

    NSString *string = [NSString stringWithFormat:@"Website:\n%@", link];
    [_displayLabel setText:string];
    
}

@end
