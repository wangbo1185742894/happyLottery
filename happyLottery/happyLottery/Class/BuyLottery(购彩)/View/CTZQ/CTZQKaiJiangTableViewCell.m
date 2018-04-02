//
//  CTZQKaiJiangTableViewCell.m
//  Lottery
//
//  Created by LC on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "CTZQKaiJiangTableViewCell.h"
@interface CTZQKaiJiangTableViewCell()<LotteryManagerDelegate>
{
     LotteryManager * lotteryMan;
    __weak IBOutlet UILabel *labelLotteryDesc_;
}
@property (nonatomic, strong)NSMutableArray *laArr;

@end

@implementation CTZQKaiJiangTableViewCell

- (void)awakeFromNib {
    _laArr = [[NSMutableArray alloc] init];
    CGFloat topLeading = 31 + 10;
    CGFloat leftLeading = 18;
    CGFloat sep = 1;
    CGFloat laWidth = (KscreenWidth - leftLeading - 38 - 13)/(14*sep);
    CGFloat laHeight = 26;
    for (NSInteger i = 0; i<14;i++) {
        UILabel *laTemp = [[UILabel alloc] initWithFrame:CGRectMake(leftLeading + i *(laWidth + sep), topLeading, laWidth, laHeight)];
        
        laTemp.backgroundColor = [UIColor clearColor];
        laTemp.layer.backgroundColor = TextCTZQGreen.CGColor;
        
//        laTemp.text = [NSString stringWithFormat:@"%@",@(i)];
        laTemp.textColor = [UIColor whiteColor];
        laTemp.textAlignment = NSTextAlignmentCenter;
        [_laArr addObject:laTemp];
        [self.contentView addSubview:laTemp];
        
    }
    
    // Initialization code
}
- (void)gotLotteryRounds:(NSArray *)rounds{
    NSLog(@"22345%@",rounds);
//    return;
    if(rounds == nil||rounds.count==0)
    {
        labelLotteryDesc_.text = @"未获取到开奖信息";
        self.userInteractionEnabled = NO;
        return;
    }
    self.userInteractionEnabled = YES;
    _curround  = rounds[0];
    NSString* timestr = [NSString stringWithFormat:@"%@",_curround.stopTime];
    if ([timestr isEqualToString:@""]) {
        labelLotteryDesc_.text = @"未获取到开奖信息";
        self.userInteractionEnabled = NO;
        return;
    }
    NSInteger length = [timestr length];
    if(length > 10)
    {
        timestr = [timestr substringToIndex:10];
    }
    NSString *lotteryRoundDesc= [NSString stringWithFormat:@"第%@期 %@(%@)",_curround.issueNumber,timestr,[Utility weekDayGetForTimeString:timestr]];
    labelLotteryDesc_.text = lotteryRoundDesc;
    
    NSArray *mainResNumStr = [_curround.mainRes componentsSeparatedByString:@" "];
//    if (mainResNumStr.count == 14) {
        for (NSInteger i = 0; i < _laArr.count; i++) {
                    UILabel *laTemp = _laArr[i];
            
            if (mainResNumStr.count <= i) {
                break;
            }
            if ([mainResNumStr[i] isEqualToString:@"--"]) {
                laTemp.text = @"*";
            }else{
                laTemp.text = mainResNumStr[i];
            }
        }
//    }
//    NSString *ctzqWinResultStr = [rounds firstObject];
//    NSArray *ctzqWinResultArr = [ctzqWinResultStr componentsSeparatedByString:@"-"];
//    for (NSInteger i = 0; i < _laArr.count; i++) {
//        UILabel *laTemp = _laArr[i];
//        laTemp.text = ctzqWinResultArr[i];
//    }
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
//    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


- (void)refreshWithInfo:(id)info{
    
}

- (void) updataInfo:(LotteryRound *)round{
    
}
- (void) setCellLottery: (Lottery *) lottery{
    NSLog(@"78789%@",lottery.identifier);
    lotteryMan = [[LotteryManager alloc] init];
    lotteryMan.delegate = self;
    NSLog(@"%@",lotteryMan);
    NSDictionary * getRoundNeedInfo = @{@"count":[NSString stringWithFormat:@"%d",1],@"identifier":lottery.identifier == nil?@"":lottery.identifier};
//    [lotteryMan getLotteryRoundInfo:getRoundNeedInfo];
}

@end
