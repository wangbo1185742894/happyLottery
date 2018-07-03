//
//  SchemeDetailViewCell.m
//  happyLottery
//
//  Created by 王博 on 2018/1/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SchemeDetailViewCell.h"
#import "MGLabel.h"
#import "JCZQSchemeModel.h"

@interface SchemeDetailViewCell()
{
    __weak IBOutlet NSLayoutConstraint *disTopBetBouns;
    __weak IBOutlet NSLayoutConstraint *disTopBetBounsInfo;
    __weak IBOutlet UILabel *labSchemeState;
    __weak IBOutlet UILabel *labSchemeInfo;
    
    __weak IBOutlet UILabel *labBetBouns;
    __weak IBOutlet UILabel *labSchemeTime;
    __weak IBOutlet MGLabel *labTicketCount;
    __weak IBOutlet UILabel *labLottery;
    __weak IBOutlet UILabel *labSchemeNo;
    __weak IBOutlet UILabel *labBouns;
    __weak IBOutlet UILabel *labBetCost;
    __weak IBOutlet UILabel *labUnit;
    JCZQSchemeItem *scheme;
    __weak IBOutlet UILabel *touzhuzhushu;
    __weak IBOutlet UILabel *fanganhao;
    __weak IBOutlet UILabel *touzhujine;
    __weak IBOutlet NSLayoutConstraint *rightCons;
}
@end

@implementation SchemeDetailViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SchemeDetailViewCell" owner: nil options:nil] lastObject];
    }
    return self;
}

-(void)reloadDataModel:(JCZQSchemeItem*)model{
    labTicketCount.adjustsFontSizeToFitWidth = YES;
    scheme = model;
    labSchemeState.text = [model getSchemeState];
    
    
    if ([model.costType isEqualToString:@"CASH"]) {
        labSchemeInfo.text = @"方案状态";
        if ([model.ticketCount integerValue] == 0) {
             labTicketCount.text = @"";
        }else{
        labTicketCount.text = [NSString stringWithFormat:@"出票%@/%@单",model.printCount,model.ticketCount];
        }
        
    }else{
        labSchemeInfo.text = @"方案状态";
        labTicketCount.text = @"";
    }
    
    if ([model.schemeStatus isEqualToString:@"CANCEL"]||[model.schemeStatus isEqualToString:@"REPEAL"] ||[model.schemeStatus isEqualToString:@"INIT"] ) {
        labBetBouns.text = @"";
        labBetBouns.mj_h = 0;
        labBouns.text = @"";
        labBouns.hidden = YES;
        labBetBouns.hidden = YES;
        disTopBetBouns.constant = -17;
        disTopBetBounsInfo.constant = -17;
    }
    
    labSchemeTime.text = model.createTime;
    labLottery.text = [self getLotteryByCode:model.lottery];
    if ([Utility isIphone5s]) {
        labLottery.font = [UIFont systemFontOfSize:13.5];
        rightCons.constant = 0;
    }else {
        labLottery.font = [UIFont systemFontOfSize:14.0];
        rightCons.constant = 15;
    }
    labSchemeNo.text = model.schemeNO;
    if ([model.costType isEqualToString:@"CASH"]) {
        labBetCost.text = [NSString stringWithFormat:@"%@元",model.betCost];
    }else{
        labBetCost.text = [NSString stringWithFormat:@"%@积分",model.betCost];
    }
    
    if ([model.lottery isEqualToString:@"JCZQ"]||[model.lottery isEqualToString:@"JCGJ"]||[model.lottery isEqualToString:@"JCGYJ"] || [model.lottery isEqualToString:@"JCLQ"]) {
         labUnit.text = [NSString stringWithFormat:@"%@注",model.units];
    }else{
         labUnit.text = [NSString stringWithFormat:@"%@注%@倍",model.units,model.multiple];
    }
  
    labBouns.text = [self getWinningStatus:model];
    
//    labChuanFa.text = [self getChuanFa];
//    [self reloadGYJModel:model];
}

//冠亚军设置
//- (void)reloadGYJModel:(JCZQSchemeItem*)model{
//    if ([model.lottery isEqualToString:@"JCGYJ"]||[model.lottery isEqualToString:@"JCGJ"]) {
//        fanganhao.text = @"中奖金额";
//        labBetBouns.text = @"投注注数";
//        touzhuzhushu.text = @"投注倍数";
//        labSchemeNo.text = labBouns.text;
//        labBouns.text = labUnit.text;
//        labUnit.text = model.multiple;
//    }
//}

//    /**     * 等待开奖     */
//    WAIT_LOTTERY("等待开奖"),
//    /**     * 未中奖     */[10]    (null)    @"afterTaxBonus" : (no summary)
//    NOT_LOTTERY("未中奖"),
//    /**     * 中奖     */[8]    (null)    @"passType" : @"P2_1"
//    LOTTERY("中奖");[2]    (n
-(NSString *)getWinningStatus:( JCZQSchemeItem*)model{
    
    if ([model.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {
        return @"待开奖";
    }
    if ([model.winningStatus isEqualToString:@"NOT_LOTTERY"]) {
        
        return @"0.00元";
    }
    if ([model.bonus doubleValue] != 0) {
        labBouns.textColor = SystemRed;
        if ([model.costType isEqualToString:@"CASH"]) {
            return [NSString stringWithFormat:@"%.2f元",[model.bonus doubleValue]];
        }else{
            return [NSString stringWithFormat:@"%.2f积分",[model.bonus doubleValue]];
        }
    }
    return @"0.00元";
}



-(NSString *)getLotteryByCode:(NSString *)code{
    if ([code isEqualToString:@"JCZQ"]) {
        return @"竞彩足球";
    }else if([code isEqualToString:@"DLT"]){
        return [NSString stringWithFormat:@"超级大乐透(第%@期)",scheme.issueNumber];
    }else if([code isEqualToString:@"RJC"]){
        return [NSString stringWithFormat:@"任选9场(第%@期)",scheme.issueNumber];
    }else if([code isEqualToString:@"SFC"]){
        return [NSString stringWithFormat:@"胜负14场(第%@期)",scheme.issueNumber];
    }else if ([code isEqualToString:@"JCGYJ"]){
        return @"冠亚军游戏";
    }else if ([code isEqualToString:@"JCGJ"]){
        return @"冠军游戏";
    }else if ([code isEqualToString:@"SSQ"]){
        return [NSString stringWithFormat:@"双色球(第%@期)",scheme.issueNumber];
    }else if ([code isEqualToString:@"JCLQ"]){
        return @"竞彩篮球";
    }
    return @"彩票";
}

@end
