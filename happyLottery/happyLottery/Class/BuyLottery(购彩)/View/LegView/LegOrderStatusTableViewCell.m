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
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labelWidth;

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
    frame.size.width -= 12;
    [super setFrame:frame];
}


/**
 追号未结束
 1.已支付-追号中
 2.已中奖  已支付-追号中-已中奖
 
 追号结束
 1.未中奖   已支付-追号结束-未中奖
 2.已中奖   已支付-追号结束-已中奖
 3.全部出票失败  已支付—出票失败
 @param orderStatus 订单状态
 */
- (void)loadZhuiHaoNewDate:(NSString *)orderStatus andWon:(BOOL)won{
    _zhiFuStatus.text = AlreadyZhiFu;
    [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
    self.imageHeightOne.constant = 10;
    if ([orderStatus isEqualToString:@"追号中"]) {
        if (won == NO) { //未中奖
            [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
            self.imageHeightTwo.constant = 14.5;
            _chuPiaoStatue.text = @"追号中";
            self.zhongJiangImage.hidden = YES;
            _zhongJiangStatus.hidden = YES;
            self.labelWidth.constant = self.chuPiaoImg.mj_x-30;
        } else {
            [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
            self.imageHeightTwo.constant = 10;
            _chuPiaoStatue.text = @"追号中";
            [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
            self.imageHeightThree.constant = 14.5;
            _zhongJiangStatus.text = @"已中奖";
            self.labelWidth.constant = self.zhongJiangImage.mj_x-30;
        }
    } else if ([orderStatus isEqualToString:@"追号结束"]){
        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;
        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightThree.constant = 14.5;
        self.labelWidth.constant = self.zhongJiangImage.mj_x-30;
        if (won == NO) {
            _chuPiaoStatue.text = @"追号结束";
            _zhongJiangStatus.text = @"未中奖";
        } else {
            _chuPiaoStatue.text = @"追号结束";
            _zhongJiangStatus.text = @"已中奖";
            
        }
    } else {  //全部出票失败
        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightTwo.constant = 14.5;
        _chuPiaoStatue.text = @"出票失败";
        self.zhongJiangImage.hidden = YES;
        _zhongJiangStatus.hidden = YES;
        self.labelWidth.constant = self.chuPiaoImg.mj_x-30;
    }
    
}

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
    } else if ([orderStatus isEqualToString:@"已派奖"]) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = AlreadyPaiJiang;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightOne.constant = 10;
        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;

        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightThree.constant = 14.5;

    }else if ([orderStatus isEqualToString:@"未中奖"] ) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = NotWin;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightOne.constant = 10;

        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;

        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightThree.constant = 14.5;

    }else if ([orderStatus isEqualToString:@"待开奖"]) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = WaitKaiJiang;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightOne.constant = 10;

        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;

        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightThree.constant = 14.5;

    } else if ([orderStatus isEqualToString:@"已出票"]||[orderStatus isEqualToString:@"部分出票"]) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = WaitKaiJiang;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightOne.constant = 10;

        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightTwo.constant = 14.5;

        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightThree.constant = 10;

    }else if ([orderStatus isEqualToString:@"已支付"]) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = WaitKaiJiang;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightOne.constant = 14.5;

        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;

        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightThree.constant = 10;

    }else if ([orderStatus isEqualToString:@"出票失败"] || [orderStatus isEqualToString:@"已退款"]) {
        _chuPiaoStatue.text = DotChuPiao;
        _zhongJiangStatus.text = ReturnMoney;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightOne.constant = 10;
        
        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;
        
        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightThree.constant = 14.5;
    }else {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = WaitKaiJiang;
        [self.zhiFuImg setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
        self.imageHeightOne.constant = 14.5;
        
        [self.chuPiaoImg setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightTwo.constant = 10;
        
        [self.zhongJiangImage setImage:[UIImage imageNamed:@"leg_orange.png"]];
        self.imageHeightThree.constant = 10;
    }
    self.labelWidth.constant = self.zhongJiangImage.mj_x-30;
}

@end
