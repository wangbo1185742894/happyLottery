//
//  LotteryBaseView.h
//  Lottery
//
//  Created by AMP on 5/19/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <AudioToolbox/AudioToolbox.h>
@protocol LotteryBaseViewDelegate <NSObject>
@optional
- (void) showBlockLoadingViewWithText: (NSString *) text;
- (void) showBlockLoadingViewWithText: (NSString *) text detailText: (NSString *) detailText;

- (void) showPromptViewWithText: (NSString *) text;
- (void) showPromptViewWithText: (NSString *) text hideAfter: (NSTimeInterval) interval;

- (void) hideLoadingView;
@end

@interface LotteryBaseView : UIView

@property (nonatomic, weak) id<LotteryBaseViewDelegate> delegate;

@end
