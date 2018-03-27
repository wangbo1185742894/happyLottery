//
//  OrderTableViewCell.m
//  Lottery
//
//  Created by Yang on 15/6/22.
//  Copyright (c) 2015年 AMP. All rights reserved.
//
#define TOPSHORT 8
#define TOPLONG 20

#import "OrderTableViewCell.h"
#import "CTZQOrderProfile.h"

@interface OrderTableViewCell()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topConstant;

@end



@implementation OrderTableViewCell

- (void)awakeFromNib {

}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)orderInforZhuihao:(OrderProfile *)order{
    prizeMoney.hidden = YES;
    [prizeMoney setFont:[UIFont systemFontOfSize:13]];
    [timeLb setFont:[UIFont systemFontOfSize:13]];
    //11.06
    prizeMoney.adjustsFontSizeToFitWidth = YES;
    winningStateLb.adjustsFontSizeToFitWidth = YES;
    //追号
    if (![order.catchSchemeId isEqualToString:@""]&&![order.catchSchemeId isEqualToString:@"(null)"])
    {
        //11.06
        if ([order.lottery isEqualToString:@"X115"]) {
            lotteryTypeLb.text = @"陕11选5";
        }else{
            lotteryTypeLb.text = order.name;
        }
        lotteryIconImgV.image = [UIImage imageNamed:order.iconName];
        
        //1111
        timeLb.text = [NSString stringWithFormat:@"%@/%@%@",order.catchIndex,order.totalCatch,order.chaseStatus];
        _topConstant.constant = TOPLONG;
        if ([order.WINST isEqualToString:@"追号中"] && [order.bonus doubleValue] > 0) {
            prizeMoney.hidden = NO;
            _topConstant.constant = TOPSHORT;
            prizeMoney.text = [NSString stringWithFormat:@"奖金:%.2f元",[order.bonus doubleValue]];
        }
        if ([order.WINST isEqualToString:@"已中奖"]) {
            timeLb.textColor = TEXTGRAYCOLOR;
            //11.23
            prizeMoney.hidden = NO;
            _topConstant.constant = TOPSHORT;
            prizeMoney.text = [NSString stringWithFormat:@"奖金:%.2f元",[order.bonus doubleValue]];
        }else
        {
            timeLb.textColor = TEXTGRAYCOLOR;
            
        }
        
        issueNumLb.textColor = TEXTGRAYCOLOR;
        issueNumLb.text = [NSString stringWithFormat:@"%@",order.catchplaytype];
        [issueNumLb setFont:[UIFont systemFontOfSize:13]];
        [priceLb setFont:[UIFont systemFontOfSize:13]];
        priceLb.text = [NSString stringWithFormat:@"开始期号%@",order.beginIssue ];
        [winningStateLb setFont:[UIFont systemFontOfSize:13]];
        if ([order.orderBonus isEqualToString:@"<null>"]) {
            winningStateLb.text = [NSString stringWithFormat:@"投注%@元",@"0"];
        }else
        {
            winningStateLb.text = [NSString stringWithFormat:@"投注%@元",order.orderBonus];
        }
        if ([order.lotteryType isEqualToString:@"DLT"]||[order.lotteryType isEqualToString:@"dlt"]||[order.name isEqualToString:@"大乐透"]){
            issueNumLb.hidden = YES;
            
        }else{
            issueNumLb.hidden = NO;
        }
        
    }
    else//11.06  投注
    {
        NSString *str = [NSString stringWithFormat:@"%@",order.orderTime];
        [timeLb setFont:[UIFont systemFontOfSize:13]];
        if (str.length >= 10) {
            timeLb.text = [str substringToIndex:10];
        }
        
        if([order.lotteryType isEqualToString:@"JCZQ"]||[order.lotteryType isEqualToString:@"JCLQ"]){
            ;
        }else{
            issueNumLb.text = [NSString stringWithFormat:@"第%@期",order.issueNumber];
            
        }
        priceLb.text = [NSString stringWithFormat:@"%.1f元",[order.orderbonus doubleValue]];
        if ([order.name isEqualToString:@"陕西11选5"]) {
            lotteryTypeLb.text = @"陕11选5";
        }else{
            lotteryTypeLb.text = order.name;
        }
        [lotteryTypeLb setFont:[UIFont boldSystemFontOfSize:13]];
        lotteryIconImgV.image = [UIImage imageNamed:order.iconName];
        //结果(11.23 加足球)
        NSString * result = order.descToAppear;
        if ([order.lotteryType isEqualToString:@"RJC"]||[order.lotteryType isEqualToString:@"SFC"]||[order.lotteryType isEqualToString:@"JCLQ"]) {
            CTZQOrderProfile *ctzqOrder = (CTZQOrderProfile*)order;
            result = ctzqOrder.descFangAnToAppear;
        }
        //        winningStateLb.text = order.descToAppear;
        if ([result isEqualToString:@"已中奖"]) {
            winningStateLb.textColor = TextCharColor;
            
            //11.20
            winningStateLb.adjustsFontSizeToFitWidth = YES;
            winningStateLb.numberOfLines = 0;
            //            winningStateLb.backgroundColor = [UIColor redColor];
            if ([order.bonus doubleValue] == 0) {
                winningStateLb.text = @"赠票";
            }else{
                winningStateLb.text = [NSString stringWithFormat:@"奖金:%.2f元",[order.bonus doubleValue]];
            }
        }
        else{
            winningStateLb.textColor = TEXTGRAYCOLOR;
            winningStateLb.text = result;
            if ([result isEqualToString:@"未中奖"]){
                winningStateLb.text = @"祝您下次好运";
            }
        }
        if([result isEqualToString:@"出票失败"])
        {
            hintTitle.text = @"当前投注过多,建议提前下单";
            [hintTitle setFont:[UIFont systemFontOfSize:13]];
            hintTitle.textColor = TextCharColor;
            _topConstant.constant = TOPSHORT;
        }
        else
        {
            hintTitle.text = @"";
            _topConstant.constant = TOPLONG;
        }
        
    }
    if ([order.lotteryType isEqualToString:@"JCZQ"]) {
        lotteryIconImgV.image = [UIImage imageNamed:@"jczq.png"];
        lotteryTypeLb.text = @"竞彩足球";
    }
    if ([order.lotteryType isEqualToString:@"JCLQ"]) {
        lotteryIconImgV.image = [UIImage imageNamed:@"jclq_icon.png"];
        lotteryTypeLb.text = @"竞彩篮球";
    }
    if ([order.lotteryType isEqualToString:@"JCZQ"]) {
        lotteryIconImgV.image = [UIImage imageNamed:@"jczq.png"];
        lotteryTypeLb.text = @"竞彩足球";
    }
    if ([order.lotteryType isEqualToString:@"JCZQ"]) {
        lotteryIconImgV.image = [UIImage imageNamed:@"jczq.png"];
        lotteryTypeLb.text = @"竞彩足球";
    }
    if ([order.lotteryType isEqualToString:@"JCGJ"]){
         lotteryTypeLb.text = @"冠军";
         lotteryIconImgV.image = [UIImage imageNamed:@"first.png"];
    }
    if ([order.lotteryType isEqualToString:@"JCGYJ"]){
         lotteryTypeLb.text = @"冠亚军";
         lotteryIconImgV.image = [UIImage imageNamed:@"Championship.png"];
    }
    //    if([order.winningStatus intValue] > 2){
    //        winningStateLb.textColor = [UIColor redColor];
    //    }else{
    //        winningStateLb.textColor = [UIColor blackColor];
    //    }
}


-(void)orderInfoShow:( LotteryScheme*)order{
    prizeMoney.hidden = YES;
    [prizeMoney setFont:[UIFont systemFontOfSize:13]];
    [timeLb setFont:[UIFont systemFontOfSize:13]];
    //11.06
    prizeMoney.adjustsFontSizeToFitWidth = YES;
    winningStateLb.adjustsFontSizeToFitWidth = YES;
    if ([order.schemeStatus isEqualToString:@"INIT"]) {
        winningStateLb.text = @"待支付";
    }else if([order .schemeStatus isEqualToString:@"CANCEL"]){
        if ([order.ticketStatus isEqualToString:@"TICKET_FAILED"]) {
            
            winningStateLb.text = @"方案失败";
//            hintTitle.text = @"当前投注过多,建议提前下单";
//            [hintTitle setFont:[UIFont systemFontOfSize:13]];
//            hintTitle.textColor = TextCharColor;
//            _topConstant.constant = TOPSHORT;
        }else{
            
            winningStateLb.text = @"方案失败";
        }
    }else if([order.schemeStatus isEqualToString:@"REPEAL"]){
         winningStateLb.text = @"方案撤销";
    }else{
        if ([order.schemeType isEqualToString:@"BUY_TOGETHER"]) {
            if ([order.schemeStatus isEqualToString:@"UN_FULL"]) {
                winningStateLb.text = order.trSchemeStatus;
            }else{
                if (![order.trTicketStatus isEqualToString:@"出票成功"]) {
                    
                    if ([order.trTicketStatus isEqualToString:@"出票失败"]) {
                        hintTitle.text = @"当前投注过多,建议提前下单";
                        [hintTitle setFont:[UIFont systemFontOfSize:13]];
                        hintTitle.textColor = TextCharColor;
                        _topConstant.constant = TOPSHORT;
                    }else{
                        if ([order.trTicketStatus isEqualToString:@"委托中"]||[order.trTicketStatus isEqualToString:@"委托成功"]) {
                            
                            winningStateLb.text = [NSString stringWithFormat:@"出票中"];
                        }else{
                            
                            winningStateLb.text = order.trTicketStatus;
                        }
                    }
                    
                    
                    
                }else{
                    
                    if ([order.trWinningStatus isEqualToString:@"已派奖"] || [order.trWinningStatus isEqualToString:@"已开奖"]) {
                        if ([order.won boolValue] == YES) {
                            winningStateLb.text = @"已中奖";
                            prizeMoney.hidden = NO;
                            _topConstant.constant = TOPSHORT;
                            prizeMoney.text =[NSString stringWithFormat:@"奖金:%.2f",[order.bonus doubleValue]];
                        }else{
                        
                            winningStateLb.text = @"祝您下次好运";
                        }
                    }else{
                       winningStateLb.text = @"待开奖";
                    }
                   
                }
            }
        }else{
            if (![order.trTicketStatus isEqualToString:@"出票成功"]) {
                if ([order.trTicketStatus isEqualToString:@"出票失败"]) {
                    winningStateLb.text = order.trTicketStatus;
                    hintTitle.text = @"当前投注过多,建议提前下单";
                    [hintTitle setFont:[UIFont systemFontOfSize:13]];
                    hintTitle.textColor = TextCharColor;
                    _topConstant.constant = TOPSHORT;
                }else{
                    if ([order.trTicketStatus isEqualToString:@"委托中"]||[order.trTicketStatus isEqualToString:@"委托成功"]) {
                        
                        winningStateLb.text = [NSString stringWithFormat:@"出票中"];
                    }else{
                        
                        winningStateLb.text = order.trTicketStatus;
                    }
                }
            }else{
                
                
                if ([order.trWinningStatus isEqualToString:@"已派奖"] || [order.trWinningStatus isEqualToString:@"已开奖"]) {
                    if ([order.won boolValue] == YES) {
                        winningStateLb.text = @"已中奖";
                        prizeMoney.hidden = NO;
                        _topConstant.constant = TOPSHORT;
                        prizeMoney.text =[NSString stringWithFormat:@"奖金:%.2f",[order.bonus doubleValue]];
                    }else{
                        
                        winningStateLb.text = @"祝您下次好运";
                    }
                }else{
                    winningStateLb.text = @"待开奖";
                }
                
            }
        }
       
    }
    
        NSString *str = [NSString stringWithFormat:@"%@",order.createTime];
        [timeLb setFont:[UIFont systemFontOfSize:13]];
        if (str.length >= 10) {
            timeLb.text = [str substringToIndex:10];
        }

        if([order.lottery isEqualToString:@"JCZQ"]||[order.lottery isEqualToString:@"JCLQ"]){
            ;
        }else{
            issueNumLb.text = [NSString stringWithFormat:@"第%@期",order.issueNumber];
        }
        priceLb.text = [NSString stringWithFormat:@"%.1f元",[order.betCost doubleValue]];
        if ([order.trLotteryName isEqualToString:@"陕西11选5"]) {
             lotteryTypeLb.text = @"陕11选5";
        }else{
            lotteryTypeLb.text = order.trLotteryName;
        }
        [lotteryTypeLb setFont:[UIFont boldSystemFontOfSize:13]];
        lotteryIconImgV.image = [UIImage imageNamed:order.iconName];
}

@end
