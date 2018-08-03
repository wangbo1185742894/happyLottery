//
//  SearchViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/8/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SearchViewCell.h"

@implementation SearchViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.userImage.layer.cornerRadius = self.userImage.mj_h / 2;
    self.userImage.layer.masksToBounds= YES;
    self.recentWin.layer.cornerRadius = 4;
    self.recentWin.layer.masksToBounds = YES;
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadDataWithModel:(SearchPerModel *)model{
    if (model.headUrl.length == 0) {
        [self.userImage setImage: [UIImage imageNamed:@"usermine"]];
    }else{
        [self.userImage sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    }
    self.userName.text = model.nickname;
    self.tagOne.hidden = YES;
    self.tagTwo.hidden = YES;
    self.tagThree.hidden = YES;
    NSArray *laburls = [model.labels componentsSeparatedByString:@";"];
    for (int i = 0; i < laburls.count; i ++) {
        if (i == 0) {
            self.tagOne.hidden = NO;
            
            [self.tagOne sd_setImageWithURL:[NSURL URLWithString:laburls[i]]];
        }else if(i == 1){
            [self.tagTwo sd_setImageWithURL:[NSURL URLWithString:laburls[i]]];
            self.tagTwo.hidden = NO;
            
        }else if (i == 2){
            [self.tagThree sd_setImageWithURL:[NSURL URLWithString:laburls[i]]];
            self.tagThree.hidden = NO;
        }
    }
    self.recentWin.adjustsFontSizeToFitWidth = YES;
    if (model.recentWon.length == 0) {
        self.recentWin.hidden = YES;  //近几中几标签大于50%才显示;
    }else{
        NSArray *wonState = [model.recentWon componentsSeparatedByString:@","];
        NSInteger totalWon = 0;
        for (NSString *state in wonState) {
            totalWon += [state integerValue];
        }
        self.recentWin.text = [NSString stringWithFormat:@"近%ld中%ld",wonState.count,totalWon];
        if (totalWon!= 0 && wonState.count/totalWon<2) {
            self.recentWin.hidden = NO;
        } else {
            self.recentWin.hidden = YES;
        }
    }
    self.totalBonus.text = model.totalBonus;
}

@end
