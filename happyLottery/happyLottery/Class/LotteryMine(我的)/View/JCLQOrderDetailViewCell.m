
//
//  JCLQOrderDetailViewCell.m
//  Lottery
//
//  Created by 王博 on 16/10/13.
//  Copyright © 2016年 AMP. All rights reserved.
//



#import "JCLQOrderDetailViewCell.h"

@interface JCLQOrderDetailViewCell()
{
    NSDictionary *itemDic;
}
@end

@implementation JCLQOrderDetailViewCell
{
    
    NSMutableString * content;
    
}

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
         self = [[[NSBundle mainBundle]loadNibNamed:@"JCLQOrderDetailViewCell" owner:nil options:nil] lastObject];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}



//    /** 未支付 */
//    NotPaid("未支付 "),
//    /** 支付成功 */
//    PaySuccess("支付成功"),
//    /** 取消*/
//    Cancel("取消"),
//    /** 出票失败*/
//    TlcketFail("出票失败")
//    /** 废弃*/
//    Disable("废弃");

//    /**	 * 等待开奖	 */
//    WAIT_LOTTERY("等待开奖"),
//    /**	 * 未中奖	 */[10]    (null)    @"afterTaxBonus" : (no summary)
//    NOT_LOTTERY("未中奖"),
//    /**	 * 中奖	 */[8]    (null)    @"passType" : @"P2_1"
//    LOTTERY("中奖");[2]    (null)    @"ticketContent" : @"[{\"matchId\":\"周一003\",\"matchKey\":\"102865\",\"options\":[\"3\",\"1\",\"0\"],\"playType\":1},{\"matchId\":\"周一005\",\"matchKey\":\"102867\",\"options\":[\"3\",\"1\"],\"playType\":1}]"
-(void)reloadData:(NSDictionary *)dic{
    itemDic = dic;
    self.labTouzhuneirong.layer.borderWidth = 1;
    self.labTouzhuneirong.layer.borderColor =TFBorderColor.CGColor;
    
    self.labPassType.text = [self getPasstype:dic[@"passType"]];
    
   
    
    self.viewSubContent.layer.borderColor = TFBorderColor.CGColor;
    self.viewSubContent.layer.borderWidth = 1;
    
    self.labBetCost.text = [NSString stringWithFormat:@"%@元",dic[@"subscription"]];
    NSArray *titleArray = [Utility objFromJson:dic[@"ticketContent"]];
    titleArray = [self getBetcontent:titleArray];
    content  = [titleArray componentsJoinedByString:@"\n"];
    
    self.labTouzhuneirong.text = content ;
    self.labTouzhuneirong.adjustsFontSizeToFitWidth = YES;
    self.labNumber.text = [NSString stringWithFormat:@"%@注%@倍",dic[@"unit"],dic[@"multiple"]];
    
    [self setNumberColor:self.labNumber];
    NSString *orderStatus = dic[@"orderStatus"];
    NSString *winningStatus = dic[@"winningStatus"];
    NSString *subCost =[NSString stringWithFormat:@"%@元",dic[@"subscription"]] ;
    
    [self setLabTextColor:SystemGray];
    
    
        if ([orderStatus isEqualToString:@"SUC_TICKET"]){
            self.labChupiao.text = @"出票成功";
        }else if([orderStatus isEqualToString:@"FAIL_TICKET"]){
            self.labChupiao.text = @"出票失败";
            if (dic[@"remark"] != nil) {
                self.labChupiao.text = [NSString stringWithFormat:@"出票失败(%@)",dic[@"remark"]];
            }else{
                
            }
            
        }else{
            self.labChupiao.text = @"出票中";
            
        }
    self.imgWinIcon.hidden = YES;
    if ([winningStatus isEqualToString:@"LOTTERY"]) {
        float jingjin =[dic[@"afterTaxBonus"] floatValue];
        self.labJiangjin.text = [NSString stringWithFormat:@"%.2f元",jingjin];
        self.imgWinIcon.hidden = NO;
        [self setLabTextColor:SystemRed];
        //                self.labJiangjin.text = [NSString stringWithFormat:@"%.2f",jingjin];
    }else if([winningStatus isEqualToString:@"NOT_LOTTERY"]){
        
        self.labJiangjin.text = @"未中奖";
    }else{
       
        self.labJiangjin.text = @"待开奖";
    }

 //   [5]	(null)	@"winningStatus" : @"WAIT_LOTTERY"  NOT_LOTTERY  LOTTERY
 //   [3]	(null)	@"orderStatus" : @"FAIL_TICKET"  SUC_TICKET  WAIT_PAY

}

-(NSString *)getPasstype:(NSString *)type{
    
    if (type == nil || type .length == 0) {
        return @"";
    }
    if ([type isEqualToString:@"P1"]) {
        return @"单关";
    }
    return  [[type substringFromIndex:1] stringByReplacingOccurrencesOfString:@"_" withString:@"串"];
}

-(void)setLabTextColor:(UIColor *)color{

    self.labTouzhuneirong.textColor = color;
    self.labJiangjin.textColor = color;
  
    
}


-(CGFloat)getCellHeight:(NSDictionary*)dic{
    NSArray *titleArray = [Utility objFromJson:dic[@"ticketContent"]] ;
    
    titleArray = [self getBetcontent:titleArray];
    NSString * content = [titleArray componentsJoinedByString:@"\n"];
    
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin;
    
    
//    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:15]};


   float width = [UIScreen mainScreen].bounds.size.width;
   return [content boundingRectWithSize:CGSizeMake(KscreenWidth - 50, 0) options:opts attributes:attributes context:nil].size.height + 150;

}

-(NSString *)reloadDataWithRec:(NSArray *)option type:(NSString *)playType andMatchLine:(NSString *)matchLine andMatchkey:(NSString *)matchKey{
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JingCaiOrderCode" ofType: @"plist"]] ;
    NSDictionary *contentArray;
    NSInteger index;
    NSMutableString*content = [NSMutableString string];
    [content appendString:matchLine];
    [content appendString:@":"];
    switch ([playType integerValue]) {
        case 1:
            index = 100;
            contentArray = dic[@"SPF"];
            
            break;
        case 5:
            index = 200;
            contentArray = dic[@"RQSPF"];
            
            break;
        case 4:
            index = 400;
            contentArray = dic[@"BQC"];
            
            break;
        case 2:
            index = 300;
            contentArray = dic[@"JQS"];
            
            break;
        case 3:
            index = 500;
            contentArray = dic[@"BF"];
            
            break;
        default:
            break;
    }
    
    for (NSString *op in option) {
        
        NSString*type = [self getContent:contentArray andOption:op];
        NSString *odd = [self getOddWithOption:op matchKey:matchKey];
        
        if (odd.length == 0 || odd == nil) {
            [content appendFormat:@"【%@】",type,odd];
        }else{
            [content appendFormat:@"【%@@%@】",type,odd];
        }
    }
    
    if (content.length >1) {
        return content;
    }
    return @"";
}

-(NSString*)getContent:(NSDictionary*)contentArray andOption:(NSString*)option{
    for (NSDictionary *dic in contentArray.allValues) {
//        NSInteger type =  [dic[@"code"] integerValue]%100;
//        if (type == [option integerValue]) {
//            return dic[@"appear"];
//        }
                if (dic[option] != nil) {
                    return dic[option];
                }
    }
    return @"";
}

-(NSString*)getContentJCZQ:(NSDictionary*)contentArray andOption:(NSString*)option{
    for (NSDictionary *dic in contentArray.allValues) {
        if ([dic[@"code"] integerValue]  == [option integerValue]) {
            return dic[@"appear"];
        }
    }
    return nil;
}

-(NSArray* )getBetcontent:(NSArray  *)arr{

    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary  *itemDic in arr) {
        
        NSString *str = [self reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"] andMatchLine:itemDic[@"matchId"] andMatchkey:itemDic[@"matchKey"]];
        [marr addObject:str];
    }
    return marr;
}



- (void)setNumberColor:(UILabel *)contentLabel{
    NSMutableAttributedString  *attStr = [[NSMutableAttributedString alloc] initWithString:contentLabel.text];
    NSString *temp = @"";
    for (NSInteger i =0; i<[contentLabel.text length]; i++) {
        temp = [contentLabel.text substringWithRange:NSMakeRange(i, 1)];
        if ([self isInt:temp]) {
            [attStr setAttributes:@{NSForegroundColorAttributeName:SystemGreen} range:NSMakeRange(i, 1)];
        }
    }
    contentLabel.attributedText = attStr;
}

- (BOOL)isInt:(NSString *)string{
    string = [string stringByTrimmingCharactersInSet:[NSCharacterSet decimalDigitCharacterSet]];
    if (string.length > 0) {
        return NO;
    }
    return YES;
    
}

-(NSString *)getOddWithOption:(NSString *)option matchKey:(NSString *)matchKey{
    if (itemDic[@"odds"] == nil) {
        return @"";
    }
    NSDictionary *itemOddsDic = [Utility objFromJson:itemDic[@"odds"]];
    NSArray *oddsArray =itemOddsDic[@"itemsOdds"];
    for (NSDictionary *itemDic in oddsArray) {
        if ([itemDic[@"matchKey"] integerValue] == [matchKey integerValue]) {
            NSDictionary *odds = [Utility objFromJson:itemDic[@"odds"]];
            return odds[option];
        }
    }
    return @"";
    
}

@end
