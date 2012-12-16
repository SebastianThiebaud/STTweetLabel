//
//  TXTweetCellProtocol.h
//  TweeXor
//
//  Created by Sebastien Thiebaud on 12/15/12.
//  Copyright (c) 2012 Sebastien Thiebaud. All rights reserved.
//

@protocol STLinkProtocol <NSObject>

@required
- (void)tweetLinkClicked:(NSString *)link;

@end