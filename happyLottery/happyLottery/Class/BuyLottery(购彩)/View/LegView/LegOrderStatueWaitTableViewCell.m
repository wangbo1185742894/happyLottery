//
//  LegOrderStatueWaitTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/11/7.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegOrderStatueWaitTableViewCell.h"

@implementation LegOrderStatueWaitTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
}

- (IBAction)actionToRecharege:(id)sender {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [dateFormatter dateFromString:self.timeStr];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 比较时间
    NSDateComponents *components = [calendar components:NSCalendarUnitMinute fromDate:[NSDate date] toDate:oldDate options:0];
    if (components.minute >= 1) {
        [self.delegate actionToRecharge];
    } else {
        BaseViewController *baseVC = (BaseViewController *)[self getCurrentVC];
        [baseVC showPromptText:@"发单方案赛事已截期，不能继续支付" hideAfterDelay:2.0];
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 6;
    frame.size.width -= 12;
    [super setFrame:frame];
}
@end
