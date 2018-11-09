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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightThree;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightTwo;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageHeightOne;

@end

@implementation LegOrderStatusTableViewCell

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

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 6;
    frame.origin.y += 6;
    frame.size.height -= 6;
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
    _zhiFuStatus.text = AlreadyZhiFu;
    if ([orderStatus isEqualToString:@"派奖中"]) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = PaiJiang;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightOne.constant = 10;
        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;
        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightThree.constant = 14.5;
    }
    if ([orderStatus isEqualToString:@"已派奖"]) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = AlreadyPaiJiang;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightOne.constant = 10;
        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;

        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightThree.constant = 14.5;

    }
    if ([orderStatus isEqualToString:@"未中奖"] ) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = NotWin;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightOne.constant = 10;

        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;

        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightThree.constant = 14.5;

    }
    if ([orderStatus isEqualToString:@"待开奖"]) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = WaitKaiJiang;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightOne.constant = 10;

        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;

        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightThree.constant = 14.5;

    }
    if ([orderStatus isEqualToString:@"已出票"]) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = WaitKaiJiang;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightOne.constant = 10;

        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightTwo.constant = 14.5;

        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightThree.constant = 10;

    }
    if ([orderStatus isEqualToString:@"已支付"]) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = WaitKaiJiang;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightOne.constant = 14.5;

        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;

        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightThree.constant = 10;

    }
    if ([orderStatus isEqualToString:@"投注单失败，支付成功，超时未出票"] || [orderStatus isEqualToString:@"投注单失败，支付成功，限号原因未出票"]|| [orderStatus isEqualToString:@"投注单失败，支付成功，未知原因未出票"]) {
        _chuPiaoStatue.text = DotChuPiao;
        _zhongJiangStatus.text = ReturnMoney;
    }
}

@end
