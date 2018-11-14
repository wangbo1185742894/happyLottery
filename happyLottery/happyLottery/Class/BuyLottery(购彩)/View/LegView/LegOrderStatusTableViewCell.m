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
#define WaitKaiJiang     @"待开奖"
#define ReturnMoney      @"已退款"



@interface LegOrderStatusTableViewCell ()

@property (weak, nonatomic) IBOutlet UILabel *zhiFuStatus;

@property (weak, nonatomic) IBOutlet UIImageView *zhiFuImg;

@property (weak, nonatomic) IBOutlet UILabel *chuPiaoStatue;

@property (weak, nonatomic) IBOutlet UIImageView *chuPiaoImg;

@property (weak, nonatomic) IBOutlet UILabel *zhongJiangStatus;

@property (weak, nonatomic) IBOutlet UIImageView *zhongJiangImage;

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

- (void)loadZhuiHaoNewDate:(NSString *)orderStatus andWon:(NSString *)won{
    _zhiFuStatus.text = AlreadyZhiFu;
    [self imageWithState:@"already" andImage:self.zhiFuImg];
    _chuPiaoStatue.text = orderStatus;
    if ([orderStatus isEqualToString:@"追号中"]) {
        if ([won isEqualToString:@"未中"] || won.length == 0) { //未中奖
            [self imageWithState:@"now" andImage:self.chuPiaoImg];
            self.zhongJiangImage.hidden = YES;
            _zhongJiangStatus.hidden = YES;
            self.labelWidth.constant = self.chuPiaoImg.mj_x-30;
        }else if ([won isEqualToString:@"已中"]){
            [self imageWithState:@"already" andImage:self.chuPiaoImg];
            [self imageWithState:@"now" andImage:self.zhongJiangImage];
            _zhongJiangStatus.text = @"已中奖";
            self.labelWidth.constant = self.zhongJiangImage.mj_x-30;
        }
    } else if ([orderStatus isEqualToString:@"已停追"]||[orderStatus isEqualToString:@"撤销追号"]||[orderStatus isEqualToString:@"追号结束"]){
        [self imageWithState:@"already" andImage:self.chuPiaoImg];
        [self imageWithState:@"now" andImage:self.zhongJiangImage];
        self.labelWidth.constant = self.zhongJiangImage.mj_x-30;
        if ([won isEqualToString:@"未中"]) {
            _zhongJiangStatus.text = @"未中奖";
        }else if ([won isEqualToString:@"待开"]){
            _zhongJiangStatus.text = @"待开奖";
            [self imageWithState:@"now" andImage:self.chuPiaoImg];
            _zhongJiangStatus.hidden = YES;
            self.zhongJiangImage.hidden = YES;
            self.labelWidth.constant = self.chuPiaoImg.mj_x-30;
        }
        else {
            _zhongJiangStatus.text = @"已中奖";
        }
    }
    else {  //全部出票失败
        [self imageWithState:@"now" andImage:self.chuPiaoImg];
        _chuPiaoStatue.text = @"出票失败";
        self.zhongJiangImage.hidden = YES;
        _zhongJiangStatus.hidden = YES;
        self.labelWidth.constant = self.chuPiaoImg.mj_x-30;
    }
    
}

- (void)loadNewDate:(NSString *)orderStatus{
    
    _zhiFuStatus.text = AlreadyZhiFu;
   if ([orderStatus isEqualToString:@"未中奖"] ||[orderStatus isEqualToString:@"已中奖"]||
       [orderStatus isEqualToString:@"待开奖"]) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = orderStatus;
       [self imageWithState:@"already" andImage:self.zhiFuImg];
       [self imageWithState:@"already" andImage:self.chuPiaoImg];
       [self imageWithState:@"now" andImage:self.zhongJiangImage];

    }else if ([orderStatus isEqualToString:@"已出票"]||[orderStatus isEqualToString:@"部分出票"]) {
        _chuPiaoStatue.text = AlreadyChuPiao;
        _zhongJiangStatus.text = WaitKaiJiang;
        [self imageWithState:@"already" andImage:self.zhiFuImg];
        [self imageWithState:@"now" andImage:self.chuPiaoImg];
        [self imageWithState:@"will" andImage:self.zhongJiangImage];

    }else if ([orderStatus isEqualToString:@"出票失败"] || [orderStatus isEqualToString:@"已退款"]) {
        _chuPiaoStatue.text = DotChuPiao;
        _zhongJiangStatus.text = ReturnMoney;
        [self imageWithState:@"already" andImage:self.zhiFuImg];
        [self imageWithState:@"already" andImage:self.chuPiaoImg];
        [self imageWithState:@"now" andImage:self.zhongJiangImage];
    }else if ([orderStatus isEqualToString:@"出票中"]||[orderStatus isEqualToString:@"已支付"]){
        _chuPiaoStatue.text = @"出票中";
        _zhongJiangStatus.text = WaitKaiJiang;
        [self imageWithState:@"already" andImage:self.zhiFuImg];
        [self imageWithState:@"now" andImage:self.chuPiaoImg];
        [self imageWithState:@"will" andImage:self.zhongJiangImage];
    }
    self.labelWidth.constant = self.zhongJiangImage.mj_x-30;
}

- (UIImageView *)imageWithState:(NSString *)status  andImage:(UIImageView *)image{
    if ([status isEqualToString:@"already"]) {  //过去时
        [image setImage:[UIImage imageNamed:@"leg_already.png"]];
    } else if([status isEqualToString:@"now"]){  //进行时
        [image setImage:[UIImage imageNamed:@"leg_orangeDa.png"]];
    } else {  //将来时
        [image setImage:[UIImage imageNamed:@"leg_orange.png"]];
    }
    return image;
}

@end
