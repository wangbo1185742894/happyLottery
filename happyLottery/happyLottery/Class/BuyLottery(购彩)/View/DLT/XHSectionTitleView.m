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
    //button
    roundBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    [roundBtn setBackgroundImage:[UIImage imageNamed:lotteryXH.selectedBackground] forState:UIControlStateNormal];
    [roundBtn setFrame: CGRectMake(curX,(self.frame.size.height-10)/2, 10, 10)];
    [self addSubview:roundBtn];
    curX += roundBtn.frame.size.width+3;
    //title label
    NSString *titleText = [NSString stringWithFormat: @"%@, ", lotteryXH.label];
    
    CGSize titleTextSize = MB_TEXTSIZE(titleText, TextFont);
    labelTitle = [[UILabel alloc] initWithFrame: CGRectMake(curX, 0, titleTextSize.width, self.bounds.size.height)];
    labelTitle.backgroundColor = [UIColor clearColor];
    labelTitle.font = TextFont;
    labelTitle.textColor = TEXTGRAYCOLOR;
   
    if ([[titleText substringToIndex:2] isEqualToString:@"拖码"]) {
        UIButton *allSelect = [self creatButton:CGRectMake(KscreenWidth - 90, 0, 50, self.bounds.size.height) andTitle:@"全选"];
        [self addSubview: allSelect];
        
        [allSelect addTarget:self action:@selector(actionAllSelect) forControlEvents:UIControlEventTouchUpInside];
    }
    
    labelTitle.text = titleText;
    [self addSubview: labelTitle];
    curX = CGRectGetMaxX(labelTitle.frame);
    
    //rule desc label
    NSString *descText;
    
    descText =[NSString stringWithFormat: TextRuelDesc, [lotteryXH.minNumCount intValue]];
    CGSize descTextSize = MB_TEXTSIZE(descText, TextFont);
    labelRuleDesc = [[MGLabel alloc] initWithFrame: CGRectMake(curX, 0, descTextSize.width, self.bounds.size.height)];
    labelRuleDesc.backgroundColor = [UIColor clearColor];

    labelRuleDesc.textColor = TEXTGRAYCOLOR;
    labelRuleDesc.font = TextFont;
    labelRuleDesc.text = descText;
    labelRuleDesc.keyWord = [NSString stringWithFormat:@"%@个",[lotteryXH.minNumCount stringValue]];
    labelRuleDesc.keyWordColor = [Utility colorFromHexString:lotteryXH.normalColor];
    
    [self addSubview: labelRuleDesc];
    curX = CGRectGetMaxX(labelRuleDesc.frame);
    
    
    //selected desc label
    NSString *numberText = [NSString stringWithFormat: TextSelectNumber, (unsigned long)0];
    CGFloat leftOverWidth;
    if ([Utility isIphone5s]) {
        leftOverWidth = self.bounds.size.width - curX+5;
    } else {
        leftOverWidth = self.bounds.size.width - curX;
    }
    labelSelectedDesc = [[MGLabel alloc] initWithFrame: CGRectMake(curX, 0, leftOverWidth, self.bounds.size.height)];
    [labelSelectedDesc setBackgroundColor: [UIColor clearColor]];
    labelSelectedDesc.font = TextFont;
    labelSelectedDesc.text = numberText;
//    labelSelectedDesc.textColor = MainColor;
    labelSelectedDesc.textColor = TEXTGRAYCOLOR;
    labelSelectedDesc.keyWord = @"0个";
    labelSelectedDesc.keyWordColor = [Utility colorFromHexString:lotteryXH.normalColor];
    
    [self addSubview: labelSelectedDesc];
}

- (void) updateSelectedNumber: (NSUInteger) selectedNumberCount {
    labelSelectedDesc.text = [NSString stringWithFormat: TextSelectNumber, (unsigned long)selectedNumberCount];
    labelSelectedDesc.keyWord = [NSString stringWithFormat:@"%ld个",selectedNumberCount];
}

-(UIButton *)creatButton:(CGRect)bt_frame andTitle:(NSString *)actionButtonText{
    
    UIButton *btn = [UIButton buttonWithType: UIButtonTypeCustom];
    btn.frame = bt_frame;
    
    //  [Utility colorFromHexString: lotteryXH.normalColor]
    [btn setTintColor: [UIColor whiteColor]];
    [btn.titleLabel setFont: TextFont];
    btn.layer.cornerRadius = 2;
    btn.layer.masksToBounds = YES;
    
    
    [btn setBackgroundImage:[UIImage imageNamed:@"machine-selection.png"] forState:UIControlStateNormal];
    
    [btn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [btn setBackgroundImage:[UIImage imageNamed:@"machine-selection.png"] forState:UIControlStateHighlighted];
    [btn setTitleColor:TEXTGRAYCOLOR forState:UIControlStateHighlighted];
    [btn setTitle: actionButtonText forState: UIControlStateNormal];
    
    return btn;
}

-(void)actionAllSelect{

    [[NSNotificationCenter defaultCenter] postNotificationName:@"NSNotificationSelectAllNumbers" object:nil];
    
}
@end
