//
//  XHSectionTitleView.m
//  Lottery
//
//  Created by YanYan on 6/3/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "XHSectionTitleView.h"
#import "LotteryXHSection.h"

#define TextFont [UIFont systemFontOfSize: 13]
#define MainColor   RGBCOLOR(255, 192, 47)
@implementation XHSectionTitleView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

- (void) initWithLotteryXH: (LotteryXHSection*) lotteryXH {
    CGFloat curX = 0;
    //title label
    NSString *titleText = [NSString stringWithFormat: @"%@: ", lotteryXH.label];
    CGSize titleTextSize = MB_TEXTSIZE(titleText, TextFont);
    labelTitle = [[UILabel alloc] initWithFrame: CGRectMake(curX, 0, titleTextSize.width, self.bounds.size.height)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.font = TextFont;
    labelTitle.textColor = TEXTGRAYCOLOR;
//    labelTitle.textColor = [Utility colorFromHexString: lotteryXH.normalColor];
   
    if ([[titleText substringToIndex:2] isEqualToString:@"拖码"]) {
        UIButton *allSelect = [self creatButton:CGRectMake(220, 0, 50, self.bounds.size.height) andTitle:@"全选"];
        [self addSubview: allSelect];
        
        [allSelect addTarget:self action:@selector(actionAllSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    
    labelTitle.text = titleText;
    [self addSubview: labelTitle];
    curX = CGRectGetMaxX(labelTitle.frame);
    
    //rule desc label
    NSString *descText;
    
    if ([lotteryXH.ruleDesc isEqualToString:@"乐选"]) {
        descText = @"选择1个号码";
    }else  if ([lotteryXH.ruleDesc isEqualToString:@"11选5任选8"]) {
        descText = @"选8个号";
    }else{
        descText =[NSString stringWithFormat: TextRuelDesc, [lotteryXH.minNumCount intValue]];
    }
    

    CGSize descTextSize = MB_TEXTSIZE(descText, TextFont);
    labelRuleDesc = [[UILabel alloc] initWithFrame: CGRectMake(curX, 0, descTextSize.width, self.bounds.size.height)];
    labelRuleDesc.backgroundColor = [UIColor clearColor];
//    labelRuleDesc.textColor = MainColor;
    labelRuleDesc.textColor = TEXTGRAYCOLOR;
    labelRuleDesc.font = TextFont;
    labelRuleDesc.text = descText;
    [self addSubview: labelRuleDesc];
    curX = CGRectGetMaxX(labelRuleDesc.frame);
    
    
    //selected desc label
    NSString *numberText = [NSString stringWithFormat: TextSelectNumber, (unsigned long)0];
    CGFloat leftOverWidth = self.bounds.size.width - curX;
    labelSelectedDesc = [[UILabel alloc] initWithFrame: CGRectMake(curX, 0, leftOverWidth, self.bounds.size.height)];
    [labelSelectedDesc setBackgroundColor: [UIColor clearColor]];
    labelSelectedDesc.font = TextFont;
    labelSelectedDesc.text = numberText;
//    labelSelectedDesc.textColor = MainColor;
    labelSelectedDesc.textColor = TEXTGRAYCOLOR;
    [self addSubview: labelSelectedDesc];
}

- (void) updateSelectedNumber: (NSUInteger) selectedNumberCount {
    labelSelectedDesc.text = [NSString stringWithFormat: TextSelectNumber, (unsigned long)selectedNumberCount];
}

-(UIButton *)creatButton:(CGRect)bt_frame andTitle:(NSString *)actionButtonText{
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = bt_frame;
    
    //  [Utility colorFromHexString: lotteryXH.normalColor]
    [btn setTintColor: [UIColor whiteColor]];
    [btn.titleLabel setFont: TextFont];
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    
    
    [btn setBackgroundImage:[UIImage imageNamed:@"orangeBackground.png"] forState:UIControlStateNormal];
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"whiteBackground.png"] forState:UIControlStateHighlighted];
    [btn setTitleColor:TEXTGRAYCOLOR forState:UIControlStateHighlighted];
    [btn setTitle: actionButtonText forState: UIControlStateNormal];
    
    return btn;
}

-(void)actionAllSelect{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationSelectAllNumbers" object:nil];
    
}
@end
