//
//  XHSectionTitleView.h
//  Lottery
//
//  Created by YanYan on 6/3/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@class LotteryXHSection;
@interface XHSectionTitleView : UIView {
    UILabel *labelTitle;
    UILabel *labelRuleDesc;
    UILabel *labelSelectedDesc;
}

- (void) initWithLotteryXH: (LotteryXHSection *)lotteryXH;
- (void) updateSelectedNumber: (NSUInteger) selectedNumberCount;
@end
