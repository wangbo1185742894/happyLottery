//
//  LegOrderStatusTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegOrderStatusTableViewCell.h"
#define AlreadyZhiFu     @"线下已支付"
#define AlreadyChuPiao   @"彩票站已出票"
#define DotChuPiao       @"彩票站未出票"
#define PaiJiang         @"派奖中"
#define AlreadyPaiJiang  @"已派奖"
#define NotWin           @"未中奖"
#define WaitKaiJiang     @"待开奖"
#define ReturnMoney      @"已退款"

@interface LegOrderStatusTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *zhiFuStatus;

@property (weak, nonatomic) IBOutlet UIImageView *zhiFuImg;

@property (weak, nonatomic) IBOutlet UILabel *chuPiaoStatue;

@property (weak, nonatomic) IBOutlet UIImageView *chuPiaoImg;

@property (weak, nonatomic) IBOutlet UILabel *zhongJiangStatus;

@property (weak, nonatomic) IBOutlet UIImageView *zhongJiangImage;

@end

@implementation LegOrderStatusTableViewCell

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
        _zhiFuStatus.text = AlreadyZhiFu;
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = PaiJiang;
    }
    if ([orderStatus isEqualToString:@"已中奖,全部出票成功，已派奖"]||[orderStatus isEqualToString:@"已中奖,部分出票成功，已派奖"]) {
        _zhiFuStatus.text = AlreadyZhiFu;
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = AlreadyPaiJiang;
    }
    if ([orderStatus isEqualToString:@"未中奖，全部出票成功"] || [orderStatus isEqualToString:@"未中奖，部分出票成功"]) {
        _zhiFuStatus.text = AlreadyZhiFu;
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = NotWin;
    }
    if ([orderStatus isEqualToString:@"投注单失败，支付成功，超时未出票"] || [orderStatus isEqualToString:@"投注单失败，支付成功，限号原因未出票"]|| [orderStatus isEqualToString:@"投注单失败，支付成功，未知原因未出票"]) {
        _zhiFuStatus.text = AlreadyZhiFu;
        _chuPiaoStatue.text = DotChuPiao;
        _zhongJiangStatus.text = ReturnMoney;
    }
    if ([orderStatus isEqualToString:@"待开奖"]) {
        _zhiFuStatus.text = AlreadyZhiFu;
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = WaitKaiJiang;
    }
    if ([orderStatus isEqualToString:@"已中奖,追号停追，派奖中"]||[orderStatus isEqualToString:@"已中奖,追号不停追，派奖中"]) {
        _zhiFuStatus.text = AlreadyZhiFu;
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = PaiJiang;
    }
    if ([orderStatus isEqualToString:@"已中奖,追号停追，已派奖"]||[orderStatus isEqualToString:@"已中奖,追号不停追，已派奖"]) {
        _zhiFuStatus.text = AlreadyZhiFu;
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = AlreadyPaiJiang;
    }
    if ([orderStatus isEqualToString:@"未中奖"]) {
        _zhiFuStatus.text = AlreadyZhiFu;
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = NotWin;
    }
    if ([orderStatus isEqualToString:@"待开奖"]) {
        _zhiFuStatus.text = AlreadyZhiFu;
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = WaitKaiJiang;
    }
}

@end
