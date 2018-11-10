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

@property (weak, nonatomic) IBOutlet UILabel *yuanJiaoLab;

@end

@implementation LegOrderMoneyTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.yuanJiaoLab.layer.masksToBounds = YES;
    self.yuanJiaoLab.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionToOrderDetail:(id)sender {
    [self.delegate showOrderDetail];
}

- (void)loadZhuiHaoNewDate:(OrderProfile *)detail andStatus:(NSString *)orderStatus andName:(NSString *)name andWon:(BOOL)won{
    if (name.length == 0) {
        name = @"";
    }
    self.orderCost.text = [NSString stringWithFormat:@"订单总额%@元",detail.sumSub];
    if (won) {  //中奖
        self.orderStatue.text = [NSString stringWithFormat:@"已中奖%.2f",[detail.sumDraw doubleValue]];
    } else if ([orderStatus isEqualToString:@"追号中"]) {
        self.orderStatue.text = @"等待开奖";
    }else if ([orderStatus isEqualToString:@"出票失败"]) {
        self.orderStatue.text = OrderStatueTui(detail.sumSub);
    }else {
        self.orderStatue.text = OrderStatueLose;
    }
}

- (void)loadNewDate:(JCZQSchemeItem *)detail andStatus:(NSString *)orderStatus{
    self.orderCost.text = [NSString stringWithFormat:@"订单总额%@元",detail.betCost];
    if ([orderStatus isEqualToString:@"未中奖"] ){
        self.orderStatue.text = OrderStatueLose;
    }else if ([orderStatus isEqualToString:@"出票失败"] || [orderStatus isEqualToString:@"已退款"]){
         self.orderStatue.text = OrderStatueTui(detail.ticketFailRef);
    }else if ([orderStatus isEqualToString:@"待开奖"]){
        self.orderStatue.text = @"等待开奖";
    }else if ([orderStatus isEqualToString:@"待支付"]){
        self.orderStatue.text = OrderStatueWait(detail.legName);
    }else if ([orderStatus isEqualToString:@"已支付"]){
        self.orderStatue.text = @"出票中";
    }else if ([orderStatus isEqualToString:@"已中奖"]){
        self.orderStatue.text = [NSString stringWithFormat:@"已中奖%.2f元",[detail.bonus doubleValue] ];
    }
}



@end
