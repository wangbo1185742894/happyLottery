//
//  MyCouponTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2017/12/28.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "MyCouponTableViewCell.h"

@implementation MyCouponTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)loadData:(Coupon *)model{
    self.endImage.hidden = YES;
    self.priceLab.adjustsFontSizeToFitWidth = YES;
    self.labX.hidden = YES;
    self.labNum.hidden = YES;
    self.btnSelect.hidden = NO;
    self.btnSelect.selected = model.isSelect;
    NSString *deduction =model.deduction;
    self.priceLab.text = deduction;
    self.nameLab.text =[NSString stringWithFormat:@"¥%@元优惠券",deduction];
    
    self.sourceLab.text = [NSString stringWithFormat:@"%@",model.couponSource];
    self.dateLab.text = [NSString stringWithFormat:@"截止时间：%@",model.invalidTime];
    self.descriptionLab.text=[NSString stringWithFormat:@"单笔订单满%@可用",model.quota];
    self.bjImage.image = [UIImage imageNamed:@"bjCoupon"];
}

@end
