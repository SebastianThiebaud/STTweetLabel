# STTweetLabel

A custom UILabel view controller for iOS with certain words tappable like Twitter (#Hashtag, @People and http://www.link.com/page)

![STTweetLabel screenshot](https://raw.github.com/SebastienThiebaud/STTweetLabel/master/screenshot.png "STTweetLabel Screenshot")

## Documentation

You need only 3 files:

- `STTweetLabel.h`
- `STTweetLabel.m`
- `STLinkProtocol.h`

Don't forget to implement STLinkProtocol and initialize the STTweetLabel's delegate in the view controller which manages your STTweetLabel (see the example in the project).

You can change the fonts and colors for the different words (#Hashtag/@People AND http://link.com) via the STTweetLabel attributes.

## Demo

Build and run the project in Xcode to see `STTweetLabel` in action. 


## Example Usage

``` objective-c
    STTweetLabel *tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(20.0, 60.0, 280.0, 200.0)];
    
    [tweetLabel setFont:[UIFont fontWithName:@"HelveticaNeue" size:17.0]];
    [tweetLabel setTextColor:[UIColor blackColor]];
    [tweetLabel setDelegate:self];
    [tweetLabel setText:@"Hi. This is a new tool for @you! Developed by->@SebThiebaud for #iPhone #ObjC... ;-) My GitHub page: https://t.co/pQXDoiYA"];
    [self.view addSubview:_tweetLabel];
```

When an user will click on a tappable word, the delegate method `- (void)tweetLinkClicked:(NSString *)link` will be call. The word clicked by the user is the parameter (NSString *)link.

## Credits

Inspired by the original Twitter applications.

## Contact

Sebastien Thiebaud

- http://github.com/SebastienThiebaud
- http://twitter.com/SebThiebaud

## License

STTweetLabel is available under the MIT license.

