//
//  LotteryPhaseInfoView.m
//  Lottery
//
//  Created by AMP on 5/25/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryPhaseInfoView.h"

@interface LotteryPhaseInfoView() {
    Lottery *lottery;
    UILabel *labelCurRoundInfoTitle;
    UILabel *labelCurRoundInfoDesc;
    UILabel *downLine;
}
@end

#define TitleLeftPadding    10
@implementation LotteryPhaseInfoView
@dynamic delegate;

- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        CGRect downLineFrame = frame;
        downLineFrame.origin.x = 0;
        downLineFrame.origin.y = frame.size.height - SEPHEIGHT;
        downLineFrame.size.height = SEPHEIGHT;
        
        downLine = [[UILabel alloc] initWithFrame:downLineFrame];
        downLine.backgroundColor = SEPCOLOR;
        [self addSubview:downLine];
    }
    return self;
}
- (void) drawWithLottery: (Lottery *) lotteryTMP {
    lottery = lotteryTMP;
    if (lotteryMan == nil) {
        lotteryMan = [[LotteryManager alloc] init];
        lotteryMan.delegate = self;
    }
        self.backgroundColor = [UIColor whiteColor];
    
        UIImageView *blackImage = [[UIImageView alloc]initWithFrame:CGRectMake(0,10,KscreenWidth - 140, 20)];
//        blackImage.backgroundColor = [UIColor blackColor];
        blackImage.image = [UIImage imageNamed:@"timebackimage"];
        // 在这里添加背景图片
        [self addSubview:blackImage];
    
    UIButton *xiahuaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xiahuaBtn.frame = CGRectMake(KscreenWidth - 100,10, 90, 20);
    [xiahuaBtn setTitleColor:TEXTGRAYCOLOR forState:0];
    [xiahuaBtn setTitle:@"下滑查看开奖" forState:0];
    xiahuaBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [xiahuaBtn setImage:[UIImage imageNamed:@"arrow_down.png"] forState:0];
    [xiahuaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -120)];
    [xiahuaBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -45, 0, 0)];
    [self addSubview:xiahuaBtn];
    
    [self showCurRoundInfo];
    
    
    
}




- (void)setNumberColor:(UILabel *)contentLabel{
    NSMutableAttributedString  *attStr = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
    NSString *temp = @"";
    for (NSInteger i =0; i<[contentLabel.text length]; i++) {
        temp = [contentLabel.text substringWithRange:NSMakeRange(i, 1)];
        if ([self isInt:temp]) {
            [attStr setAttributes:@{NSForegroundColorAttributeName:TextTimeColor} range:NSMakeRange(i, 1)];
        }
    }
    contentLabel.attributedText = attStr;
}

- (BOOL)isInt:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (string.length > 0) {
        return NO;
    }
    return YES;
    
}


- (void) showCurRoundInfo {
    if (labelCurRoundInfoTitle) {
        [labelCurRoundInfoTitle removeFromSuperview];
        [_timeCountdownView removeFromSuperview];
    }
//    if ([lottery.identifier isEqualToString:@"PL3"] ||[lottery.identifier isEqualToString:@"PL5"]) {
        CGRect titleFrame = self.bounds;
        titleFrame.origin.x = 5;
        titleFrame.size.width = 100;
        labelCurRoundInfoTitle = [[UILabel alloc] initWithFrame: titleFrame];
        labelCurRoundInfoTitle.backgroundColor = [UIColor clearColor];
        labelCurRoundInfoTitle.font = [UIFont systemFontOfSize: 11];
        labelCurRoundInfoTitle.adjustsFontSizeToFitWidth = YES;
        labelCurRoundInfoTitle.textColor = [UIColor whiteColor];
        if (lottery.currentRound) {
            labelCurRoundInfoTitle.text = [NSString stringWithFormat: @"距离%@期 截止:", lottery.currentRound.issueNumber];
        }else{
            labelCurRoundInfoTitle.text = @"距离:未获得 截止:";
        }
        [self setNumberColor:labelCurRoundInfoTitle];
        [self addSubview: labelCurRoundInfoTitle];
        if (!_timeCountdownView) {
            _timeCountdownView = [[LotteryTimeCountdownView alloc] initWithFrame:CGRectMake(56, 11,KscreenWidth - 150,20)];
        }

        _timeCountdownView.timeCutType = TimeCutTypePlayPage;
        [_timeCountdownView startTimeCountdown:lottery.currentRound];
        [self addSubview:_timeCountdownView];
//    }else{
//        CGRect titleFrame = self.bounds;
//        titleFrame.origin.x = LEFTPADDING;
//        titleFrame.size.width = 100;
//        labelCurRoundInfoTitle = [[UILabel alloc] initWithFrame: titleFrame];
//        labelCurRoundInfoTitle.backgroundColor = [UIColor clearColor];
//        labelCurRoundInfoTitle.font = [UIFont systemFontOfSize: 13];
//        labelCurRoundInfoTitle.adjustsFontSizeToFitWidth = YES;
//        labelCurRoundInfoTitle.textColor = TEXTGRAYCOLOR;
//        if (lottery.currentRound) {
//            labelCurRoundInfoTitle.text = [NSString stringWithFormat: @"第%@期", lottery.currentRound.issueNumber];
//        }else{
//            labelCurRoundInfoTitle.text = @"期次：未获得期次";
//        }
//        [self addSubview: labelCurRoundInfoTitle];
//        if (!_timeCountdownView) {
//            _timeCountdownView = [[LotteryTimeCountdownView alloc] initWithFrame:self.bounds];
//        }
//        _timeCountdownView.timeCutType = TimeCutTypePlayPage;
//        [_timeCountdownView startTimeCountdown:lottery.currentRound];
//        [self addSubview:_timeCountdownView];
//    }
//    
    
}

- (NSString *)timeSting{
    NSString * time= [_timeCountdownView getTimeString];
    return time;
}


@end
