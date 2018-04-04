//
//  XHSectionTitleView.h
//  Lottery
//
//  Created by YanYan on 6/3/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "MGLabel.h"

@class LotteryXHSection;
@interface XHSectionTitleView : UIView {
    UIButton *roundBtn;//圆点添加
    UILabel *labelTitle;
    MGLabel *labelRuleDesc;
    MGLabel *labelSelectedDesc;
}

- (void) initWithLotteryXH: (LotteryXHSection *)lotteryXH;
- (void) updateSelectedNumber: (NSUInteger) selectedNumberCount;
@end
