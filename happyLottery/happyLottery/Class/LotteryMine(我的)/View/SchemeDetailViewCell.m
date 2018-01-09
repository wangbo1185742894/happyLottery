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

-(void)reloadDataModel:(JCZQSchemeItem*)model{
    scheme = model;
    labSchemeState.text = [model getSchemeState];
    labTicketCount.text = [NSString stringWithFormat:@"出票%@/%@单",model.printCount,model.ticketCount];
    labSchemeTime.text = model.createTime;
    labLottery.text = model.lottery;
    labSchemeNo.text = model.schemeNO;
    labBetCount.text = [NSString stringWithFormat:@"%@注%@倍   %@元",model.units,model.multiple,model.betCost];
    labBetCost.text = @"mmp又没中";
    labChuanFa.text = [self getChuanFa];
}

-(NSString *)getChuanFa{
    NSString *chuanfa;
    
    if ([scheme.lottery isEqualToString:@"JCZQ"]) {
        NSDictionary *dic = [Utility objFromJson:scheme.betContent];
        NSString *item;
        float height = 0;
        if ([[dic allKeys] containsObject:@"passTypes"]) {
            if ([dic isKindOfClass:[NSDictionary class]]) {
                NSArray *types = (NSArray*)dic[@"passTypes"];
                item = [types componentsJoinedByString:@","];
                NSArray *passTypes =  (NSArray*)dic[@"passTypes"];
                
                if (passTypes.count %7 == 0) {
                    height += passTypes.count/7 *20;
                }else{
                    height += (passTypes.count/7 + 1) *18;
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


@end
