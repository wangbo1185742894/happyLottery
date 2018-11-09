//
//  LegOrderIntroTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegOrderIntroTableViewCell.h"

#define OrderTijiao @"您提交了订单"
#define OrderTijiaoTouZhu @"您提交了投注单"
#define OrderYiJie(Name)     [NSString stringWithFormat:@"%@已接单",Name];
#define OrderYiZhiFu(Name)     [NSString stringWithFormat:@"订单已支付成功，%@将在5分钟内替您到线下彩票站出票",Name];
#define OrderYiDaoChuPiao(Name)   [NSString stringWithFormat:@"%@已到达彩票站，并成功出票",Name];

#define OrderYiDaoChuPiaoBuFen(Name,Money)   [NSString stringWithFormat:@"%@已到达彩票站，并部分出票，未出票部分共计%@元将在30分钟内退还到您的小哥余额中。",Name,Money];

#define OrderChaoshiWeiChuPiao(Money)   [NSString stringWithFormat:@"超时未出票，订单取消，平台将在10分钟内返还%@元给您",Money];

#define OrderXianHaoChuPiaoShiBai(Money)   [NSString stringWithFormat:@"限号导致订单失败，平台将在10分钟内返还%@元给您",Money];

#define OrderShiBai(Money)   [NSString stringWithFormat:@"订单失败，平台将在10分钟内返还%@元给您",Money];

#define DingDanWin(Name) [NSString stringWithFormat:@"订单已中奖！%@将在2小时内兑奖",Name];

#define DingDanFanHuan(Money) [NSString stringWithFormat:@"已将%@元返还至您在该账户的存款中，请查收",Money];

#define OrderWeiWin   @"订单未中奖"

#define OrderFanJiang(Name,Money) [NSString stringWithFormat:@"%@已将奖金%@元返还至您在该账户的存款中，请查收",Name,Money];

#define OrderZhuiHaoQingKuang(Name,zhuiQi,zongQi) [NSString stringWithFormat:@"%@已到达彩票站，已开始追号%@/%@.",Name,zhuiQi,zongQi];

#define OrderZhuiHaoJiXu(zhuiQi,Name) [NSString stringWithFormat:@"在追第%@期中奖，继续追号。%@将在2小时内兑奖",zhuiQi,Name];

#define OrderZhuiHaoJieShu @"追号已结束，订单未中奖"

#define OrderZhuiTingZhi(zhuiQi,Name) [NSString stringWithFormat:@"在追第%@期中奖，已停止追号。%@将在2小时内兑奖",zhuiQi,Name];


#define OrderZhuiTingFanJiang(Name,Money) [NSString stringWithFormat:@"追号已结束，%@已将奖金%@元返还至您在该账户的存款中，请查收",Name,Money];

@implementation LegOrderIntroTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    
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
- (void)loadNewDate:(NSString *)orderStatus{
    if ([orderStatus isEqualToString:@"已中奖,全部出票成功，派奖中"]) {
        self.orderInfoLab.text = OrderYiDaoChuPiao(@"");
    }
    if ([orderStatus isEqualToString:@"已中奖,部分出票成功，派奖中"]) {
        
    }
    if ([orderStatus isEqualToString:@"已中奖,全部出票成功，已派奖"]||[orderStatus isEqualToString:@"已中奖,部分出票成功，已派奖"]) {
        
    }
    if ([orderStatus isEqualToString:@"未中奖，全部出票成功"] || [orderStatus isEqualToString:@"未中奖，部分出票成功"]) {
        
    }
    if ([orderStatus isEqualToString:@"投注单失败，支付成功，超时未出票"] || [orderStatus isEqualToString:@"投注单失败，支付成功，限号原因未出票"]|| [orderStatus isEqualToString:@"投注单失败，支付成功，未知原因未出票"]) {
      
    }
    if ([orderStatus isEqualToString:@"待开奖"]) {
     
    }
    if ([orderStatus isEqualToString:@"已中奖,追号停追，派奖中"]||[orderStatus isEqualToString:@"已中奖,追号不停追，派奖中"]) {
        
    }
    if ([orderStatus isEqualToString:@"已中奖,追号停追，已派奖"]||[orderStatus isEqualToString:@"已中奖,追号不停追，已派奖"]) {
      
    }
    if ([orderStatus isEqualToString:@"未中奖"]) {
       
    }
    if ([orderStatus isEqualToString:@"待开奖"]) {
  
    }
}

- (void)reloadDate:(NSDictionary *)dic {
    self.orderTimeLab.text = dic[@"timeLab"];
    self.orderInfoLab.text = dic[@"infoLab"];
}

@end
