//
//  SendPedPackCell.m
//  happyLottery
//
//  Created by LYJ on 2018/9/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SendPedPackCell.h"

@interface SendPedPackCell()

@property (weak, nonatomic) IBOutlet UIImageView *userImage;

@property (weak, nonatomic) IBOutlet UILabel *userNameLab;

@property (weak, nonatomic) IBOutlet UILabel *countMoney;

@property (weak, nonatomic) IBOutlet UILabel *countBuyLab;

@property (weak, nonatomic) IBOutlet UIButton *checkBtn;

@end

@implementation SendPedPackCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.userImage.clipsToBounds = NO;
    self.userImage.layer.cornerRadius = self.userImage.mj_h / 2;
    self.userImage.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)reloadDate:(RedPackCircleModal *)model{
    self.checkBtn.selected = model.isSelect;
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"usermine.png"]];
    self.userNameLab.text = model.nickName == nil?[model.mobile stringByReplacingCharactersInRange:NSMakeRange(3,4) withString:@"****"]:model.nickName;
    self.countMoney.text = [NSString stringWithFormat:@"%.2f",[model.totalCost doubleValue]];
    self.countBuyLab.text = [NSString stringWithFormat:@"%ld",[model.totalSubCount integerValue]];
}

@end
