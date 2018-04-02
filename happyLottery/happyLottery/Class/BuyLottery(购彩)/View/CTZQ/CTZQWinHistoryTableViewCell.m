//
//  CTZQWinHistoryTableViewCell.m
//  Lottery
//
//  Created by LC on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQWinHistoryTableViewCell.h"

@implementation CTZQWinHistoryTableViewCell

- (void)awakeFromNib {
    // Initialization code
    CGFloat topLeading = 31 + 10;
    CGFloat leftLeading = 18;
    CGFloat sep = 1;
    CGFloat laWidth = (KscreenWidth - leftLeading - 38 - 13)/(14*sep);
    CGFloat laHeight = 26;
    for (NSInteger i = 0; i<14;i++) {
        UILabel *laTemp = [[UILabel alloc] initWithFrame:CGRectMake(leftLeading + i *(laWidth + sep), topLeading, laWidth, laHeight)];
        laTemp.backgroundColor = [UIColor clearColor];
        laTemp.layer.backgroundColor = TextCTZQGreen.CGColor;
        laTemp.tag = 1000+i;
        
        
        laTemp.textColor = [UIColor whiteColor];
        laTemp.textAlignment = NSTextAlignmentCenter;
        [self.contentView addSubview:laTemp];
    }
    self.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    self.accessoryView = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"kaijiangarrows"]];

}
/**
 *  刷新cell数据  根据cell的model
 */

- (void)cellFillInfo:(LotteryRound *)round{
    NSString* timestr = [NSString stringWithFormat:@"%@",round.stopTime];
    NSInteger length = [timestr length];
    if(length > 10)
    {
        timestr = [timestr substringToIndex:10];
    }

    _labMatchDate.text = [NSString stringWithFormat:@"第%@期  %@(%@)",round.issueNumber,timestr,[Utility weekDayGetForTimeString:timestr]];
    NSString *betCountStr = [NSString stringWithFormat: @"%@", round.mainRes];
    NSArray *betnumArray = [betCountStr componentsSeparatedByString:@" "];
    
    for (NSInteger i=0 ; i<14; i++) {
        if (betnumArray.count <= i) {
            break;
        }
        UILabel *lab = (UILabel *)[self viewWithTag:1000+i];
        if ([betnumArray[i] isEqualToString:@"--"]) {
            lab.text = @"*";
        }else{
            lab.text = betnumArray[i];
        }
        
    }
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
