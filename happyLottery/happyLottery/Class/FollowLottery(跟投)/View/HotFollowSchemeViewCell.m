//
//  HotFollowSchemeViewCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "HotFollowSchemeViewCell.h"
@interface HotFollowSchemeViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonHonor;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonHonor1;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonHonor2;
@property (weak, nonatomic) IBOutlet UILabel *labPersonHis;
@property (weak, nonatomic) IBOutlet UILabel *labDeadTime;
@property (weak, nonatomic) IBOutlet UIButton *btnFollowScheme;
@property (weak, nonatomic) IBOutlet UILabel *labHuiBao;
@property (weak, nonatomic) IBOutlet UILabel *labFollowCount;

@property (weak, nonatomic) IBOutlet UILabel *labCostBySelf;
@property (weak, nonatomic) IBOutlet UIButton *labBetContent;
@property (weak, nonatomic) IBOutlet UILabel *labPersonName;

@end
@implementation HotFollowSchemeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}
- (IBAction)actionFollowScheme:(UIButton *)sender {
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
    
}

-(void)loadDataWithModel:(HotSchemeModel *)model{
    self.imgPersonHonor.hidden = YES;
    self.imgPersonHonor1.hidden = YES;
    self.imgPersonHonor2.hidden = YES;
    [self.imgPersonIcon sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    self.labPersonHis.text = model.recent_won;
    self.imgPersonIcon.layer.cornerRadius = self.imgPersonIcon.mj_h / 2;
    self.imgPersonIcon.layer.masksToBounds= YES;
    self.labPersonName.text = model.nickName== nil?model.cardCode:model.nickName;
    self.labDeadTime.text = model.deadLine;
    self.labHuiBao.text =[NSString stringWithFormat:@"%@倍",model.pledge];
    [self.labBetContent setTitle:[NSString stringWithFormat:@"%@  %@",model.leagueNames,[model.passTypes  stringByReplacingOccurrencesOfString:@"x" withString:@"串"]] forState:0];
    self.labFollowCount.text = [NSString stringWithFormat:@"跟单金额：%@元",model.totalFollowCost];
    self.labCostBySelf.text =[NSString stringWithFormat:@"自购金额：%@元",model.betCost];
    NSArray *laburls = [model.label_urls componentsSeparatedByString:@";"];
    for (int i = 0; i < laburls.count; i ++) {
        if (i == 0) {
            self.imgPersonHonor.hidden = NO;
    
            [self.imgPersonHonor sd_setImageWithURL:[NSURL URLWithString:laburls[i]]];
        }else if(i == 1){
            [self.imgPersonHonor1 sd_setImageWithURL:[NSURL URLWithString:laburls[i]]];
            self.imgPersonHonor1.hidden = NO;
            
        }else if (i == 2){
            [self.imgPersonHonor2 sd_setImageWithURL:[NSURL URLWithString:laburls[i]]];
            self.imgPersonHonor2.hidden = NO;
        }
    }
    
    
}

@end
