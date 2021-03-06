//
//  HotFollowSchemeViewCell.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "HotFollowSchemeViewCell.h"
#import "MGLabel.h"

#define ImageNameNo   @"redNew_disable.png"
#define ImageNameYes  @"redNew_close.png"

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
@property (weak, nonatomic) IBOutlet MGLabel *labFollowCount;
@property (weak, nonatomic) IBOutlet UILabel *labPersonHis;
@property (weak, nonatomic) IBOutlet UILabel *labCostBySelf;
@property (weak, nonatomic) IBOutlet UIButton *labBetContent;
@property (weak, nonatomic) IBOutlet UILabel *labPersonName;
@property (weak, nonatomic) IBOutlet UIView *topPersonView;
@property (weak, nonatomic) IBOutlet UIImageView *alreadyFollow;
@property (weak, nonatomic) IBOutlet UIImageView *redPackImg;

@property (nonatomic,copy) NSString *carcode;
@end
@implementation HotFollowSchemeViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.labPersonHis.layer.cornerRadius = 4;
    self.labPersonHis.layer.masksToBounds = YES;
    self.labBouns.keyWordFont = [UIFont fontWithName:@"Helvetica-Condensed-Black-Se" size:16];
   
    UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickImage)];
    [self.topPersonView addGestureRecognizer:tapGesture];
    self.topPersonView.userInteractionEnabled = YES;
    // Initialization code
}

- (void)clickImage {
    [self.delegate itemClickToPerson:self.carcode];
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


- (void)getTimesFromHours:(HotSchemeModel *)model {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSString *deadlines = [NSString stringWithFormat:@"%@ 23:59:59",[[model.deadLine componentsSeparatedByString:@" "] firstObject]];
    NSDate *oldDate = [dateFormatter dateFromString:deadlines];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    // 比较时间
    NSDateComponents *components = [calendar components:NSCalendarUnitDay fromDate:[NSDate date] toDate:oldDate options:0];
    if (components.day == 0) {
        //今日与昨日再加判断    24小时内 components.day == 0  对比日期是否相当
        NSString *curDateD = [Utility timeStringFromFormat:@"dd" withDate:[NSDate date]];
        NSString *matchDateD =[[[[model.deadLine componentsSeparatedByString:@" "] firstObject] componentsSeparatedByString:@"-"] lastObject];
        NSInteger dayNum = [matchDateD integerValue] - [curDateD integerValue];
        if (dayNum == 0) {
            self.labDeadTime.text =[NSString stringWithFormat:@"今日%@",[model.deadLine substringWithRange:NSMakeRange(11, 5)]];
        } else {
            self.labDeadTime.text =[NSString stringWithFormat:@"%@", [model.deadLine substringWithRange:NSMakeRange(5, 11)]];
        }
    } else if (components.day == 1){
        self.labDeadTime.text =[NSString stringWithFormat:@"明日%@",[model.deadLine substringWithRange:NSMakeRange(11, 5)]];
    } else {
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
    if (model.won == nil) {
         [self.labBetContent setImage:[UIImage imageNamed:@"icon_suozi.png"] forState:UIControlStateNormal];
    } else {
         [self.labBetContent setImage:[UIImage imageNamed:@"kaisuo.png"] forState:UIControlStateNormal];
    }
    if ([model.won boolValue]){
        self.imgWinState.image = [UIImage imageNamed:@"winPerson.png"];
    } else {
        self.imgWinState.image = [UIImage imageNamed:@"losePerson.png"];
    }
}


- (void)loadDataWithModelInDaT:(HotSchemeModel *)model{
    [self loadDataWithModel:model];
    self.imgPersonIcon.layer.cornerRadius = self.imgPersonIcon.mj_h / 2;
    self.imgPersonIcon.layer.masksToBounds= YES;
    
}

//我的关注
-(void)loadDataWithModelInNotice:(HotSchemeModel *)model {
    [self loadDataWithModel:model];
    self.imgPersonIcon.layer.cornerRadius = self.imgPersonIcon.mj_h / 2;
    self.imgPersonIcon.layer.masksToBounds= YES;
}

-(void)loadDataWithModel:(HotSchemeModel *)model{
    self.carcode = model.cardCode;
    NSDate * dateServer = [Utility dateFromDateStr:model.serverTime withFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate * dateCur = [Utility dateFromDateStr:model.deadLine withFormat:@"yyyy-MM-dd HH:mm:ss"];
    self.labPersonHis.adjustsFontSizeToFitWidth = YES;
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
            self.labBouns.keyWord = [NSString stringWithFormat:@"%.2f",[model.bonus doubleValue]];
            self.labBouns.keyWordColor = RGBCOLOR(254, 58, 81);
            
        }else{
            self.imgWinState.hidden = NO;
            self.imgWinState.image = [UIImage imageNamed:@"losing"];
        }
        
    }
    
    self.btnFollowScheme.layer.cornerRadius = 5;
    self.btnFollowScheme.layer.masksToBounds = YES;
    self.btnFollowScheme.layer.borderWidth = 1;
    self.btnFollowScheme.layer.borderColor = SystemGreen.CGColor;
    [self getTimesFromHours:model];
    self.imgPersonHonor.hidden = YES;
    self.imgPersonHonor1.hidden = YES;
    self.imgPersonHonor2.hidden = YES;
    if (model.headUrl.length == 0) {
        [self.imgPersonIcon setImage: [UIImage imageNamed:@"usermine"]];
    }else{
        
        [self.imgPersonIcon sd_setImageWithURL:[NSURL URLWithString:model.headUrl]];
    }
   
   
    self.labPersonName.text = model.nickName;
    
    self.labHuiBao.text =[NSString stringWithFormat:@"%.2f倍",[model.pledge doubleValue]];
    NSString *str = [NSString stringWithFormat:@"  %@",[model getContent]];
    [self.labBetContent setTitle:str forState:0];
    //虚拟固定卡号跟单人次（10000370-10000380）  末尾数+20+真实人次
    NSString *carcode = [model.cardCode substringWithRange:NSMakeRange(0, 7)];
    if ([carcode isEqualToString:@"1000037"]||[model.cardCode isEqualToString:@"10000380"]) {
        self.labFollowCount.text = [NSString stringWithFormat:@"跟单人次：%d人",[[model.cardCode substringFromIndex:model.cardCode.length-1]intValue]+20+[model.totalFollowCount intValue]];
        self.labFollowCount.keyWord = [NSString stringWithFormat:@"%d",[[model.cardCode substringFromIndex:model.cardCode.length-1]intValue]+20+[model.totalFollowCount intValue]];
    } else{
        self.labFollowCount.text = [NSString stringWithFormat:@"跟单人次：%@人",model.totalFollowCount];
        self.labFollowCount.keyWord = model.totalFollowCount;
    }
    self.labFollowCount.keyWordColor = RGBCOLOR(254, 58, 81);
    self.labCostBySelf.text =[NSString stringWithFormat:@"  自购金额：%@元",model.betCost];
    self.labCostBySelf.textColor = RGBCOLOR(25, 26, 26);
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
//        self.labPersonHis.text  = @"近0中0"
        self.labPersonHis.hidden = YES;  //近几中几标签大于50%才显示;
    }else{
        NSArray *wonState = [model.recent_won componentsSeparatedByString:@","];
        NSInteger totalWon = 0;
        for (NSString *state in wonState) {
            totalWon += [state integerValue];
            
        }
        self.labPersonHis.text = [NSString stringWithFormat:@"近%ld中%ld",wonState.count,totalWon];
        if (totalWon!= 0 && wonState.count/totalWon<2) {
            self.labPersonHis.hidden = NO;
        } else {
            self.labPersonHis.hidden = YES;
        }
    }
    self.alreadyFollow.hidden = ![model.alreadyFollow boolValue];
    //发单有红包
    if ([model.hasRedPacket boolValue]) {
        self.redPackImg.hidden = NO;
        //红包领光了||用户已经领取红包  灰色
        if ([model.gainRedPacket boolValue]||_btnFollowScheme.hidden||![model.completeStatus isEqualToString:@"RUNNING"]) {
            [self.redPackImg setImage:[UIImage imageNamed:ImageNameNo]];
        } else {  //红色
            [self.redPackImg setImage:[UIImage imageNamed:ImageNameYes]];
        }
    } else {
        self.redPackImg.hidden = YES;
    }
}

@end
