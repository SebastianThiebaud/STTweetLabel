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
    
    STTweetLabel *tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(5.0, 40.0, 310.0, 160.0)];
    [tweetLabel setText:@"Duis sollicitudin #auctor consectetur. Vestibulum a luctus nibh, a scelerisque @ipsum. https://blog.wikimedia.org/2013/10/03/the-hidden-wikipedia-a-view-from-2022/ Maecenas feugiat sodales semper."];
    [self.view addSubview:tweetLabel];
}

- (void)didReceiveMemoryWarning
{
    [super didReceiveMemoryWarning];

}

@end
