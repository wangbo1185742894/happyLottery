//
//  XHSectionRandomView.m
//  Lottery
//
//  Created by YanYan on 6/3/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "XHSectionRandomView.h"

#define ButtonTitlePadding 5
#define TextFont [UIFont systemFontOfSize: 14]
@interface XHSectionRandomView() {
    LotteryXHSection *lotteryXHSection;

}
@end

@implementation XHSectionRandomView

- (void) initUIWithLotteryXH: (LotteryXHSection *) lotteryXH curlottery:(Lottery *)lottery
{
     _lottery = lottery;
    lotteryXHSection = lotteryXH;
    //add random number generate button
    
    NSString *actionButtonText;
    CGSize buttonTextSize;
    CGFloat buttonWidth;
    CGRect bt_frame;
    if ([_lotteryIdenty isEqualToString:@"DLT"]||[_lotteryIdenty isEqualToString:@"SSQ"]) {
        //zwl 16-01-18
        if([lotteryXHSection.sectionID isEqualToString:@"1"])
        {
//            UILabel *jixuan = [[UILabel alloc]initWithFrame:CGRectMake(10, 0, 40, self.bounds.size.height)];
//            jixuan.text = @"机选:";
//            jixuan.font = [UIFont systemFontOfSize:14];
//            jixuan.textColor = RGBCOLOR(72, 72, 72);
//            [self addSubview:jixuan];
            
            actionButtonText = @"机选1注";
            buttonTextSize = MB_TEXTSIZE(actionButtonText, TextFont);
            buttonWidth = buttonTextSize.width + ButtonTitlePadding*2;
            if ([Utility isIphone5s]) {
                bt_frame = CGRectMake(27, 0, buttonWidth, self.bounds.size.height);
            }else {
                bt_frame = CGRectMake(0, 0, buttonWidth, self.bounds.size.height);
            }
            
            
            
            NSString * actionText = @"机选5注";
            CGSize textSize = MB_TEXTSIZE(actionText, TextFont);
            CGFloat width = textSize.width + ButtonTitlePadding*2;
            CGRect fiveFrame ;
            if ([Utility isIphone5s]) {
                fiveFrame = CGRectMake(87, 0, width, self.bounds.size.height);
            }
            else {
                fiveFrame = CGRectMake(80, 0, width, self.bounds.size.height);
            }
            
            buttonRandomeFive = [self creatButton:fiveFrame andTitle:actionText];
            [buttonRandomeFive addTarget:self action:@selector(actionRandomeFive) forControlEvents:UIControlEventTouchUpInside];
            [self addSubview: buttonRandomeFive];
        }
    }else if([_lotteryIdenty isEqualToString:@"SX115"]|| [_lotteryIdenty  isEqualToString:@"SD115"]){
        actionButtonText = @"机选1注";
        buttonTextSize = MB_TEXTSIZE(actionButtonText, TextFont);
        buttonWidth = buttonTextSize.width + ButtonTitlePadding*2;
        bt_frame = CGRectMake(CGRectGetWidth(self.bounds)-buttonWidth, 0, buttonWidth, self.bounds.size.height);
    }
   
    buttonRandomeNumber = [self creatButton:bt_frame andTitle:actionButtonText];
    [buttonRandomeNumber addTarget: self action: @selector(generateRandomeNumbers) forControlEvents: UIControlEventTouchUpInside];
    [self addSubview: buttonRandomeNumber];
    if([_lotteryIdenty isEqualToString:@"SX115"]|| [_lotteryIdenty  isEqualToString:@"SD115"]){
       return;
    }
    
//    CGFloat curX = CGRectGetMaxX(buttonRandomeNumber.frame);
//    CGFloat leftOverWidth = self.bounds.size.width - curX;
//    buttonRandomCountSelect = [UIButton buttonWithType: UIButtonTypeCustom];
//    buttonRandomCountSelect.frame = CGRectMake(curX, 0, leftOverWidth, self.bounds.size.height);
//
//    [buttonRandomCountSelect.titleLabel setTextColor: [UIColor whiteColor]];
//    [buttonRandomCountSelect setTitleEdgeInsets:UIEdgeInsetsMake(0, 0, 0, 15)];
//    if ([lotteryXH.normalColor isEqualToString:@"dd171b"]) {
//        [buttonRandomCountSelect setBackgroundImage:[UIImage imageNamed:@"redxiala.png"] forState:UIControlStateNormal];
//    }else{
//        [buttonRandomCountSelect setBackgroundImage:[UIImage imageNamed:@"bluexiala.png"] forState:UIControlStateNormal];
//    }
//    
//
//    buttonRandomCountSelect.titleLabel.font = TextFont;
//    buttonRandomCountSelect.layer.cornerRadius = 2;
//    [buttonRandomCountSelect addTarget: self action: @selector(showNumberSelectView) forControlEvents: UIControlEventTouchUpInside];
//    [self addSubview: buttonRandomCountSelect];
    [self updateRandomCount: [lotteryXH.minNumCount intValue]];
    
    
}

-(void)actionRandomeFive{

    [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationRandomeFive" object:@"5"];

}


-(UIButton *)creatButton:(CGRect)bt_frame andTitle:(NSString *)actionButtonText{

    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = bt_frame;
    
    //  [Utility colorFromHexString: lotteryXH.normalColor]
    [btn setTintColor: [UIColor whiteColor]];
    [btn.titleLabel setFont: TextFont];
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    
    
    //    if ([lotteryXH.normalColor isEqualToString:@"dd171b"]) {
    //        [buttonRandomeNumber setBackgroundImage:[UIImage imageNamed:@"redballs.png"] forState:UIControlStateNormal];
    //    }else{
    //        [buttonRandomeNumber setBackgroundImage:[UIImage imageNamed:@"blueballs.png"] forState:UIControlStateNormal];
    //    }
    [btn setBackgroundImage:[UIImage imageNamed:@"machine-selection.png"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"machine-selection.png"] forState:UIControlStateHighlighted];
    [btn setTitleColor:TEXTGRAYCOLOR forState:UIControlStateHighlighted];
    [btn setTitle: actionButtonText forState: UIControlStateNormal];
    
    return btn;
}

- (void) updateRandomCount: (int) count {
//    buttonRandomCountSelect.text = [NSString stringWithFormat: @"%d", count];
//    [buttonRandomCountSelect setTitle: [NSString stringWithFormat: @"%d", count] forState: UIControlStateNormal];
    _randomCount = count;
}

- (void) generateRandomeNumbers {
//ZWL 16-01-18
    for (LotteryXHSection *lotteryXH in _lottery.activeProfile.details)
    {
        [self updateRandomCount: [lotteryXH.minNumCount intValue]];
        [self.delegate generateRandomNumber: _randomCount lotteryXHSection: lotteryXH];
    }
}

- (void) showNumberSelectView {
    self.numberSelectView.delegate = self;
    self.numberSelectView.startNumber = [lotteryXHSection.minNumCount intValue];
    self.numberSelectView.numberCount = [lotteryXHSection.maxNumCount intValue] - [lotteryXHSection.minNumCount intValue] + 1;
    [self.numberSelectView showMeWithSelectedNumber: _randomCount];
}

- (void) didSelectNumber: (int) number {
    [self updateRandomCount: number];
    [self.numberSelectView hideMe];
}
@end
