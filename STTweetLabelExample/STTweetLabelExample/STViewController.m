//
//  STViewController.m
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 09/29/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "STViewController.h"
#import "STTweetLabel.h"
#import "STTableViewController.h"

@interface STViewController ()

@property (strong) IBOutlet UILabel *displayLabel;

@end

@implementation STViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil {
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    
    STTweetLabel *tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(10.0, 60.0, 300.0, 160.0)];
    [tweetLabel setText:@"Hi. This is a new tool for @you! Developed by @SebThiebaud for #iPhone #ObjC... and #iOS7 ;-) My GitHub page: Https://t.co/pQXDoiYA"];
    tweetLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tweetLabel];
    
    CGSize size = [tweetLabel suggestedFrameSizeToFitEntireStringConstraintedToWidth:tweetLabel.frame.size.width];
    CGRect frame = tweetLabel.frame;
    frame.size.height = size.height;
    tweetLabel.frame = frame;
    
    [tweetLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        NSArray *hotWords = @[@"Handle", @"Hashtag", @"Link"];
        
        _displayLabel.text = [NSString stringWithFormat:@"%@ [%d,%d]: %@%@", hotWords[hotWord], (int)range.location, (int)range.length, string, (protocol != nil) ? [NSString stringWithFormat:@" *%@*", protocol] : @""];
        
        NSLog(@"%@", [NSString stringWithFormat:@"%@ [%d,%d]: %@%@", hotWords[hotWord], (int)range.location, (int)range.length, string, (protocol != nil) ? [NSString stringWithFormat:@" *%@*", protocol] : @""]);
    }];
    
    UIButton *btn = [UIButton buttonWithType:UIButtonTypeRoundedRect];
    CGRect rect = CGRectMake(10.0f, 360.0f, 300.0f, 60.0f);
    btn.frame = rect;
    btn.backgroundColor = [UIColor colorWithRed:30/255.0 green:200/255.0 blue:125/255.0 alpha:1.0];
    [btn setTitle:@"Customize Table View Cells for UITableView" forState:UIControlStateNormal];
    [btn addTarget:self action:@selector(customizeTableView) forControlEvents:UIControlEventTouchDown];
    [self.view addSubview:btn];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

#pragma mark - 

- (void)customizeTableView {
    [self presentViewController:[[STTableViewController alloc] init] animated:YES completion:nil];
}

@end
