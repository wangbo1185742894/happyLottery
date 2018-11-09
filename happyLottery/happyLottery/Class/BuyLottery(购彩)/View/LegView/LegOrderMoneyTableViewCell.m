//
//  LegOrderMoneyTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//


#import "LegOrderMoneyTableViewCell.h"

#define OrderStatueZhong(Money)     [NSString stringWithFormat:@"等待派奖%@元",Money];
#define OrderStatuePai(Money)     [NSString stringWithFormat:@"已派奖%@元",Money];
#define OrderStatueLose    @"很遗憾，祝您下次好运"
#define OrderStatueTui(Money)     [NSString stringWithFormat:@"已退款%@元",Money];
#define OrderStatueWait(Name)     [NSString stringWithFormat:@"%@已就位，时刻等待为您服务",Name];

@interface LegOrderMoneyTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *orderStatue;

@property (weak, nonatomic) IBOutlet UILabel *orderCost;

@end

@implementation LegOrderMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

/**
 非追号状态：
 1.已中奖,全部出票成功，派奖中
 2.已中奖,部分出票成功，派奖中
 3.已中奖,全部出票成功，已派奖
 4.已中奖,部分出票成功，已派奖
 5.未中奖，全部出票成功
 6,未中奖，部分出票成功
 7，投注单失败，支付成功，超时未出票
 8，投注单失败，支付成功，限号原因未出票
 9，投注单失败，支付成功，未知原因未出票
 10，待开奖
 追号状态：
 1.已中奖,追号停追，派奖中
 1.已中奖,追号不停追，派奖中
 1.已中奖,追号停追，已派奖
 1.已中奖,追号不停追，已派奖
 1.未中奖
 1.待开奖
 @param orderStatus 订单状态
 */
- (void)loadNewDate:(JCZQSchemeItem *)detail andStatus:(NSString *)orderStatus{
    self.orderCost.text = [NSString stringWithFormat:@"订单总额%@元",detail.betCost];
    if ([orderStatus isEqualToString:@"派奖中"]) {
        self.orderStatue.text = OrderStatueZhong(detail.bonus);
    }
    if ([orderStatus isEqualToString:@"已派奖"]) {
        self.orderStatue.text = OrderStatuePai(detail.bonus);
    }
    if ([orderStatus isEqualToString:@"未中奖"] ) {
        self.orderStatue.text = OrderStatueLose;
    }
    if ([orderStatus isEqualToString:@"投注单失败，支付成功，超时未出票"] || [orderStatus isEqualToString:@"投注单失败，支付成功，限号原因未出票"]|| [orderStatus isEqualToString:@"投注单失败，支付成功，未知原因未出票"]) {
        self.orderStatue.text = OrderStatueTui(@"22");
    }
    if ([orderStatus isEqualToString:@"待开奖"] || [orderStatus isEqualToString:@"待支付"]) {
        self.orderStatue.text = OrderStatueWait(detail.legName);
    }
}



@end
