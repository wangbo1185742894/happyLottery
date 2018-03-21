//
//  XuanHaoNumberView.m
//  Lottery
//
//  Created by AMP on 5/23/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "XHNumberView.h"

@interface XHNumberView() {
    UIButton *buttonNum;
    NumberViewState maxState;
}
@end

@implementation XHNumberView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) drawNumber {
    maxState = NumberViewStateDanHao;
    if (![self.lotteryXH.needDanHao boolValue]) {
        maxState = NumberViewStateSelected;
    }
    buttonNum = [UIButton buttonWithType: UIButtonTypeCustom];
    buttonNum.frame = self.bounds;
    buttonNum.titleLabel.lineBreakMode = 0;
    [self updateButtonForCurrentState];
    [buttonNum addTarget: self action: @selector(xhButonAction) forControlEvents: UIControlEventTouchUpInside];
    //lc
    [buttonNum.titleLabel setFont: [UIFont systemFontOfSize: 15]];
    buttonNum.titleLabel.textAlignment = NSTextAlignmentCenter;
//    [buttonNum.titleLabel setFont: [UIFont boldSystemFontOfSize: 16]];
    [self addSubview: buttonNum];
}

- (void) reset {
    self.numberState = NumberViewStateNormal;
    [self updateButtonForCurrentState];
}

- (void) updateButtonForCurrentState {
    UIColor *titleColor = nil;
    UIImage *bgImage = nil;
    NSString *title = self.numberObj.numberDesc;
    switch (self.numberState) {
        case NumberViewStateNormal:
            bgImage = [UIImage imageNamed: self.lotteryXH.normalBackground];
            titleColor = [Utility colorFromHexString: self.lotteryXH.normalColor];
            break;
        case NumberViewStateSelected:
            bgImage = [UIImage imageNamed: self.lotteryXH.selectedBackground];
            titleColor = [Utility colorFromHexString: self.lotteryXH.selectedColor];
            break;
        case NumberViewStateDanHao:
            bgImage = [UIImage imageNamed: self.lotteryXH.selectedBackground];
            titleColor = [Utility colorFromHexString: self.lotteryXH.selectedColor];
            title = [NSString stringWithFormat:@"%@\n%@",title,TitleTextDanHao];
//            title = TitleTextDanHao;
            break;
        default:
            bgImage = [UIImage imageNamed: self.lotteryXH.normalBackground];
            titleColor = [UIColor grayColor];
            break;
    }
    [buttonNum setBackgroundImage: bgImage forState: UIControlStateNormal];
    [buttonNum setBackgroundImage: bgImage forState: UIControlStateHighlighted];
    [buttonNum setTitle: title forState: UIControlStateNormal];
    [buttonNum setTitleColor: titleColor forState: UIControlStateNormal];
}

- (void) xhButonAction {
    NumberViewState newState = [self.delegate numberView: self lotteryXuanHao: self.lotteryXH nextViewState: maxState];
    if (newState != self.numberState) {
        self.numberState = newState;
        [self updateButtonForCurrentState];
    }
    [self.delegate numberView: self lotteryXuanHao: self.lotteryXH numberStateUpdate:self.numberState];
}


@end
