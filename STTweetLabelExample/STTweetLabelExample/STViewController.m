//
//  STViewController.m
//  STTweetLabel
//
//  Created by Sebastien Thiebaud on 09/29/13.
//  Copyright (c) 2013 Sebastien Thiebaud. All rights reserved.
//

#import "STViewController.h"
#import "STTweetLabel.h"

@interface STViewController ()

@property (strong) IBOutlet UILabel *displayLabel;

@end

@implementation STViewController

- (id)initWithNibName:(NSString *)nibNameOrNil bundle:(NSBundle *)nibBundleOrNil
{
    self = [super initWithNibName:nibNameOrNil bundle:nibBundleOrNil];
    
    if (self)
    {
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    STTweetLabel *tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(10.0, 60.0, 300.0, 160.0)];
    
    [tweetLabel setStoreBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        NSString *userDefaultsKey;
        switch (hotWord)
        {
            case STTweetHandle:
                userDefaultsKey = @"UserDefaultsHandleKey";
                break;
            case STTweetHashtag:
                userDefaultsKey = @"UserDefaultsHashtagKey";
                break;
            case STTweetLink:
                userDefaultsKey = @"UserDefaultsLinkKey";
                break;
            default:
                break;
        }
        NSData *userDefaultsData = [[NSUserDefaults standardUserDefaults] objectForKey:userDefaultsKey];
        NSMutableSet *userDefaultsSet = userDefaultsData ? [NSKeyedUnarchiver unarchiveObjectWithData:userDefaultsData] : [[NSMutableSet alloc] init];
        if (![userDefaultsSet containsObject:string])
        {
            [userDefaultsSet addObject:string];
            userDefaultsData = [NSKeyedArchiver archivedDataWithRootObject:userDefaultsSet];
            [[NSUserDefaults standardUserDefaults] setObject:userDefaultsData forKey:userDefaultsKey];
            [[NSUserDefaults standardUserDefaults] synchronize];
        }
    }];
    
    [tweetLabel setText:@"Hi. This is a new tool for @you! Developed by @SebThiebaud for #iPhone #ObjC... and #iOS7 ;-) My GitHub page: https://t.co/pQXDoiYA"];
    tweetLabel.textAlignment = NSTextAlignmentLeft;
    [self.view addSubview:tweetLabel];
    
    CGSize size = [tweetLabel suggestedFrameSizeToFitEntireStringConstraintedToWidth:tweetLabel.frame.size.width];
    CGRect frame = tweetLabel.frame;
    frame.size.height = size.height;
    tweetLabel.frame = frame;
    
    [tweetLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
        NSArray *hotWords = @[@"Handle", @"Hashtag", @"Link"];
        
        _displayLabel.text = [NSString stringWithFormat:@"%@ [%d,%d]: %@%@", hotWords[hotWord], (int)range.location, (int)range.length, string, (protocol != nil) ? [NSString stringWithFormat:@" *%@*", protocol] : @""];
    }];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
