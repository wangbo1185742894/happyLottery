//
//  ZHTableViewCell.m
//  Lottery
//
//  Created by 关阿龙 on 15/10/16.
//  Copyright © 2015年 AMP. All rights reserved.
//

#import "ZHTableViewCell.h"

@implementation ZHTableViewCell

- (void)awakeFromNib {
    // Initialization code
    
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)whenwin
{
    tupian.image = [UIImage imageNamed:@"whenwin.png"];
    qihao.textColor = TextCharColor;
    dangqi.textColor = TextCharColor;
    leiji.textColor = TextCharColor;
    zhongjiang.textColor = TextCharColor;
    
    zhongjiang.adjustsFontSizeToFitWidth = YES;
    kaijianghaoma.textColor = TextCharColor;
    jieguo.textColor = TextCharColor;
    
}


-(void)orderInfoShow1:(OrderProfile *)order index:(NSString *)index leiji:(NSString *)touru{
    
    //序号
    xuhao.text = [NSString stringWithFormat:@"%@",order.catchIndex];
    xuhao.textColor = TEXTGRAYCOLOR;
    //期号
    qihao.textColor = TEXTGRAYCOLOR;

    qihao.text = [NSString stringWithFormat:@"%@期",order.issueNumber];
    
    //当期投入
    NSString *stry = [NSString stringWithFormat:@"%@",order.subscription];
    if ([order.payStatus isEqualToString:@"NotPaid"] || [order.payStatus isEqualToString:@"FailedToPay"]) {
        dangqi.text = @"0元";
    }else{
        dangqi.text = [NSString stringWithFormat:@"%@元",stry ];
    }
    
    //累计投入
    leiji.adjustsFontSizeToFitWidth = YES;
    leiji.text = [NSString stringWithFormat:@"%@元",touru];
    
    //中奖奖金
    NSString * balance = [NSString stringWithFormat:@"%.2f",[order.trBonus doubleValue]];
    NSString * str2 = balance;
    //    NSString * str2 = [NSString stringWithFormat:@"%@",order.bonus];
    if ([str2 isEqualToString:@"(null)"] || [str2 isEqualToString:@"0.00"]) {
        zhongjiang.text = @"0.0元";
        tupian.hidden = YES;
        
    }else{
        zhongjiang.text = [NSString stringWithFormat:@"%@元",str2];
        kaijianghaoma.textColor = SystemRed;
        tupian.hidden = NO;
    }
    
 
    
    jieguo.adjustsFontSizeToFitWidth = YES;
//    jieguo.textColor = [UIColor orangeColor];
    
//    WAITDO("待追号 "),
//    /**已追号*/
//    CATCHED("已追号"),
//    /**已取消*/
//    CANCLE("已取消")
    if ([order.trOrderStatus isEqualToString:@"出票中"]) {
        jieguo.text = @"出票中";
    }else if ([order.trOrderStatus isEqualToString:@"出票成功"]) {
        NSString * lottnum = [NSString stringWithFormat:@"%@",order.trOpenResult];
        if ([lottnum isEqualToString:@"(null)"] ||[lottnum isEqualToString:@"null"] ) {
            if ([order.remark isEqualToString:@"(null)"] ||[order.remark isEqualToString:@"null"]) {
                kaijianghaoma.text = @"";
            }else{
                kaijianghaoma.text = order.remark;
            }
            jieguo.text = @"待开奖";
        }
        else
        {
            lottnum = [lottnum stringByReplacingOccurrencesOfString:@"#" withString:@"+"];
            kaijianghaoma.text = [NSString stringWithFormat:@"开奖号码:%@",lottnum];
            if ([str2 isEqualToString:@"(null)"] || [str2 isEqualToString:@"0.00"]) {
              jieguo.text = @"未中奖";
                
            }else{
                zhongjiang.text = [NSString stringWithFormat:@"%@元",str2];
                jieguo.text = @"已中奖";
            }
        }
        
    }else{
        NSString * result = [NSString stringWithFormat:@"%@",order.itemStatus];//
        if ([result isEqualToString:@"WAITDO"]) {
            jieguo.text = @"待追号";
            kaijianghaoma.text = @"";
        }else if ([result isEqualToString:@"CATCHED"]) {
            if ([order.payStatus isEqualToString:@"NotPaid"] || [order.payStatus isEqualToString:@"FailedToPay"]) {
                NSString * str = [NSString stringWithFormat:@"%@",order.remark];
            
                if (str.length >= 6) {
                    str = @"未支付";
                    jieguo.text = str;
                }
                if ([str isEqualToString:@"余额不足"]) {
                    str = @"出票失败";
                    jieguo.text = str;
                    kaijianghaoma.text = @"余额不足";
                }else if ([str isEqualToString:@"(null)"]||[str isEqualToString:@"null"]){
                    jieguo.text = @"";
                    
                    if ([order.ticketRemark isEqualToString:@"(null)"] ||[order.ticketRemark isEqualToString:@"null"]) {
                        jieguo.text = @"";
                    }else{
                        jieguo.text = order.ticketRemark;
                    }
                }else{
                    jieguo.text = str; //未追原因
                }
            }else
            {
                NSString * StrorderStatus= [NSString stringWithFormat:@"%@",order.orderStatus];
                if([StrorderStatus isEqualToString:@"3"])
                {
                    switch ([order.winningStatus intValue]) {
                        case 0:
                            jieguo.text = @"等待开奖";
                            self.contentView.backgroundColor = [UIColor yellowColor];
                            kaijianghaoma.text = @"";
                            break;
                        case 1:
                            jieguo.text = @"未中奖";
                            break;
                        case 2:
                            jieguo.text = @"中奖";
                            [self whenwin];
                            break;
                            
                        default:
                            break;
                    }
                }
                else if([StrorderStatus isEqualToString:@"1"] ||[StrorderStatus isEqualToString:@"2"]||[StrorderStatus isEqualToString:@"9"])
                {
                    //出票失败
                    jieguo.text = @"出票中";
                    kaijianghaoma.text = @"";
                }
                else if([StrorderStatus isEqualToString:@"4"])
                {
                    jieguo.text = @"出票失败";
                    
                    if ([order.ticketRemark isEqualToString:@"(null)"] ||[order.ticketRemark isEqualToString:@"null"]) {
                        kaijianghaoma.text = @"";
                    }else{
                        kaijianghaoma.text = order.ticketRemark;
                    }
                }
                else
                {
                    jieguo.text = @"出票失败";
                    if ([order.ticketRemark isEqualToString:@"(null)"] ||[order.ticketRemark isEqualToString:@"null"]) {
                        kaijianghaoma.text = @"";
                    }else{
                        kaijianghaoma.text = order.ticketRemark;
                    }
                }
            }
        }else if ([result isEqualToString:@"CANCLE"]) {
            jieguo.text = @"撤销追号";
        }
    }
    
    if ([str2 isEqualToString:@"(null)"] || [str2 isEqualToString:@"0.00"]) {
        zhongjiang.textColor = SystemGray;
        jieguo.textColor = SystemGray;
        
    }else{
        zhongjiang.textColor = SystemRed;
        jieguo.text = @"已中奖";
        jieguo.textColor = SystemRed;
    }
}


@end
