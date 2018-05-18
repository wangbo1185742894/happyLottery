//
//  HotFollowSchemeViewCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "HotFollowSchemeViewCell.h"
#import "MGLabel.h"
@interface HotFollowSchemeViewCell()
@property (weak, nonatomic) IBOutlet UIImageView *imgWinState;
@property (weak, nonatomic) IBOutlet MGLabel *labBouns;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonIcon;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonHonor;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonHonor1;
@property (weak, nonatomic) IBOutlet UIImageView *imgPersonHonor2;

@property (weak, nonatomic) IBOutlet UILabel *labDeadTime;
@property (weak, nonatomic) IBOutlet UIButton *btnFollowScheme;
@property (weak, nonatomic) IBOutlet UILabel *labHuiBao;
@property (weak, nonatomic) IBOutlet UILabel *labFollowCount;
@property (weak, nonatomic) IBOutlet UILabel *labPersonHis;
@property (weak, nonatomic) IBOutlet UILabel *labCostBySelf;
@property (weak, nonatomic) IBOutlet UIButton *labBetContent;
@property (weak, nonatomic) IBOutlet UILabel *labPersonName;

@end
@implementation HotFollowSchemeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labPersonHis.layer.cornerRadius = 3;
    // Initialization code
}
- (IBAction)actionFollowScheme:(UIButton *)sender {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}


-(void)setMatchData:(HotSchemeModel *)model{
    
    NSString *curDateM = [Utility timeStringFromFormat:@"MM" withDate:[NSDate date]];
    NSString *curDateD = [Utility timeStringFromFormat:@"dd" withDate:[NSDate date]];
    NSString *matchDateM =[[[model.deadLine componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"][1];
    NSString *matchDateD =[[[[model.deadLine componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] lastObject];
    if ([curDateM isEqualToString:matchDateM]) {
        NSInteger dayNum = [matchDateD integerValue] - [curDateD integerValue];
        if (dayNum == 0) {  // == 0 今天  ==1 明天   == 2  后天   == 3 大后天
            self.labDeadTime.text =[NSString stringWithFormat:@"今日%@",[model.deadLine substringWithRange:NSMakeRange(11, 5)]];
        }else if (dayNum == 1){
            self.labDeadTime.text =[NSString stringWithFormat:@"明日%@",[model.deadLine substringWithRange:NSMakeRange(11, 5)]];
        }else{
            self.labDeadTime.text =[NSString stringWithFormat:@"%@", [model.deadLine substringWithRange:NSMakeRange(5, 11)]];
        }
    }else{
        self.labDeadTime.text =[NSString stringWithFormat:@"%@", [model.deadLine substringWithRange:NSMakeRange(5, 11)]];
    }
}


//个人中心
-(void)loadDataWithModelInPC:(HotSchemeModel *)model {
    [self loadDataWithModel:model];
    self.labPersonHis.hidden = YES;
    if ([model.lottery isEqualToString:@"JCZQ"]) {
        self.labPersonName.text = @"竞彩足球";
        [self.imgPersonIcon setImage:[UIImage imageNamed:@"footerball.png"]];
    }else {
        self.labPersonName.text = @"竞彩篮球";
        [self.imgPersonIcon setImage:[UIImage imageNamed:@"basketball.png"]];
    }
    self.imgPersonHonor.hidden = YES;
    self.imgPersonHonor1.hidden = YES;
    self.imgPersonHonor2.hidden = YES;
}


- (void)loadDataWithModelInDaT:(HotSchemeModel *)model{
    [self loadDataWithModel:model];
}

//我的关注
-(void)loadDataWithModelInNotice:(HotSchemeModel *)model {
    [self loadDataWithModel:model];
}

-(void)loadDataWithModel:(HotSchemeModel *)model{

    NSDate * dateServer = [Utility dateFromDateStr:model.serverTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateCur = [Utility dateFromDateStr:model.deadLine withFormat:@"yyyy-MM-dd HH:mm:ss"];

    if ([dateServer compare:dateCur] ==kCFCompareLessThan ||model.serverTime==nil) { //没过期 可以买
        self.btnFollowScheme.hidden = NO;
        self.labBouns.hidden = YES;
        self.imgWinState.hidden = YES;
    }else{
        self.btnFollowScheme.hidden = YES;
        self.labBouns.hidden = YES;
        if (model.won == nil) {
            self.imgWinState.hidden = YES;
        }else if ([model.won boolValue]){
            self.imgWinState.hidden = NO;
            self.imgWinState.image = [UIImage imageNamed:@"win"];
            self.labBouns.hidden = NO;
            self.labBouns.text = [NSString stringWithFormat:@"中奖%.2f元",[model.bonus doubleValue]];
        }else{
            self.imgWinState.hidden = NO;
            self.imgWinState.image = [UIImage imageNamed:@"losing"];
        }
        
    }
    
    self.btnFollowScheme.layer.cornerRadius = 5;
    self.btnFollowScheme.layer.masksToBounds = YES;
    self.btnFollowScheme.layer.borderWidth = 1;
    self.btnFollowScheme.layer.borderColor = SystemGreen.CGColor;
    [self setMatchData:model];
    self.imgPersonHonor.hidden = YES;
    self.imgPersonHonor1.hidden = YES;
    self.imgPersonHonor2.hidden = YES;
    if (model.headUrl.length == 0) {
        [self.imgPersonIcon setImage: [UIImage imageNamed:@"usermine"]];
    }else{
        
        [self.imgPersonIcon sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    }
   

    self.imgPersonIcon.layer.cornerRadius = self.imgPersonIcon.mj_h / 2;
    self.imgPersonIcon.layer.masksToBounds= YES;
    self.labPersonName.text = model.nickName;
   
    self.labHuiBao.text =[NSString stringWithFormat:@"%@倍",model.pledge];
    [self.labBetContent setTitle:[model getContent] forState:0];
    self.labFollowCount.text = [NSString stringWithFormat:@"跟单人次：%@人",model.totalFollowCount];
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
    if (model.recent_won .length == 0) {
        self.labPersonHis.text  = @"近0中0";
    }else{
        NSArray *wonState = [model.recent_won componentsSeparatedByString:@","];
        NSInteger totalWon = 0;
        for (NSString *state in wonState) {
            totalWon += [state integerValue];
            
        }
        self.labPersonHis.text = [NSString stringWithFormat:@"近%ld中%ld",wonState.count,totalWon];
        if (wonState.count/totalWon<2 &&totalWon!= 0 ) {
            self.labPersonHis.hidden = NO;
        } else {
            self.labPersonHis.hidden = YES;
        }
    }
}

@end
