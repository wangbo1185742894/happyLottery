//
//  LotteryWinHistoryCell.m
//  Lottery
//
//  Created by Yang on 6/30/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryWinHistoryCell.h"
@interface LotteryWinHistoryCell()
{
    __weak IBOutlet UIView *ballBGview;
    __weak IBOutlet UILabel *qihaoLa;
    IBOutletCollection(UIButton) NSArray *redBalls;
    IBOutletCollection(UIButton) NSArray *blueBalls;
    __weak IBOutlet NSLayoutConstraint *redLeading;
    IBOutletCollection(UIButton) NSArray *redBalls45;

}
@end

@implementation LotteryWinHistoryCell

- (void)awakeFromNib {
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)lsetUpWithLottery:(Lottery *)lottery cellHeight:(float)cellH withSizeRatio:(NSString *)ratio{
    if ([lottery.identifier isEqualToString:@"SX115"]  || [lottery.identifier isEqualToString:@"PL5"] || [lottery.identifier  isEqualToString:@"SD115"]) {
        redLeading.constant = 20;
        for (UIButton *bn in blueBalls) {
            bn.hidden = YES;
        }
    }else if([lottery.identifier isEqualToString:@"PL3"]){
        redLeading.constant = 20;
        for (UIButton *bn in blueBalls) {
            bn.hidden = YES;
        }
        
        for (UIButton *rd45 in redBalls45) {
            rd45.hidden = YES;
        }
    }else{
        redLeading.constant = 20;
        for (UIButton *bn in blueBalls) {
            bn.hidden = NO;
        }
    }
    
}
//NSString* timestr = [NSString stringWithFormat:@"%@",_curround.startTime];
//NSInteger length = [timestr length];
//if(length > 10)
//{
//    timestr = [timestr substringToIndex:10];
//}
//NSString *lotteryRoundDesc= [NSString stringWithFormat:@"第%@期 %@ (%@)",_curround.issueNumber,timestr,[Utility weekDayGetForTimeString:timestr]];
- (void)lcellFillInfo:(DltOpenResult*)round{
    NSString* timestr = [NSString stringWithFormat:@"%@",round.startTime];
    NSInteger length = [timestr length];
    if(length > 10)
    {
        timestr = [timestr substringToIndex:10];
    }
    qihaoLable = qihaoLa;
    qihaoLable.text = [NSString stringWithFormat:@"第%@期  %@(%@)",round.issueNumber,timestr,[Utility weekDayGetForTimeString:timestr]];
    
    //处理开奖号码格式
    NSString *betCountStr = [NSString stringWithFormat: @"%@", round.openResult];
    NSArray *betnumArray = [[[betCountStr componentsSeparatedByString:@"#"] firstObject] componentsSeparatedByString:@","];
//    NSString *betNumStr = @"";
    for (int i=0; i<betnumArray.count; i++) {
        NSString *tempstr;
        tempstr = [NSString stringWithFormat:@"%02d",[betnumArray[i] intValue]];
        UIButton *bn=[redBalls objectAtIndex:i];
        [bn setTitle:tempstr forState:UIControlStateNormal];
//        betNumStr = [betNumStr stringByAppendingString:tempstr];
//        betNumStr = [betNumStr stringByAppendingString:@" "];
    }
    
//    firSectionNumLb.text = [NSString stringWithFormat:@"%@",betNumStr];
    //    firSectionNumLb.text = round.mainRes;
    
        NSString *betsubCountStr = [NSString stringWithFormat: @"%@", round.openResult];
        NSArray *betsubnumArray = [[[betsubCountStr componentsSeparatedByString:@"#"] lastObject] componentsSeparatedByString:@","];
//        NSString *betsubNumStr = @"";
        for (int i=0; i<betsubnumArray.count; i++) {
            NSString *tempsubstr;
            tempsubstr = [NSString stringWithFormat:@"%02d",[betsubnumArray[i] intValue]];
            UIButton *bn = [blueBalls objectAtIndex:i];
            [bn setTitle:tempsubstr forState:UIControlStateNormal];
//            betsubNumStr = [betNumStr stringByAppendingString:tempsubstr];
//            betsubNumStr = [betNumStr stringByAppendingString:@" "];
        }
    


}


- (void)setUpWithLottery:(Lottery *)lottery cellHeight:(float)cellH withSizeRatio:(NSString *)ratio{
    NSString * lotteryIdentify = lottery.identifier;
    
    NSArray * ratioArray = [ratio componentsSeparatedByString:@","];
    float total = 0;
    for (NSString * num in ratioArray) {
        total += [num floatValue];
    }
    CGFloat width = CGRectGetWidth(self.frame)/total;
    CGFloat height = cellH;
    float cur_x = 0;
    
    qihaoLable = [self lable:CGRectMake(cur_x, 0, width*[ratioArray[0] floatValue], height) textColor:TEXTGRAYCOLOR textAlignment:NSTextAlignmentCenter textFontSize:15];
    cur_x += CGRectGetWidth(qihaoLable.frame);
    
    UILabel * seperateLb = [self lable:CGRectMake(cur_x, 0, 1, height) textColor:nil textAlignment:NSTextAlignmentLeft textFontSize:12];
    seperateLb.backgroundColor = SEPCOLOR;
    
    firSectionNumLb = [self lable:CGRectMake(cur_x, 0, width*[ratioArray[1] floatValue], height) textColor:[UIColor redColor] textAlignment:NSTextAlignmentCenter textFontSize:15];

    cur_x += CGRectGetWidth(firSectionNumLb.frame);
    
    if ([lotteryIdentify isEqualToString:@"dlt"]) {
        UILabel * seperateLb = [self lable:CGRectMake(cur_x, 0, 1, height) textColor:nil textAlignment:NSTextAlignmentLeft textFontSize:12];
        seperateLb.backgroundColor = RGBCOLOR(180, 180, 180);
        secSectionNumLb = [self lable:CGRectMake(cur_x, 0, width*[ratioArray[2] floatValue], height) textColor:[UIColor blueColor] textAlignment:NSTextAlignmentCenter textFontSize:15];
    }
}

- (void)cellFillInfo:(DltOpenResult *)round{
    qihaoLable.text = [NSString stringWithFormat:@"第%@期",round.issueNumber];
    //处理开奖号码格式
    NSString *betCountStr = [NSString stringWithFormat: @"%@", round.openResult];
    NSArray *betnumArray = [betCountStr componentsSeparatedByString:@"#"];
    NSArray *redNum = [[betnumArray firstObject] componentsSeparatedByString:@","];
    NSString *betNumStr = @"";
    for (int i=0; i<redNum.count; i++) {
        NSString *tempstr;
        tempstr = [NSString stringWithFormat:@"%02d",[redNum[i] intValue]];
        betNumStr = [betNumStr stringByAppendingString:tempstr];
        betNumStr = [betNumStr stringByAppendingString:@" "];
    }

    firSectionNumLb.text = [NSString stringWithFormat:@"%@",betNumStr];

    
    NSArray *betsubnumArray = [[betnumArray lastObject] componentsSeparatedByString:@","];
        NSString *betsubNumStr = @"";
        for (int i=0; i<betsubnumArray.count; i++) {
            NSString *tempsubstr;
            tempsubstr = [NSString stringWithFormat:@"%02d",[betsubnumArray[i] intValue]];
            betsubNumStr = [betNumStr stringByAppendingString:tempsubstr];
            betsubNumStr = [betNumStr stringByAppendingString:@" "];
        }
//        secSectionNumLb.text = round.subRes;
    
}

#pragma privite methods

- (UILabel *)lable:(CGRect)frame textColor:(UIColor *)color textAlignment:(NSTextAlignment)alignment textFontSize:(int)fontSize{
    UILabel * lable = [[UILabel alloc] initWithFrame:frame];
    lable.textColor = color;
    lable.font = [UIFont fontWithName:@"Helvetica" size:fontSize];
    lable.textAlignment = alignment;
    [self addSubview:lable];
    return lable;
}

@end
