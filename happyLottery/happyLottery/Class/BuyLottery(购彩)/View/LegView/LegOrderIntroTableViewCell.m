//
//  LegOrderIntroTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegOrderIntroTableViewCell.h"

#define OrderTijiao @"您提交了订单"
#define OrderYiJie(Name)     [NSString stringWithFormat:@"%@已接单",Name];
#define OrderYiZhiFu(Name)     [NSString stringWithFormat:@"订单已支付成功，%@将在5分钟内替您到线下彩票站出票",Name];
#define OrderYiDaoChuPiao(Name)   [NSString stringWithFormat:@"%@已到达彩票站，并成功出票",Name];


@implementation LegOrderIntroTableViewCell

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
- (void)loadNewDate:(NSString *)orderStatus{
    if ([orderStatus isEqualToString:@"已中奖,全部出票成功，派奖中"]||[orderStatus isEqualToString:@"已中奖,部分出票成功，派奖中"]) {
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

@end
