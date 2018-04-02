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
        
        ivClickIndicator = [[UIImageView alloc] initWithImage: [UIImage imageNamed: @"navMore.png"]];
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
    
    NSString *titleText;
//#ifdef betaVersion
//    if(title == nil)
//    {
//        title = lottery.name;
//    }
//    titleText = [NSString stringWithFormat: @"%@", title];
//#else
    if(title == nil||[title isEqualToString:@"任选9场"]||[title isEqualToString:@"胜负14场"] || [lottery.identifier isEqualToString:@"JCZQ"])
        {
            titleText = title;
        }else{
            
            titleText  = [NSString stringWithFormat: @"%@", title];
        }
//#endif
    CGSize titleSize = MB_TEXTSIZE(titleText, TitleTextFont);
    CGRect newFrame = labelLotteryName.frame;
    newFrame.size.width = titleSize.width;
    newFrame.origin.x = (self.bounds.size.width - titleSize.width)/2;
    labelLotteryName.frame = newFrame;
    labelLotteryName.text = titleText;
    
    CGRect ivFrame = ivClickIndicator.frame;
    ivFrame.origin.x = CGRectGetMaxX(newFrame) + 1;
    ivFrame.origin.y = 18;
    ivFrame.size.width = 18;
    ivFrame.size.height = 11;
    ivClickIndicator.frame = ivFrame;
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
