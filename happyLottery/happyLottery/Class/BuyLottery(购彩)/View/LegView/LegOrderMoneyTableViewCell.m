//
//  LegOrderMoneyTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//


#import "LegOrderMoneyTableViewCell.h"

#define OrderStatueLose    @"很遗憾，祝您下次好运"
#define OrderStatueTui(Money)     [NSString stringWithFormat:@"已退款%@元",Money];
#define OrderStatueWait(Name)     [NSString stringWithFormat:@"%@已就位，请您尽快支付",Name];

@interface LegOrderMoneyTableViewCell()

@property (weak, nonatomic) IBOutlet UILabel *orderStatue;

@property (weak, nonatomic) IBOutlet UILabel *orderCost;

@property (weak, nonatomic) IBOutlet UILabel *yuanJiaoLab;
@property (weak, nonatomic) IBOutlet UILabel *schemeNo;

@property (weak, nonatomic) IBOutlet UIButton *orderBtn;

@property (nonatomic, strong)NSString *orderNo;


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

- (IBAction)fuZhiFangAnhao:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    BaseViewController *baseVC = (BaseViewController *)[self getCurrentVC];
    [baseVC showPromptText:@"方案号已复制到剪贴板" hideAfterDelay:2.0];
    pboard.string = self.orderNo;
}

- (void)loadZhuiHaoNewDate:(OrderProfile *)detail andStatus:(NSString *)orderStatus andName:(NSString *)name andWon:(NSString *)won{
    self.schemeNo.hidden = YES;
    self.orderBtn.hidden = YES;
    if (name.length == 0) {
        name = @"";
    }
    self.orderCost.text = [NSString stringWithFormat:@"订单总额%@元",detail.sumSub];
    if ([won isEqualToString:@"已中"]) {  //中奖
        self.orderStatue.text = [NSString stringWithFormat:@"已中奖%.2f",[detail.sumDraw doubleValue]];
    } else if ([orderStatus isEqualToString:@"追号中"]||[won isEqualToString:@"待开"]) {
        self.orderStatue.text = @"等待开奖";
    }else if ([orderStatus isEqualToString:@"出票失败"]) {
        self.orderStatue.text = OrderStatueTui(detail.sumSub);
    }else{
        self.orderStatue.text = OrderStatueLose;
    }
}

- (void)loadNewDate:(JCZQSchemeItem *)detail andStatus:(NSString *)orderStatus{
    self.schemeNo.hidden = YES;
    self.orderBtn.hidden = YES;
    self.orderCost.text = [NSString stringWithFormat:@"订单总额%@元",detail.betCost];
    if ([orderStatus isEqualToString:@"未中奖"] ){
        self.orderStatue.text = OrderStatueLose;
    }else if ([orderStatus isEqualToString:@"出票失败"] || [orderStatus isEqualToString:@"已退款"]){
         self.orderStatue.text = OrderStatueTui(detail.ticketFailRef);
    }else if ([orderStatus isEqualToString:@"待开奖"]){
        self.orderStatue.text = @"等待开奖";
    }else if ([orderStatus isEqualToString:@"待支付"]){
        self.orderNo = detail.schemeNO;
        self.schemeNo.hidden = NO;
        self.orderBtn.hidden = NO;
        self.orderStatue.text = OrderStatueWait(detail.legName);
        self.schemeNo.text = [NSString stringWithFormat:@"方案号：%@",detail.schemeNO];
    }else if ([orderStatus isEqualToString:@"已支付"]){
        self.orderStatue.text = @"彩票站出票中";
    }else if ([orderStatus isEqualToString:@"已中奖"]){
        self.orderStatue.text = [NSString stringWithFormat:@"已中奖%.2f元",[detail.bonus doubleValue] ];
    }
}



@end
