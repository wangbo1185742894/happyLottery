//
//  MyCircleFirendCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "MyCircleFirendCell.h"

@implementation MyCircleFirendCell

- (void)awakeFromNib {
    [super awakeFromNib];
   
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)loadDataLottery:(NSDictionary  *)itemDic andRate:(NSString *)rate{
    self.quanzhuImage.hidden = YES;
    self.labName.text = itemDic[@"lotteryName"];
    self.labTime.text = [NSString stringWithFormat:@"%.1f%%",[rate doubleValue] * 100];
    self.labTime.font = [UIFont systemFontOfSize:15];
    self.labTime.textColor = [UIColor redColor];
    if ([itemDic[@"lottery"] isEqualToString:@"GYJ"]) {
        [self.lmgIcon setImage:[UIImage imageNamed:[NSString stringWithFormat:@"icon_%@",itemDic[@"lotteryImageName"]]]];
    } else {
        [self.lmgIcon setImage:[UIImage imageNamed:itemDic[@"lotteryImageName"]]];
    }
    
    self.constLabel.constant = 61;
}

-(void)loadDataInQ:(AgentMemberModel *)model{
    if ([model.memberType isEqualToString:@"0"]) {
        self.quanzhuImage.hidden = NO;
    }
    else {
        self.quanzhuImage.hidden = YES;
    }
    self.labTime.hidden = YES;
    if (model.headUrl == nil) {
        self.lmgIcon.image = [UIImage imageNamed:@"usermine"];
    }else{
        [self.lmgIcon sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    }
    
    if (model.nickname == nil) {
        self.labName.text = [model.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else{
        self.labName.text = model.nickname;
    }
    self.constLabel.constant = 0;
    self.lmgIcon.layer.cornerRadius = self.lmgIcon.mj_h/ 2;
    self.lmgIcon.layer.masksToBounds = YES;
    self.bottomLabel.hidden = NO;
}

-(void)loadData:(AgentMemberModel *)model{
    self.quanzhuImage.hidden = YES;
    self.labTime.text = [model.createTime substringFromIndex:10];
    self.labTime.hidden = NO;
    if (model.headUrl == nil) {
        self.lmgIcon.image = [UIImage imageNamed:@"usermine"];
    }else{
        [self.lmgIcon sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    }
    
    if (model.nickname == nil) {
        self.labName.text = [model.mobile stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else{
        self.labName.text = model.nickname;
    }
    self.constLabel.constant = 0;
    self.lmgIcon.layer.cornerRadius = self.lmgIcon.mj_h/ 2;
    self.lmgIcon.layer.masksToBounds = YES;
    self.bottomLabel.hidden = NO;
}

@end
