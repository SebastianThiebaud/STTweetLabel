[![Platform](https://img.shields.io/cocoapods/p/STTweetLabel.svg?style=flat)](http://cocoadocs.org/docsets/STTweetLabel)
[![Version](https://img.shields.io/cocoapods/v/STTweetLabel.svg?style=flat)](http://cocoadocs.org/docsets/STTweetLabel)
[![CI](http://img.shields.io/travis/SebastienThiebaud/STTweetLabel.svg?style=flat)](https://travis-ci.org/SebastienThiebaud/STTweetLabel)
[![License](https://img.shields.io/cocoapods/l/STTweetLabel.svg?style=flat)](http://cocoadocs.org/docsets/STTweetLabel)

# STTweetLabel

A custom UILabel for iOS with certain words tappable like Twitter (#Hashtag, @Handle and links).

![STTweetLabel screenshot](https://raw.github.com/SebastienThiebaud/STTweetLabel/master/screenshot.png "STTweetLabel Screenshot")

## Installation

Please use CocoaPods and include STTweetLabel in your Podfile.

Important: STTweetLabel 3.0 is based on TextKit and is only compatible with iOS 7 and above.

## Demo

Build and run the project STTweetLabelExample in Xcode to see `STTweetLabel` in action. 

## Example Usage

``` objective-c
STTweetLabel *tweetLabel = [[STTweetLabel alloc] initWithFrame:CGRectMake(10.0, 60.0, 300.0, 160.0)];
[tweetLabel setText:@"Hi. This is a new tool for @you! Developed by @SebThiebaud for #iPhone #ObjC... and #iOS7 ;-) My GitHub page: https://t.co/pQXDoiYA"];
[self.view addSubview:tweetLabel];
```

Don't forget to implement the `detectionBlock`. Without implementing this block, you won't be able to detect if somebody has clicked on the hashtag, handle or even a link.
Blocks are easy. All you need to do is add a few lines of code:

``` objective-c
[tweetLabel setDetectionBlock:^(STTweetHotWord hotWord, NSString *string, NSString *protocol, NSRange range) {
    // Do something
}];
```
    
## Properties

- `NSString *text`: The text to display.
- `NSArray *validProtocols`: All valid protocols for link (by default: `@[@"http", @"https"]`).
- `BOOL leftToRight`: Writing direction (by default: `YES`).
- `BOOL textSelectable`: Allows the user to select the text (by default: `YES`).
- `UIColor *selectionColor`: If `BOOL textSelectable` is enabled, it's the color of the selection's background (by default: `[UIColor colorWithWhite:0.9 alpha:1.0]`).
- `NSTextAlignment textAlignment`: Text alignment (by default: `NSTextAlignmentLeft`).

## Methods

**The two following methods refresh the component. That means you should only set the attributes at the initialization of your STTweetLabel instance.**

- `-[STTweetLabel setAttributes:(NSDictionary *)attributes]`: Dictionary with attributes for all text.
- `-[STTweetLabel setAttributes:(NSDictionary *)attributes hotWord:(STTweetHotWord)hotWord]`: Dictionary with attributes for specific STTweetHotWord.
- `-[STTweetLabel suggestedFrameSizeToFitEntireStringConstraintedToWidth:(CGFloat)width`: Returns the CGSize calculated for the text submitted.

## Credits

Inspired by the original Twitter application.

## Contact

Sebastien Thiebaud

- http://github.com/SebastienThiebaud
- http://twitter.com/SebThiebaud

## License

STTweetLabel is available under the MIT license.

