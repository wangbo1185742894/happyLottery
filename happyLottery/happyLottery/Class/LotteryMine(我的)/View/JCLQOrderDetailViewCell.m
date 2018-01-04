
//
//  JCLQOrderDetailViewCell.m
//  Lottery
//
//  Created by 王博 on 16/10/13.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "JCLQOrderDetailViewCell.h"



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

    // Configure the view for the selected state
    //4006668800
    //w562873913
    //100043177518
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
//    /**	 * 未中奖	 */
//    NOT_LOTTERY("未中奖"),
//    /**	 * 中奖	 */
//    LOTTERY("中奖");
-(void)reloadData:(NSDictionary *)dic{

   
    self.labNumber.adjustsFontSizeToFitWidth = YES;
     self.labTouzhuneirong.adjustsFontSizeToFitWidth = YES;
     self.labBetCount.adjustsFontSizeToFitWidth = YES;
     self.labBeishu.adjustsFontSizeToFitWidth = YES;
     self.labChupiao.adjustsFontSizeToFitWidth = YES;
     self.labJiangjin.adjustsFontSizeToFitWidth = YES;

    self.labBeishu.text = [NSString stringWithFormat:@"%@元",dic[@"subCost"]];
    
    NSArray *titleArray = dic[@"betContent"];

        // 其它彩种
            content = [NSMutableString string];
        for (NSString *item in titleArray) {
            [content appendString:item];
            [content appendString:@"\n"];
        }
         content  = [content substringToIndex:content.length -1];
    

   
    
    self.labTouzhuneirong.text = content ;
    self.labNumber.text = [NSString stringWithFormat:@"投注内容 %@注%@倍",dic[@"unit"],dic[@"multiple"]];
    
    [self setNumberColor:self.labNumber];
    NSString *orderStatus = dic[@"orderStatus"];
    NSString *winningStatus = dic[@"winningStatus"];
    NSString *subCost =[NSString stringWithFormat:@"%@元",dic[@"subCost"]] ;
    self.labBetCount.text = subCost == nil?@"0":subCost;
    [self setLabTextColor:SystemGray];
    
    
        if ([orderStatus isEqualToString:@"SUC_TICKET"]){
            self.labChupiao.text = @"出票成功";
        }else if([orderStatus isEqualToString:@"FAIL_TICKET"]){
            self.labChupiao.text = @"出票失败";
            if (dic[@"remark"] != nil) {
                self.labChupiao.text = [NSString stringWithFormat:@"出票失败(%@)",dic[@"remark"]];
            }else{
                
            }
            self.labRemark.adjustsFontSizeToFitWidth = YES;
            
        }else{
            self.labChupiao.text = @"出票中";
            
        }
    
    if ([winningStatus isEqualToString:@"LOTTERY"]) {
        float jingjin =[dic[@"bonus"] floatValue];
        self.labJiangjin.text = [NSString stringWithFormat:@"%.2f元",jingjin];
        
        [self setLabTextColor:SystemGreen];
        //                self.labJiangjin.text = [NSString stringWithFormat:@"%.2f",jingjin];
    }else if([winningStatus isEqualToString:@"NOT_LOTTERY"]){
        
        self.labJiangjin.text = @"未中奖";
    }else{
       
        self.labJiangjin.text = @"";
    }

 //   [5]	(null)	@"winningStatus" : @"WAIT_LOTTERY"  NOT_LOTTERY  LOTTERY
 //   [3]	(null)	@"orderStatus" : @"FAIL_TICKET"  SUC_TICKET  WAIT_PAY

}

-(void)setLabTextColor:(UIColor *)color{

    
    self.labBeishu.textColor = color;
    self.labTouzhuneirong.textColor = color;
    self.labJiangjin.textColor = color;
    self.labPlayType.textColor = color;
    self.labBetCount.textColor = color;

}


-(CGFloat)getCellHeight:(NSDictionary*)dic{

    
    NSArray *titleArray = dic[@"betContent"];
    titleArray = [self getBetcontent:titleArray];
    NSString * content = [titleArray componentsJoinedByString:@"\n"];
    
    NSStringDrawingOptions opts = NSStringDrawingUsesLineFragmentOrigin;
    
    
//    [style setLineBreakMode:NSLineBreakByCharWrapping];
    
    NSDictionary *attributes = @{ NSFontAttributeName : [UIFont systemFontOfSize:14]};


   float width = [UIScreen mainScreen].bounds.size.width;
   return [content boundingRectWithSize:CGSizeMake(165, 0) options:opts attributes:attributes context:nil].size.height + 60;

}
-(NSArray* )getBetcontent:(NSArray  *)arr{

    NSMutableArray *marr = [NSMutableArray arrayWithCapacity:0];
    for (NSString  *betDic in arr) {
        
        NSString *str = @"";
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


@end
