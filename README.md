# STTweetLabel

A custom UILabel view controller for iOS with certain words tappable like Twitter (#Hashtag, @People and http://www.link.com/page)

![STTweetLabel screenshot](https://raw.github.com/SebastienThiebaud/STTweetLabel/master/screenshot.png "STTweetLabel Screenshot")

## Documentation

You need only 2 files:

- `STTweetLabel.h`
- `STTweetLabel.m`

You can change the fonts and colors for the different words (#Hashtag/@People AND http://link.com) via the `STTweetLabel` attributes.

## Demo

Build and run the project STTweetLabelExample in Xcode to see `STTweetLabel` in action. 


## Example Usage

``` objective-c
    STTweetLabel *tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 280.0, 200.0)];
    
    [tweetLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
    [tweetLabel setTextColor:[UIColor blackColor]];
    [tweetLabel setDelegate:self];
    [tweetLabel setText:@"Hi. This is a new tool for @you! Developed by->@SebThiebaud for #iPhone #ObjC... ;-) My GitHub page: https://t.co/pQXDoiYA"];
    [self.view addSubview:tweetLabel];
```

When an user will click on a tappable word, the delegate methods 
``` objective-c
- (void)twitterAccountClicked:(NSString *)link;
- (void)twitterHashtagClicked:(NSString *)link;
- (void)websiteClicked:(NSString *)link;
```

will be called. The word clicked by the user is the parameter `(NSString *)link`.

## Credits

Inspired by the original Twitter applications. Thanks to @TomGiana for disturbing me while I'm focused in my code!

And thanks to @max_k [http://github.com/maxkramer] for implementing NSBlocks for me! 

## Contact

Sebastien Thiebaud

- http://github.com/SebastienThiebaud
- http://twitter.com/SebThiebaud

## License

STTweetLabel is available under the MIT license.

