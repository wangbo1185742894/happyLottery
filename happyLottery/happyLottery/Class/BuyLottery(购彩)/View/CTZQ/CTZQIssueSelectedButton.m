//
//  CTZQIssueSelectedButton.m
//  Lottery
//
//  Created by only on 16/3/23.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQIssueSelectedButton.h"

@implementation CTZQIssueSelectedButton

- (void)setTitleIssueStr:(NSString *)issueStr andTimeStr:(NSString *)timeStr{
    [self setIssueStr:issueStr andTimeStr:timeStr withControlState:UIControlStateNormal];
    [self setIssueStr:issueStr andTimeStr:timeStr withControlState:UIControlStateSelected];
}
- (void)setIssueStr:(NSString *)issueStr andTimeStr:(NSString *)timeStr withControlState:(UIControlState)state{
    UIColor *issueColor;
    UIColor *timeColor;
    switch (state) {
        case UIControlStateNormal:
        {
            issueColor = TEXTGRAYCOLOR;
            timeColor = TEXTGRAYCOLOR;
        }
            break;
        case UIControlStateSelected:
        {
            issueColor = TextCharColor;
            timeColor = TextCharColor;
        }
            break;
            
        default:
            issueColor = TEXTGRAYCOLOR;
            timeColor = TEXTGRAYCOLOR;
            break;
    }
    NSMutableAttributedString *attTitle = [[NSMutableAttributedString alloc] init];
    [attTitle appendAttributedString:[[NSAttributedString alloc] initWithString:issueStr attributes:@{NSForegroundColorAttributeName:issueColor,NSFontAttributeName:[UIFont systemFontOfSize:15]}]];
    [attTitle appendAttributedString:[[NSAttributedString alloc] initWithString:@"\n" attributes:nil]];
    [attTitle appendAttributedString:[[NSAttributedString alloc] initWithString:timeStr attributes:@{NSForegroundColorAttributeName:timeColor,NSFontAttributeName:[UIFont systemFontOfSize:9]}]];
    self.titleLabel.numberOfLines = 0;
    self.titleLabel.textAlignment = NSTextAlignmentCenter;
    [self setAttributedTitle:attTitle forState:state];
}

@end
