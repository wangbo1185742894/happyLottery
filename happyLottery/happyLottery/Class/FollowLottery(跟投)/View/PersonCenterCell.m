//
//  PersonCenterCell.m
//  happyLottery
//
//  Created by LYJ on 2018/5/11.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "PersonCenterCell.h"


@implementation PersonCenterCell{
    
}

- (void)awakeFromNib {
    [super awakeFromNib];
    self.label_urlsImage.clipsToBounds = NO;
    self.label_urlsImage.contentMode = UIViewContentModeScaleAspectFit;
    self.userImage.clipsToBounds = NO;
    self.userImage.contentMode = UIViewContentModeScaleAspectFit;
    self.userImage.layer.cornerRadius = self.userImage.mj_h / 2;
    self.userImage.layer.masksToBounds = YES;
    self.initiateStatusFirst.layer.cornerRadius = self.initiateStatusFirst.mj_h / 2;
    self.initiateStatusFirst.layer.masksToBounds = YES;
    self.initiateStatusTwo.layer.cornerRadius = self.initiateStatusTwo.mj_h / 2;
    self.initiateStatusTwo.layer.masksToBounds = YES;
    self.initiateStatusThird.layer.cornerRadius = self.initiateStatusThird.mj_h / 2;
    self.initiateStatusThird.layer.masksToBounds = YES;
    self.initiateStatusForth.layer.cornerRadius = self.initiateStatusForth.mj_h / 2;
    self.initiateStatusForth.layer.masksToBounds = YES;
    self.initiateStatusFifth.layer.cornerRadius = self.initiateStatusFifth.mj_h / 2;
    self.initiateStatusFifth.layer.masksToBounds = YES;
    self.
    self.noticeBtn.layer.masksToBounds = YES;
    self.noticeBtn.layer.borderWidth = 1;
    self.noticeBtn.layer.borderColor = [UIColor whiteColor].CGColor;
    self.noticeBtn.layer.cornerRadius = 3;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}

- (void)reloadCell:(PersonCenterModel *)model  isAttend:(BOOL)isAttend{
    [self.label_urlsImage sd_setImageWithURL:[NSURL URLWithString:model.label_urls]];
    NSString *str = isAttend?@"已关注":@"+ 关注";
    [self.noticeBtn setTitle:str forState:UIControlStateNormal];
    [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.headUrl] placeholderImage:[UIImage imageNamed:@"usermine.png"]];
    self.userName.text = model.nickName==nil?[model.cardCode stringByReplacingCharactersInRange:NSMakeRange(2,4) withString:@"****"]:model.nickName;
    
    self.fenshiNum.text = [NSString stringWithFormat:@"粉丝 %d人",[model.attentCount intValue]];
    self.initiateStatusSum.text = [NSString stringWithFormat:@"%.2f元",[model.totalInitiateBonus  doubleValue]];
    NSArray *array = [model.initiateStatus componentsSeparatedByString:@","];
    switch (array.count) {
        case 0:
            self.initiateStatusFirst.hidden = YES;
            self.initiateStatusTwo.hidden = YES;
            self.initiateStatusThird.hidden = YES;
            self.initiateStatusForth.hidden = YES;
            self.initiateStatusFifth.hidden = YES;
            self.picLianjie.constant = 0;
            self.picLian.hidden = YES;
            break;
        case 1:
            self.initiateStatusFirst.text = [array[0]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusFirst.hidden = NO;
            self.initiateStatusTwo.hidden = YES;
            self.initiateStatusThird.hidden = YES;
            self.initiateStatusForth.hidden = YES;
            self.initiateStatusFifth.hidden = YES;
            self.picLianjie.constant = 47;
            self.picLian.hidden = NO;
            break;
        case 2:
            self.initiateStatusFirst.text = [array[0]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusFirst.hidden = NO;
            self.initiateStatusTwo.text = [array[1]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusTwo.hidden = NO;
            self.initiateStatusThird.hidden = YES;
            self.initiateStatusForth.hidden = YES;
            self.initiateStatusFifth.hidden = YES;
            self.picLianjie.constant = 47+23;
            self.picLian.hidden = NO;
            break;
        case 3:
            self.initiateStatusFirst.text = [array[0]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusFirst.hidden = NO;
            self.initiateStatusTwo.text = [array[1]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusTwo.hidden = NO;
            self.initiateStatusThird.text = [array[2]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusThird.hidden = NO;
            self.initiateStatusForth.hidden = YES;
            self.initiateStatusFifth.hidden = YES;
            self.picLian.hidden = NO;
            self.picLianjie.constant = 47+23*2;
            break;
        case 4:
            self.initiateStatusFirst.text = [array[0]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusFirst.hidden = NO;
            self.initiateStatusTwo.text = [array[1]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusTwo.hidden = NO;
            self.initiateStatusThird.text = [array[2]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusThird.hidden = NO;
            self.initiateStatusForth.text = [array[3]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusForth.hidden = NO;
            self.initiateStatusFifth.hidden = YES;
            self.picLian.hidden = NO;
            self.picLianjie.constant = 47+23*3;
            break;
        case 5:
            self.initiateStatusFirst.text = [array[0]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusFirst.hidden = NO;
            self.initiateStatusTwo.text = [array[1]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusTwo.hidden = NO;
            self.initiateStatusThird.text = [array[2]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusThird.hidden = NO;
            self.initiateStatusForth.text = [array[3]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusForth.hidden = NO;
            self.initiateStatusFifth.text = [array[4]isEqualToString:@"1"]?@"中":@"未";
            self.initiateStatusFifth.hidden = NO;
            self.picLian.hidden = NO;
            self.picLianjie.constant = 189;
            break;
        default:
            break;
    }
}

- (IBAction)attendAction:(id)sender {
    [self.delegate addOrReliefAttend];
}

@end
