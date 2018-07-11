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

- (void) drawWithLotteryNoButton: (Lottery *) lotteryTMP {
    lottery = lotteryTMP;
    if (lotteryMan == nil) {
        lotteryMan = [[LotteryManager alloc] init];
        lotteryMan.delegate = self;
    }
    self.backgroundColor = [UIColor whiteColor];
    
    //        UIImageView *blackImage = [[UIImageView alloc]initWithFrame:CGRectMake(-15,10,KscreenWidth - 140, 20)];
    //        blackImage.backgroundColor = [UIColor blackColor];
    //        blackImage.image = [UIImage imageNamed:@"timebackimage"];
    //    [blackImage setBackgroundColor:[UIColor whiteColor]];
    //    blackImage.layer.cornerRadius = blackImage.mj_h / 2;
    //    blackImage.layer.masksToBounds = YES;
    
    // 在这里添加背景图片
    //        [self addSubview:blackImage];
    
  
    [self showCurRoundInfo];
}

- (void) drawWithLottery: (Lottery *) lotteryTMP {
    lottery = lotteryTMP;
    if (lotteryMan == nil) {
        lotteryMan = [[LotteryManager alloc] init];
        lotteryMan.delegate = self;
    }
        self.backgroundColor = [UIColor whiteColor];
    
//        UIImageView *blackImage = [[UIImageView alloc]initWithFrame:CGRectMake(-15,10,KscreenWidth - 140, 20)];
//        blackImage.backgroundColor = [UIColor blackColor];
//        blackImage.image = [UIImage imageNamed:@"timebackimage"];
//    [blackImage setBackgroundColor:[UIColor whiteColor]];
//    blackImage.layer.cornerRadius = blackImage.mj_h / 2;
//    blackImage.layer.masksToBounds = YES;
    
        // 在这里添加背景图片
//        [self addSubview:blackImage];
    
    UIButton *xiahuaBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    xiahuaBtn.frame = CGRectMake(KscreenWidth - 100,10, 90, 20);
    [xiahuaBtn setTitleColor:TEXTGRAYCOLOR forState:0];
    [xiahuaBtn setTitle:@"往期开奖" forState:0];
    xiahuaBtn.titleLabel.font = [UIFont systemFontOfSize:11];
    [xiahuaBtn setImage:[UIImage imageNamed:@"arrow_down.png"] forState:0];

    [xiahuaBtn setImageEdgeInsets:UIEdgeInsetsMake(0, 0, 0, -120)];
    [xiahuaBtn setTitleEdgeInsets:UIEdgeInsetsMake(0, -45, 0, 0)];
    [xiahuaBtn addTarget:self action:@selector(lookHisOpenResult:) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:xiahuaBtn];
    [self showCurRoundInfo];
}

-(void)lookHisOpenResult:(UIButton *)sender{
    sender.selected = !sender.selected;
    [self.delegate lookOpenHis:sender];
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
        titleFrame.origin.x = 15;
    if ([Utility isIphone5s]) {
        titleFrame.size.width = 100;
    }else{
        titleFrame.size.width = 120;
    }
        labelCurRoundInfoTitle = [[UILabel alloc] initWithFrame: titleFrame];
        labelCurRoundInfoTitle.backgroundColor = [UIColor clearColor];
        labelCurRoundInfoTitle.font = [UIFont systemFontOfSize: 14];
        labelCurRoundInfoTitle.adjustsFontSizeToFitWidth = YES;
        labelCurRoundInfoTitle.textColor = SystemLightGray;
        // 奖期显示计时条修改 lyw
        if (lottery.currentRound) {
            labelCurRoundInfoTitle.text = [NSString stringWithFormat: @"距离%@期 截止:  ", lottery.currentRound.issueNumber];
            float pointX;
            if ([Utility isIphone5s]) {
                pointX = 65;
            }else {
                pointX = 56;
            }
            
            if (!_timeCountdownView) {
                _timeCountdownView = [[LotteryTimeCountdownView alloc] initWithFrame:CGRectMake(pointX, 12,KscreenWidth - 150,20)];
            }
            
            _timeCountdownView.timeCutType = TimeCutTypePlayPage;
            [_timeCountdownView startTimeCountdown:lottery.currentRound];
            [self addSubview:_timeCountdownView];
        }else{
              labelCurRoundInfoTitle.text = @"当前奖期已截止";
//            labelCurRoundInfoTitle.text = @"距离:未获得 截止:";
        }
        [self setNumberColor:labelCurRoundInfoTitle];
        [self addSubview: labelCurRoundInfoTitle];
}

- (NSString *)timeSting{
    NSString * time= [_timeCountdownView getTimeString];
    return time;
}


@end
