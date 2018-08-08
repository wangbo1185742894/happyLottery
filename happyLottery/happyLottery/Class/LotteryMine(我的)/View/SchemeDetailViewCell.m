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
    __weak IBOutlet UILabel *labLotteryDes;
    __weak IBOutlet UILabel *labSchemeNo;
    __weak IBOutlet UILabel *labBouns;
    __weak IBOutlet UILabel *labBetCost;
    __weak IBOutlet UILabel *labUnit;
    JCZQSchemeItem *scheme;
    __weak IBOutlet UILabel *touzhuzhushu;
    __weak IBOutlet UILabel *fanganhao;
    __weak IBOutlet UILabel *touzhujine;
    __weak IBOutlet NSLayoutConstraint *rightCons;
    __weak IBOutlet UILabel *labLottery;
    __weak IBOutlet UIImageView *youHuaTag;
    __weak IBOutlet UIButton *actionShuoming;
    __weak IBOutlet UILabel *kaijiangOrders;
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
    kaijiangOrders.adjustsFontSizeToFitWidth = YES;
    scheme = model;
    labSchemeState.text = [model getSchemeState];
    
    
    if ([model.costType isEqualToString:@"CASH"]) {
        labSchemeInfo.text = @"方案状态";
        if ([model.ticketCount integerValue] == 0) {
             labTicketCount.text = @"";
             kaijiangOrders.text = @"";
        }else{

            if ([model.ticketFailRef doubleValue] > 0 && [model.printCount doubleValue]>0) {
                 labTicketCount.text = [NSString stringWithFormat:@"出票%@/%@单(未出票订单已退款)",model.printCount,model.ticketCount];
                labTicketCount.keyWord = @"(未出票订单已退款)";
                labTicketCount.keyWordColor = SystemRed;
            }else{
                 labTicketCount.text = [NSString stringWithFormat:@"出票%@/%@单",model.printCount,model.ticketCount];
            }
            kaijiangOrders.text = [NSString stringWithFormat:@" 当前开奖订单%@/%@单",model.drawCount,model.ticketCount];
           
        }
        
    }else{
        labSchemeInfo.text = @"方案状态";
        labTicketCount.text = @"";
        kaijiangOrders.text = @"";
    }
    if ([model.lottery isEqualToString:@"JCZQ"] || [model.lottery isEqualToString:@"JCLQ"]) {
        actionShuoming.hidden = NO;
        kaijiangOrders.hidden = NO;
    }else {
        actionShuoming.hidden = YES;
        kaijiangOrders.hidden = YES;
    }
    if ([model.winningStatus isEqualToString:@"WAIT_LOTTERY"]) {
        kaijiangOrders.hidden = YES;
        actionShuoming.hidden = YES;
    }
    if ([model.schemeStatus isEqualToString:@"CANCEL"]||[model.schemeStatus isEqualToString:@"REPEAL"] || [model.schemeStatus isEqualToString:@"INIT"] ) {
        labBetBouns.text = @"";
        labBetBouns.mj_h = 0;
        labBouns.text = @"";
        kaijiangOrders.text = @"";
        labBouns.hidden = YES;
        labBetBouns.hidden = YES;
        disTopBetBouns.constant = -17;
        disTopBetBounsInfo.constant = -17;
        actionShuoming.hidden = YES;
    }
    
    labSchemeTime.text = model.createTime;
    
    NSMutableParagraphStyle * paragraphStyle1 = [[NSMutableParagraphStyle alloc]init];
    [paragraphStyle1 setLineSpacing:5];
    NSAttributedString *att = [[NSAttributedString alloc]initWithString:[self getLotteryByCodeDesc:model.lottery] attributes:@{NSParagraphStyleAttributeName:paragraphStyle1}];
    labLotteryDes.attributedText = att;
    labLottery.attributedText = [[NSAttributedString alloc]initWithString:[self getLotteryByCode:model.lottery] attributes:@{NSParagraphStyleAttributeName:paragraphStyle1}];
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
    if ([model.lottery isEqualToString:@"JCZQ"] && [model.schemeSource isEqualToString:@"BONUS_OPTIMIZE"]) {
        youHuaTag.hidden = NO;
    } else {
        youHuaTag.hidden = YES;
    }
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

-(NSString *)getLotteryByCodeDesc:(NSString *)code{
   if ([code isEqualToString:@"SX115"] || [code isEqualToString:@"SD115"] || [code isEqualToString:@"SSQ"] || [code isEqualToString:@"SFC"] || [code isEqualToString:@"RJC"] || [code isEqualToString:@"DLT"]){
        return @"彩种\n期号";
   }else{
       return @"彩种";
   }
    
}

-(NSString *)getLotteryByCode:(NSString *)code{
    if ([code isEqualToString:@"JCZQ"]) {
        return @"竞彩足球";
    }else if([code isEqualToString:@"DLT"]){
        return [NSString stringWithFormat:@"超级大乐透\n第%@期",scheme.issueNumber];
    }else if([code isEqualToString:@"RJC"]){
        return [NSString stringWithFormat:@"任选9场\n第%@期",scheme.issueNumber];
    }else if([code isEqualToString:@"SFC"]){
        return [NSString stringWithFormat:@"胜负14场\n第%@期",scheme.issueNumber];
    }else if ([code isEqualToString:@"JCGYJ"]){
        return @"冠亚军游戏";
    }else if ([code isEqualToString:@"JCGJ"]){
        return @"冠军游戏";
    }else if ([code isEqualToString:@"SSQ"]){
        return [NSString stringWithFormat:@"双色球\n第%@期",scheme.issueNumber];
    }else if ([code isEqualToString:@"JCLQ"]){
        return @"竞彩篮球";
    }else if ([code isEqualToString:@"SD115"]){
        return [NSString stringWithFormat:@"山东11选5\n第%@期",scheme.issueNumber];
        
    }else if ([code isEqualToString:@"SX115"]){
        return [NSString stringWithFormat:@"陕西11选5\n第%@期",scheme.issueNumber];
    }
    return @"彩票";
}

- (IBAction)actionToInfor:(id)sender {
    [self.delegate showAlert];
}
@end
