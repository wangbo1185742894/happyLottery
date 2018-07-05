//
//  LotteryTitleView.m
//  Lottery
//
//  Created by YanYan on 6/5/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryTitleView.h"

@implementation LotteryTitleView
@dynamic delegate;
/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (void) updateWithLottery: (Lottery *) lottery {
    ivClickIndicator.hidden = YES;
    if (labelLotteryName == nil) {
        self.backgroundColor = [UIColor clearColor];
        labelLotteryName = [[UILabel alloc] initWithFrame: CGRectMake(0, 0, self.bounds.size.width, self.bounds.size.height)];
        labelLotteryName.backgroundColor = [UIColor clearColor];
        labelLotteryName.textColor = [UIColor whiteColor];
        labelLotteryName.font = TitleTextFont;
        labelLotteryName.textAlignment = NSTextAlignmentCenter;
        [self addSubview: labelLotteryName];
        
        
//        labelLotteryProfileName = [[UILabel alloc] initWithFrame: CGRectMake(0, 20, self.bounds.size.width, 20)];
//        labelLotteryProfileName.backgroundColor = [UIColor clearColor];
//        labelLotteryProfileName.textColor = [UIColor whiteColor];
//        labelLotteryProfileName.font = [UIFont boldSystemFontOfSize: 18];
//        labelLotteryProfileName.textAlignment = NSTextAlignmentCenter;
//        [self addSubview: labelLotteryProfileName];
        
        ivClickIndicator = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"wanfaxiala"]];
        
        ivClickIndicator.hidden = YES;
        [self addSubview: ivClickIndicator];
        
    }
    actionButton = [[UIButton alloc] initWithFrame: self.bounds];
    [self addSubview: actionButton];
    [actionButton addTarget: self action: @selector(clickAction) forControlEvents: UIControlEventTouchUpInside];
    
    NSString * title;
    if (lottery.activeProfileForExtrend) {
        title = lottery.activeProfileForExtrend.title;
    }else{
        title = lottery.activeProfile.title;
    }
    
    NSString *titleText ;
    if([lottery.identifier isEqualToString:@"SX115"]||[lottery.identifier isEqualToString:@"SD115"]){
        titleText = [NSString stringWithFormat:@"%@-%@",lottery.name,title];
    }else{
        titleText = title;
    }

    CGSize titleSize = MB_TEXTSIZE(titleText, TitleTextFont);
    CGRect newFrame = labelLotteryName.frame;
    newFrame.size.width = titleSize.width;
    newFrame.origin.x = (self.bounds.size.width - titleSize.width)/2;
    labelLotteryName.frame = newFrame;
    if([lottery.identifier isEqualToString:@"SX115"]||[lottery.identifier isEqualToString:@"SD115"]){
        labelLotteryName.text = titleText;
    }else{
        labelLotteryName.text = titleText;
    }
    
    CGRect ivFrame = ivClickIndicator.frame;
    ivFrame.origin.x = CGRectGetMaxX(newFrame) + 1;
    ivFrame.origin.y = CGRectGetMaxY(newFrame) - 20;
    ivFrame.size.width = 10;
    ivFrame.size.height = 10;
    ivClickIndicator.frame = ivFrame;
    ivClickIndicator.contentMode = UIViewContentModeCenter;
    ivClickIndicator.hidden = NO;
}

- (void) clickAction {
    if ([self.delegate respondsToSelector: @selector(userDidClickTitleView)]) {
        [self.delegate userDidClickTitleView];
    }
}

- (void) shieldClickAction{
    actionButton.enabled = NO;
}
@end
