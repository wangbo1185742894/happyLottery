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
    __weak IBOutlet UILabel *labSchemeState;
    __weak IBOutlet UILabel *labSchemeInfo;
    
    __weak IBOutlet UILabel *labSchemeTime;
    __weak IBOutlet MGLabel *labTicketCount;
    __weak IBOutlet UILabel *labLottery;
    __weak IBOutlet UILabel *labSchemeNo;
    __weak IBOutlet UILabel *labBetCount;
    __weak IBOutlet UILabel *labBetCost;
    __weak IBOutlet UILabel *labChuanFa;
    JCZQSchemeItem *scheme;
}
@end

@implementation SchemeDetailViewCell


-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"SchemeDetailViewCell" owner: nil options:nil] lastObject];
    }
    return self;
}
//_winningStatus    __NSCFString *    @"WAIT_LOTTERY"    0x00000001c462a140
-(void)reloadDataModel:(JCZQSchemeItem*)model{
    labTicketCount.adjustsFontSizeToFitWidth = YES;
    scheme = model;
    labSchemeState.text = [model getSchemeState];
    
    if ([model.costType isEqualToString:@"CASH"]) {
        labSchemeInfo.text = @"订单状态";
        labTicketCount.text = [NSString stringWithFormat:@"出票%@/%@单",model.printCount,model.ticketCount];
    }else{
        labSchemeInfo.text = @"方案状态";
        labTicketCount.text = @"";
    }
    
    labSchemeTime.text = model.createTime;
    labLottery.text = [self getLotteryByCode:model.lottery];
    labSchemeNo.text = model.schemeNO;
    if ([model.costType isEqualToString:@"CASH"]) {
        labBetCount.text = [NSString stringWithFormat:@"%@注%@倍   %@元",model.units,model.multiple,model.betCost];
    }else{
        labBetCount.text = [NSString stringWithFormat:@"%@注%@倍   %@积分",model.units,model.multiple,model.betCost];
    }
    
    labBetCost.text = [self getWinningStatus:model];

    labChuanFa.text = [self getChuanFa];
}

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
        return @"未中奖";
    }
    if ([model.bonus doubleValue] != 0) {
        return [NSString stringWithFormat:@"%.2f",[model.bonus doubleValue]];
        labBetCost.textColor = SystemRed;
        
    }
    return @"";
    
}




-(NSString *)getChuanFa{
    NSString *chuanfa;
    NSInteger rownum;
    if (KscreenWidth == 568) {
        rownum = 5;
    }else{
        rownum = 7;
    }
    
    if ([scheme.lottery isEqualToString:@"JCZQ"]) {
        NSDictionary *dic = [Utility objFromJson:scheme.betContent];
        NSString *item;
        float height = 0;
        if ([[dic allKeys] containsObject:@"passTypes"]) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSArray *types = (NSArray*)dic[@"passTypes"];
                item = [types componentsJoinedByString:@","];
                NSArray *passTypes =  (NSArray*)dic[@"passTypes"];
                
                if (passTypes.count %rownum == 0) {
                    height += passTypes.count/rownum *20;
                }else{
                    height += (passTypes.count/rownum + 1) *18;
                }
                
            }else{
                
                item = @"";
            }
        }else{
            if ([dic isKindOfClass:[NSDictionary class]]) {
                item = dic[@"passType"];
                height = 20;
            }else{
                
                item = @"";
            }
        }
        
        chuanfa =[self getPassType:item];
    }
    return chuanfa;
}

-(NSString *)getPassType:(NSString *)passType{
    
    
    
    @try {
        NSArray *passTypes = [passType componentsSeparatedByString:@","];
        NSString *trPassType;
        NSMutableArray *types = [NSMutableArray arrayWithCapacity:0];
        
        for (NSString *type in passTypes) {
            if ([type isEqualToString:@"P1"]) {
                [types addObject: @"单场"];
            }else{
                
                NSString * temp  = [type stringByReplacingCharactersInRange:NSMakeRange(0, 1) withString:@""];
                
                [types addObject:[temp stringByReplacingOccurrencesOfString:@"_" withString:@"串"]];
            }
        }
        
        trPassType = [types componentsJoinedByString:@","];
        
        
        return trPassType;
    } @catch (NSException *exception) {
        return @"";
    }
    
}

-(NSString *)getLotteryByCode:(NSString *)code{
    if ([code isEqualToString:@"JCZQ"]) {
        return @"竞彩足球";
    } //以后加彩种 在这加
    return @"彩票";
}

@end
