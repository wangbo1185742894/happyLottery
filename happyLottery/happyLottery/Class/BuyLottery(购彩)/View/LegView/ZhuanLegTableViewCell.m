//
//  ZhuanLegTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/10/31.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ZhuanLegTableViewCell.h"


@interface ZhuanLegTableViewCell()

@property (weak, nonatomic) IBOutlet UIButton *selectBackGroup;

@property (weak, nonatomic) IBOutlet UIImageView *legIcon;

@property (weak, nonatomic) IBOutlet UILabel *legName;
@property (weak, nonatomic) IBOutlet UILabel *renZheng;
@property (weak, nonatomic) IBOutlet UILabel *onlineLab;
@property (weak, nonatomic) IBOutlet UILabel *protectMoney;
@property (weak, nonatomic) IBOutlet UILabel *legCost;
@property (weak, nonatomic) IBOutlet UILabel *usedLeg;
@property (weak, nonatomic) IBOutlet UILabel *leaveMoney;
@property (weak, nonatomic) IBOutlet UILabel *yuE;
@property (weak, nonatomic) IBOutlet UIButton *selectBtn;
@property (weak, nonatomic) IBOutlet UIButton *weChatLab;
@property (weak, nonatomic) IBOutlet UIButton *telephoneLab;

@end

@implementation ZhuanLegTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.layer.masksToBounds = YES;
    self.layer.cornerRadius = 8;
    self.weChatLab.layer.masksToBounds = YES;
    self.weChatLab.layer.cornerRadius = 4;
    self.weChatLab.layer.borderColor = SystemGreen.CGColor;
    self.weChatLab.layer.borderWidth = 1;
    
    self.telephoneLab.layer.masksToBounds = YES;
    self.telephoneLab.layer.cornerRadius = 4;
    self.telephoneLab.layer.borderColor = SystemGreen.CGColor;
    self.telephoneLab.layer.borderWidth = 1;
}

- (void)setFrame:(CGRect)frame{
    frame.origin.x += 6;
    frame.origin.y += 6;
    frame.size.height -= 6;
    frame.size.width -= 12;
    [super setFrame:frame];
}

- (void)loadLegDate:(PostboyAccountModel *)legModel{
    self.selectBackGroup.selected = legModel.isSelect;
    self.legName.text = legModel.postboyName;
    //余额
    if (legModel.totalBalance.length == 0) {
        self.yuE.hidden = YES;
        self.leaveMoney.hidden = YES;
    } else {
        self.yuE.text = [NSString stringWithFormat:@"%.2f元",[legModel.totalBalance doubleValue]];
        self.leaveMoney.hidden = NO;
    }
    if (legModel.isSelect) {
        self.selectBtn.selected = YES;
    } else {
        self.selectBtn.selected = NO;
    }
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
