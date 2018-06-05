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
    self.lmgIcon.layer.cornerRadius = self.lmgIcon.mj_h/ 2;
    self.lmgIcon.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}


-(void)loadDataLottery:(NSDictionary  *)itemDic andRate:(NSString *)rate{
    self.labName.text = itemDic[@"lotteryName"];
    self.labTime.text = [NSString stringWithFormat:@"%.2f%%",[rate doubleValue] * 100];
    self.labTime.font = [UIFont systemFontOfSize:15];
    self.labTime.textColor = [UIColor redColor];
    [self.lmgIcon setImage:[UIImage imageNamed:itemDic[@"lotteryImageName"]]];
}

-(void)loadData:(AgentMemberModel *)model{
    
    self.labTime.text = [model.createTime substringFromIndex:10];
    if (model.headUrl == nil) {
        self.lmgIcon.image = [UIImage imageNamed:@"usermine"];
    }else{
        [self.lmgIcon sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    }
    
    if (model.nickname == nil) {
        self.labName.text = [model.cardCode stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    }else{
        self.labName.text = model.nickname;
    }
    
}

@end
