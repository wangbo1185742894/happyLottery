
//
//  JCLQOrderDetailViewCell.m
//  Lottery
//
//  Created by 王博 on 16/10/13.
//  Copyright © 2016年 AMP. All rights reserved.
//



#import "JCLQOrderDetailViewCell.h"
#import "X115SchemeViewCell.h"
#import "MGLabel.h"

@interface JCLQOrderDetailViewCell()
{
    NSDictionary *itemDic;
    NSMutableArray *openResult;
}
@end

@implementation JCLQOrderDetailViewCell
{
    
    NSMutableString * content;
    NSString *redText;
    
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

- (NSMutableArray *)reloadDataSSQ:(NSDictionary *)dic{
    NSArray *titleArray = [Utility objFromJson:dic[@"ticketContent"]];
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    for (NSString *itemStr in titleArray) {
        NSDictionary *itemDic = [Utility objFromJson:itemStr];
        NSArray *redList = itemDic[@"redList"];
        NSArray *redDanList = itemDic[@"redDanList"];
        NSArray *blueList = itemDic[@"blueList"];
        if (redList.count!=0&&blueList.count!=0&&redList!=nil&&blueList!=nil) {
            NSString *strRed;
            NSString *strBlue;
            NSString *redDanStr;
            strRed = [redList componentsJoinedByString:@","];
            strBlue = [blueList componentsJoinedByString:@","];
            if (redDanList != nil && redDanList.count !=0) {
                redDanStr = [redDanList componentsJoinedByString:@","];
                redDanStr = [NSString stringWithFormat:@"%@#",redDanStr];
                [marr addObject:[NSString stringWithFormat:@"%@%@+%@",redDanStr,strRed,strBlue]];
            }
            else {
                [marr addObject:[NSString stringWithFormat:@"%@+%@",strRed,strBlue]];
            }
        }
    }
    return marr;
}

//标红
- (NSMutableAttributedString *)contentWithRed:(NSArray *)titleArray{
    NSMutableAttributedString *att = [[NSMutableAttributedString alloc]init];
    for (NSDictionary *dicCon in titleArray) {
        MGLabel *label = [[MGLabel alloc]init];
        label.text = dicCon[@"contents"];
        label.textColor = RGBCOLOR(72, 72, 72);
        label.keyWordColor = [UIColor redColor];
        label.keyWord = dicCon[@"winText"];
        label.font = [UIFont systemFontOfSize:13];
        [att appendAttributedString:label.attributedText];
        [att appendAttributedString:[[NSMutableAttributedString alloc]initWithString:@"\n"]];
    }
    return att;
}


- (void)reloadDataFollowInit:(NSDictionary *)dic openResult:(NSMutableArray *)array{
    itemDic = dic;
    openResult = [array copy];
    self.labelTouTitle.text = @"投注内容";
    self.labTouzhuneirong.layer.borderWidth = 1;
    self.labTouzhuneirong.layer.borderColor =TFBorderColor.CGColor;
    self.viewSubContent.layer.borderColor = TFBorderColor.CGColor;
    self.viewSubContent.layer.borderWidth = 1;
    self.labBetCost.text = [NSString stringWithFormat:@"%@元",dic[@"subscription"]];
    self.labPassType.text = [self getPasstype:dic[@"passType"]];
    NSArray *titleArray = [Utility objFromJson:dic[@"ticketContent"]];
    //中奖标红
    if ([dic[@"winningStatus"] isEqualToString:@"LOTTERY"]) {
        if([dic[@"lotteryCode"] isEqualToString:@"JCLQ"]){
            titleArray = [self getJCLQOpenContent:titleArray];
        } else {
            titleArray = [self getOpenContent:titleArray];
        }
        self.labTouzhuneirong.attributedText = [self contentWithRed:titleArray];
    }
    else {
        if([dic[@"lotteryCode"] isEqualToString:@"JCLQ"]){
            titleArray = [self getJCLQBetcontent:titleArray];
        }else {
            titleArray = [self getBetcontent:titleArray];
        }
        content  = [titleArray componentsJoinedByString:@"\n"];
        self.labTouzhuneirong.text = content ;
    }
    self.labTouzhuneirong.adjustsFontSizeToFitWidth = YES;
    self.labNumber.text = [NSString stringWithFormat:@"%@注%@倍",dic[@"unit"],dic[@"multiple"]];
    NSString *orderStatus = dic[@"orderStatus"];
    NSString *winningStatus = dic[@"winningStatus"];
    NSString *subCost =[NSString stringWithFormat:@"%@元",dic[@"subscription"]] ;
    if ([orderStatus isEqualToString:@"SUC_TICKET"]){
        self.labChupiao.text = @"出票成功";
    }else if([orderStatus isEqualToString:@"FAIL_TICKET"]){
        self.labChupiao.text = @"出票失败";
        if (dic[@"remark"] != nil) {
            self.labChupiao.text = [NSString stringWithFormat:@"出票失败(%@)",dic[@"remark"]];
        }
    }else{
        self.labChupiao.text = @"出票中";
    }
    self.imgWinIcon.hidden = YES;
    if ([winningStatus isEqualToString:@"LOTTERY"]) {
        float jingjin =[dic[@"afterTaxBonus"] floatValue];
        self.labJiangjin.text = [NSString stringWithFormat:@"%.2f元",jingjin];
        self.imgWinIcon.hidden = NO;
    }else if([winningStatus isEqualToString:@"NOT_LOTTERY"]){
        self.labJiangjin.text = @"未中奖";
    }else{
        self.labJiangjin.text = @"待开奖";
    }
    [self reloadLabelColor:winningStatus];
}

- (void)reloadLabelColor:(NSString *)winningStatus {
    if ([winningStatus isEqualToString:@"LOTTERY"]){
        self.labPassType.textColor = RGBCOLOR(254, 58, 81);
        self.labNumber.textColor = RGBCOLOR(254, 58, 81);
        self.labBetCost.textColor = RGBCOLOR(254, 58, 81);
        self.labJiangjin.textColor = RGBCOLOR(254, 58, 81);
//        self.labTouzhuneirong.textColor = RGBCOLOR(254, 58, 81);
        
    }
    else {
        self.labPassType.textColor = RGBCOLOR(49, 137, 253);
        self.labNumber.textColor = RGBCOLOR(49, 137, 253);
        self.labBetCost.textColor = RGBCOLOR(49, 137, 253);
        self.labJiangjin.textColor = RGBCOLOR(49, 137, 253);
        self.labTouzhuneirong.textColor = RGBCOLOR(72, 72, 72);
    }
}

-(void)reloadData:(NSDictionary *)dic openResult:(NSMutableArray *)array{
    itemDic = dic;
    openResult = [array copy];
    self.labTouzhuneirong.layer.borderWidth = 1;
    self.labTouzhuneirong.layer.borderColor =TFBorderColor.CGColor;
    self.viewSubContent.layer.borderColor = TFBorderColor.CGColor;
    self.viewSubContent.layer.borderWidth = 1;
    self.labBetCost.text = [NSString stringWithFormat:@"%@元",dic[@"subscription"]];
    if([dic[@"lotteryCode"] isEqualToString:@"DLT"]){
        content = dic[@"ticketContent"];
        content = [content stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
        self.disLeftPlayType.constant = -self.labPlayType.mj_w - 20;
        self.disLeftPlayTypeContent.constant = -self.labPlayType.mj_w - 20;
        NSString *leshanCode = dic[@"leShanCode"];
        if (leshanCode == nil) {
            self.btnLeshanCode.hidden = YES;
        }else{
            self.btnLeshanCode.hidden = NO;
            [self.btnLeshanCode setTitle:leshanCode forState:0];
        }
        self.labTouzhuneirong.text = content ;
    } else  if([dic[@"lotteryCode"] isEqualToString:@"SX115"] || [dic[@"lotteryCode"] isEqualToString:@"SD115"]){
        NSString *type;
        if([dic[@"betType"] isEqualToString:@"Single"] || [dic[@"betType"] isEqualToString:@"Direct"] || [dic[@"betType"] isEqualToString:@"Double"]){
             type = [NSString stringWithFormat:@"%@",dic[@"playType"]];
        }else{
             type = [NSString stringWithFormat:@"%@%@",dic[@"playType"],dic[@"betType"]];
        }
       
        
        content = dic[@"ticketContent"];
        content = [content stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
        self.labPlayType.hidden = NO;
        self.labPassType.hidden = NO;
        self.labPassType.text = [X115SchemeViewCell X115CHNTypeByEnType:type] == nil?@"":[X115SchemeViewCell X115CHNTypeByEnType:type];
        NSString *leshanCode = dic[@"leShanCode"];
        if (leshanCode == nil) {
            self.btnLeshanCode.hidden = YES;
        }else{
            self.btnLeshanCode.hidden = NO;
            [self.btnLeshanCode setTitle:leshanCode forState:0];
        }
        self.labTouzhuneirong.text = content ;
    }else if ([dic[@"lotteryCode"] isEqualToString:@"SSQ"]){
        self.disLeftPlayType.constant = -self.labPlayType.mj_w - 50;
        self.disLeftPlayTypeContent.constant = -self.labPlayType.mj_w - 50;
        NSMutableArray *array = [self reloadDataSSQ:dic];
        content = [array componentsJoinedByString:@"\n"];
        self.labTouzhuneirong.text = content ;
    }
    else if([dic[@"lotteryCode"] isEqualToString:@"RJC"] || [dic[@"lotteryCode"] isEqualToString:@"SFC"]){
        content = dic[@"ticketContent"];
        content = [content stringByReplacingOccurrencesOfString:@";" withString:@"\n"];
        self.disLeftPlayType.constant = -self.labPlayType.mj_w - 20;
        self.disLeftPlayTypeContent.constant = -self.labPlayType.mj_w - 20;
        self.labTouzhuneirong.text = content ;
    }else if([dic[@"lotteryCode"] isEqualToString:@"JCLQ"]){
        self.labPassType.text = [self getPasstype:dic[@"passType"]];
        NSArray *titleArray = [Utility objFromJson:dic[@"ticketContent"]];
        if ([dic[@"winningStatus"] isEqualToString:@"LOTTERY"]) {
            titleArray = [self getJCLQOpenContent:titleArray];
            self.labTouzhuneirong.attributedText = [self contentWithRed:titleArray];
        } else {
            titleArray = [self getJCLQBetcontent:titleArray];
            content  = [titleArray componentsJoinedByString:@"\n"];
            self.labTouzhuneirong.text = content ;
        }
    }else{
        self.labPassType.text = [self getPasstype:dic[@"passType"]];
        NSArray *titleArray = [Utility objFromJson:dic[@"ticketContent"]];
        if ([dic[@"winningStatus"] isEqualToString:@"LOTTERY"]) {
            titleArray = [self getOpenContent:titleArray];
            self.labTouzhuneirong.attributedText = [self contentWithRed:titleArray];
        } else {
            titleArray = [self getBetcontent:titleArray];
            content  = [titleArray componentsJoinedByString:@"\n"];
            self.labTouzhuneirong.text = content ;
        }
    }
    
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
    [self reloadLabelColor:winningStatus];
}


-(void)reloadDataGYJ:(NSDictionary *)dic{
        self.labNumber.adjustsFontSizeToFitWidth = YES;
        self.labTouzhuneirong.adjustsFontSizeToFitWidth = YES;

        self.labChupiao.adjustsFontSizeToFitWidth = YES;
        self.labJiangjin.adjustsFontSizeToFitWidth = YES;

//        self.labBeishu.text = [NSString stringWithFormat:@"%@元",dic[@"subCost"]];
        NSArray *titleArray = [Utility objFromJson:dic[@"ticketContent"]];
        NSMutableArray *contentArray = [NSMutableArray arrayWithCapacity:0];
        NSMutableArray *oddsArray = [NSMutableArray arrayWithCapacity:0];
    //排序
    NSMutableArray *arrySort = [NSMutableArray array];
    for (NSString *itemStr in titleArray) {
        NSDictionary *itemDic = [Utility objFromJson:itemStr];
        [arrySort addObject:itemDic];
    }
    NSArray *arrySortYes = [arrySort mutableCopy];
    NSSortDescriptor *descriptor = [NSSortDescriptor sortDescriptorWithKey:@"index" ascending:YES];
    arrySortYes = [arrySortYes sortedArrayUsingDescriptors:@[descriptor]];
    titleArray = [arrySortYes copy];
    //
        for (NSString *itemStr in titleArray) {
            NSDictionary *itemDic = [Utility objFromJson:itemStr];
            
            if (itemDic[@"odds"] != nil) {
                [oddsArray addObject:itemDic[@"odds"]];
            }
            if (itemDic[@"odds"]!=nil) {
                [contentArray addObject:[NSString stringWithFormat:@"%@%@(%@)",itemDic[@"index"],itemDic[@"clash"],itemDic[@"odds"]]];
            }
            else {
                [contentArray addObject:[NSString stringWithFormat:@"%@%@",itemDic[@"index"],itemDic[@"clash"]]];
            }
        }
        self.disLeftPlayType.constant = -self.labPlayType.mj_w - 50;
        self.disLeftPlayTypeContent.constant = -self.labPlayType.mj_w - 50;
        self.labNumber.text = [NSString stringWithFormat:@"%ld注%@倍",titleArray.count,dic[@"multiple"]];
        self.labTouzhuneirong.text = [contentArray componentsJoinedByString:@"\n"];
    
        if ( [self.labTouzhuneirong.text rangeOfString:@"—"].location !=NSNotFound ) {
            self.labTouzhuneirong.text = [self.labTouzhuneirong.text stringByReplacingOccurrencesOfString:@"—" withString:@"   vs   "];
        }
//        self.labSpTitle.text = @"赔率";
        [self setNumberColor:self.labNumber];
        NSString *orderStatus = dic[@"orderStatus"];
        NSString *winningStatus = dic[@"winningStatus"];
        NSString *subCost =[NSString stringWithFormat:@"%@元",dic[@"subCost"]] ;
//        self.labBetCount.text = subCost == nil?@"0":subCost;
        [self setLabTextColor:TEXTGRAYCOLOR];
        self.labBetCost.text = [NSString stringWithFormat:@"%@元",dic[@"subscription"]];

        if ([orderStatus isEqualToString:@"SUC_TICKET"]){
            self.labChupiao.text = @"出票成功";
        }else if([orderStatus isEqualToString:@"FAIL_TICKET"]){
            self.labChupiao.text = @"出票失败";
            if (dic[@"remark"] != nil) {
                self.labChupiao.text = [NSString stringWithFormat:@"出票失败(%@)",dic[@"remark"]];
            }else{

            }
//            self.labRemark.adjustsFontSizeToFitWidth = YES;

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
        }else if([winningStatus isEqualToString:@"WAIT_LOTTERY"]){
            self.labJiangjin.text = @"待开奖";
        }else {
            self.labJiangjin.text = @"";
        }

        //   [5]    (null)    @"winningStatus" : @"WAIT_LOTTERY"  NOT_LOTTERY  LOTTERY
        //   [3]    (null)    @"orderStatus" : @"FAIL_TICKET"  SUC_TICKET  WAIT_PAY
       [self reloadLabelColor:winningStatus];

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

//    self.labTouzhuneirong.textColor = color;
    self.labJiangjin.textColor = color;
  
    
}


-(CGFloat)getCellHeight:(NSDictionary*)dic{
    if([dic[@"lotteryCode"] isEqualToString:@"DLT"] || [dic[@"lotteryCode"] isEqualToString:@"SFC"] || [dic[@"lotteryCode"] isEqualToString:@"RJC"]||[dic[@"lotteryCode"] isEqualToString:@"SX115"]||[dic[@"lotteryCode"] isEqualToString:@"SD115"]){
        NSString *leshanCode = dic[@"leShanCode"];
        if (leshanCode != nil) {
              return [dic[@"ticketContent"] componentsSeparatedByString:@";"].count * 12 + 180;
        }else{
         return [dic[@"ticketContent"] componentsSeparatedByString:@";"].count * 12 + 150;
        }

    }else if ([dic[@"lotteryCode"] isEqualToString:@"JCGJ"] || [dic[@"lotteryCode"] isEqualToString:@"JCGYJ"]){
        NSArray *titleArray = [Utility objFromJson:dic[@"ticketContent"]];
        return titleArray.count * 12 + 150;
    }else if ([dic[@"lotteryCode"] isEqualToString:@"SSQ"]){
        NSMutableArray *array = [self reloadDataSSQ:dic];
        return array.count * 12 + 150;
    }
    NSArray *titleArray = [Utility objFromJson:dic[@"ticketContent"]] ;
    
    titleArray = [self getBetcontent:titleArray];
    
    NSString * content = [titleArray componentsJoinedByString:@"\n"];
    
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin;
    
    
//    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:15]};


   float width = [UIScreen mainScreen].bounds.size.width;
   return [content boundingRectWithSize:CGSizeMake(KscreenWidth - 50, 0) options:opts attributes:attributes context:nil].size.height + 150;

}

-(NSString *)reloadJCLQDataWithRec:(NSArray *)option type:(NSString *)playType andMatchLine:(NSString *)matchLine andMatchkey:(NSString *)matchKey{
    
    NSDictionary *dic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"JCLQCode" ofType: @"plist"]] ;
    NSDictionary *contentArray;
    NSInteger index;
    NSMutableString*content = [NSMutableString string];
    [content appendString:matchLine];
    [content appendString:@":"];
    switch ([playType integerValue]) {
        case 1:
            index = 100;
            contentArray = dic[@"SF"];
            
            break;
        case 2:
            index = 200;
            contentArray = dic[@"RFSF"];
            
            break;
        case 4:
            index = 400;
            contentArray = dic[@"DXF"];
            
            break;
        case 3:
            index = 300;
            contentArray = dic[@"SFC"];
            
            break;
        default:
            break;
    }
    NSString *winType = [self setJCLQContentWin:playType resultArray:openResult Matchkey:matchKey];
    redText = @"";
    for (NSString *op in option) {
        
        NSString*type = [self getContentJCLQ:contentArray andOption:op];
        NSString *odd = [self getOddWithOption:op matchKey:matchKey];
        NSString *handicap = [self getHandWithmatchKeyLQ:matchKey];
        NSString *cont;
        if (odd.length == 0 || odd == nil) {
            if (handicap.length == 0 ||handicap == nil){
                cont = [NSString stringWithFormat:@"【%@】",type];
            } else {
                cont = [NSString stringWithFormat:@"【%@(%@)】",type,handicap];
            }
        } else{
            if (handicap.length == 0 ||handicap == nil){
                cont = [NSString stringWithFormat:@"【%@@%@】",type,odd];
            } else {
                cont = [NSString stringWithFormat:@"【%@(%@)@%@】",type,handicap,odd];
            }
        }
        [content appendString:cont];
        if ([op isEqualToString:winType]) {
            redText = cont;
        }
    }
    if (content.length >1) {
        return content;
    }
    return @"";
}

//竞蓝开奖比对
- (NSString *)setJCLQContentWin:(NSString *)playType resultArray:(NSArray *)openResult Matchkey:(NSString *)matchKey{
    JCLQOpenResult * openRt;
    for (JCLQOpenResult  *result in openResult) {
        if ([result.matchKey isEqualToString:matchKey]) {
            openRt = result;
            break;
        }
    }
    
    NSString *result;
    switch ([playType integerValue]) {
        case 1:
            result = openRt.SF;
            break;
            
        case 2:
            result = openRt.RFSF;
            break;
            
        case 4:
            result = openRt.DXF;
            break;
            
        case 3:
            result = openRt.SFC;
            break;
            
        default:
            break;
    }
    return result;
}

//竞足开奖比对
- (NSString *)setContentWin:(NSString *)playType resultArray:(NSArray *)openResult Matchkey:(NSString *)matchKey{
    OpenResult *openRt;
    for (OpenResult  *result in openResult) {
        if ([result.matchKey isEqualToString:matchKey]) {
            openRt = result;
            break;
        }
    }
    NSString *result;
    switch ([playType integerValue]) {
        case 1:
            result = openRt.SPF;
            break;
        case 2:
            result = openRt.JQS;
            break;
        case 3:
            result = openRt.BF;
            break;
        case 4:
            result = openRt.BQC;
            break;
        case 5:
            result = openRt.RQSPF;
            break;
        default:
            result = nil;
            break;
    }
    return result;
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
    NSString *winType = [self setContentWin:playType resultArray:openResult Matchkey:matchKey];
    redText = @"";
    for (NSString *op in option) {
        NSString*type = [self getContent:contentArray andOption:op];
        NSString *odd = [NSString stringWithFormat:@"%@",[self getOddWithOption:op matchKey:matchKey]];
        NSString *handicap = [self getHandWithmatchKeyZQ:matchKey];
        NSString *cont;
        if (odd.length == 0 || odd == nil) {
            if (handicap.length == 0 ||handicap == nil){
                cont = [NSString stringWithFormat:@"【%@】",type];
            } else {
                cont = [NSString stringWithFormat:@"【%@(%@)】",type,handicap];
            }
        } else{
            if (handicap.length == 0 ||handicap == nil){
                cont = [NSString stringWithFormat:@"【%@@%@】",type,odd];
            } else {
                cont = [NSString stringWithFormat:@"【%@(%@)@%@】",type,handicap,odd];
            }
        }
        [content appendString:cont];
        if ([op isEqualToString:winType]) {
            redText = cont;
        }
    }
    
    if (content.length >1) {
        return content;
    }
    return @"";
}

-(NSString*)getContentJCLQ:(NSArray*)contentArray andOption:(NSString*)option{
    for (NSDictionary *dic in contentArray) {
        if (dic[option]!= nil) {
            return dic[@"appear"];
        }
    }
    return @"";
}

-(NSString*)getContent:(NSDictionary*)contentArray andOption:(NSString*)option{
    for (NSDictionary *dic in contentArray.allValues) {
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

//竞足
-(NSArray* )getBetcontent:(NSArray  *)arr{

    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary  *itemDic in arr) {

        NSString *str = [self reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"] andMatchLine:itemDic[@"matchId"] andMatchkey:itemDic[@"matchKey"]];
        [marr addObject:str];
    }
    return marr;
}

//竞足中奖
- (NSArray *)getOpenContent:(NSArray *)arr {
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary  *itemDic in arr) {
        NSString *str = [self reloadDataWithRec:itemDic[@"options"] type:itemDic[@"playType"] andMatchLine:itemDic[@"matchId"] andMatchkey:itemDic[@"matchKey"]];
        NSDictionary *dict = @{@"contents":str,@"winText":redText};
        [marr addObject:dict];
    }
    return marr;
}

//竞蓝
-(NSArray* )getJCLQBetcontent:(NSArray  *)arr{
    
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    
    for (NSDictionary  *itemDic in arr) {
        
        NSString *str = [self reloadJCLQDataWithRec:itemDic[@"options"] type:itemDic[@"playType"] andMatchLine:itemDic[@"matchId"] andMatchkey:itemDic[@"matchKey"]];
        [marr addObject:str];
    }
    return marr;
}

//竞蓝中奖
-(NSArray* )getJCLQOpenContent:(NSArray  *)arr{
    
    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    for (NSDictionary  *itemDic in arr) {
        
        NSString *str = [self reloadJCLQDataWithRec:itemDic[@"options"] type:itemDic[@"playType"] andMatchLine:itemDic[@"matchId"] andMatchkey:itemDic[@"matchKey"]];
        NSDictionary *dict = @{@"contents":str,@"winText":redText};
        [marr addObject:dict];
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

-(NSString *)getHandWithmatchKeyZQ:(NSString *)matchKey{
    if (itemDic[@"odds"] == nil) {
        return @"";
    }
    NSDictionary *itemOddsDic = [Utility objFromJson:itemDic[@"odds"]];//让球数
    NSArray *oddsArray =itemOddsDic[@"itemsOdds"];
    for (NSDictionary *itemDics in oddsArray) {
        if ([itemDics[@"playType"]isEqualToNumber:@5]){
            if ([itemDics[@"matchKey"] integerValue] == [matchKey integerValue]) {
                NSString *handicap =[Utility objFromJson:itemDics[@"handicap"]];
                if (itemDics[@"handicap"] != nil &&[itemDics[@"handicap"]compare:@0]== NSOrderedDescending) {
                    handicap = [NSString stringWithFormat:@"+%@",handicap];
                }
                return handicap;
            }
        }
    }
    return @"";
}

-(NSString *)getHandWithmatchKeyLQ:(NSString *)matchKey{
    if (itemDic[@"odds"] == nil) {
        return @"";
    }
    NSDictionary *itemOddsDic = [Utility objFromJson:itemDic[@"odds"]];//让球数
    NSArray *oddsArray =itemOddsDic[@"itemsOdds"];
    for (NSDictionary *itemDics in oddsArray) {//篮球让分数修改  lyw
        if ([itemDics[@"playType"]isEqualToNumber:@2]||[itemDics[@"playType"]isEqualToNumber:@4]) {
            if ([itemDics[@"matchKey"] integerValue] == [matchKey integerValue]) {
                if ([itemDics[@"playType"]isEqualToNumber:@2]) {
                    NSString *handicap = [Utility objFromJson:itemDics[@"handicap"]];
                    if (itemDics[@"handicap"]!=nil &&[itemDics[@"handicap"]compare:@0]== NSOrderedDescending) {
                        handicap = [NSString stringWithFormat:@"+%@",handicap];
                    }
                    return handicap;
                } else {
                    NSString *handicap = [Utility objFromJson:itemDics[@"handicap"]];
                    return handicap;
                }
            }
        }
    }
    return @"";
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
