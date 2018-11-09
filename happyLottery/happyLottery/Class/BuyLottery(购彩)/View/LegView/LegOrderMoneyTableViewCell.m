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
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionToOrderDetail:(id)sender {
    [self.delegate showOrderDetail];
}


- (void)setFrame:(CGRect)frame{
    frame.origin.x += 6;
    frame.size.width -= 12;
    [super setFrame:frame];
}

- (void)loadZhuiHaoNewDate:(OrderProfile *)detail andStatus:(NSString *)orderStatus andName:(NSString *)name{
    self.orderCost.text = [NSString stringWithFormat:@"订单总额%@元",detail.sumSub];
    if ([orderStatus isEqualToString:@"派奖中"]) {
        self.orderStatue.text = OrderStatueZhong(detail.sumDraw);
    }else if ([orderStatus isEqualToString:@"已派奖"]) {
        self.orderStatue.text = OrderStatuePai(detail.sumDraw);
    }else if ([orderStatus isEqualToString:@"未中奖"] ) {
        self.orderStatue.text = OrderStatueLose;
    }else if ([orderStatus isEqualToString:@"待开奖"]) {
        self.orderStatue.text = @"等待开奖";
    } else if([orderStatus isEqualToString:@"已退款"]){
        self.orderStatue.text = OrderStatueTui(detail.sumSub);
    } else {
        self.orderStatue.text = OrderStatueWait(name);
    }
}

- (void)loadNewDate:(JCZQSchemeItem *)detail andStatus:(NSString *)orderStatus{
    self.orderCost.text = [NSString stringWithFormat:@"订单总额%@元",detail.betCost];
    if ([orderStatus isEqualToString:@"派奖中"]) {
        self.orderStatue.text = OrderStatueZhong(detail.bonus);
    } else if ([orderStatus isEqualToString:@"已派奖"]) {
        self.orderStatue.text = OrderStatuePai(detail.bonus);
    } else if ([orderStatus isEqualToString:@"未中奖"] ){
        self.orderStatue.text = OrderStatueLose;

    }else if ([orderStatus isEqualToString:@"出票失败"] || [orderStatus isEqualToString:@"已退款"]){
         self.orderStatue.text = OrderStatueTui(detail.ticketFailRef);
    }else if ([orderStatus isEqualToString:@"待开奖"]){
        self.orderStatue.text = @"待开奖";
    }else if ([orderStatus isEqualToString:@"待支付"]){
        self.orderStatue.text = OrderStatueWait(detail.legName);
    }else {
        self.orderStatue.text = OrderStatueWait(detail.legName);
    }
}



@end
