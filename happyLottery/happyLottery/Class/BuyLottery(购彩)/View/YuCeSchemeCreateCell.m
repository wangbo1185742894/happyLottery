//
//  YuCeSchemeCreateCell.m
//  Lottery
//
//  Created by onlymac on 2017/10/13.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "YuCeSchemeCreateCell.h"
#import "MGLabel.h"
@interface YuCeSchemeCreateCell ()
@property (weak, nonatomic) IBOutlet MGLabel *shouyiLabel;
@property (weak, nonatomic) IBOutlet MGLabel *mingzhonglvLabel;
@property (weak, nonatomic) IBOutlet UILabel *fanganNoLabel;
@property (weak, nonatomic) IBOutlet UILabel *jiezhiLabel;
@property (weak, nonatomic) IBOutlet UILabel *kezhongLabel;
@property (weak, nonatomic) IBOutlet UILabel *labFollowCount;

- (IBAction)actionTouZhu:(UIButton *)sender;

@end
@implementation YuCeSchemeCreateCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *CellID = @"YuCeSchemeCreateCell";
    YuCeSchemeCreateCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellID owner:nil options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

-(void)refreshData:(YuCeScheme *)scheme xuQiuBtn:(NSString *)string{
    
    self.scheme = scheme;
    int tag = [string intValue];

    if (tag == 300) {
        self.shouyiLabel.textColor = TEXTGRAYOrange;
        self.mingzhonglvLabel.textColor = TEXTGRAYCOLOR;
    }else if (tag == 301){
        self.shouyiLabel.textColor = TEXTGRAYCOLOR;
        self.mingzhonglvLabel.textColor =  TEXTGRAYOrange;
    }
    self.shouyiLabel.keyWordFont = [UIFont systemFontOfSize:10];
    self.shouyiLabel.text = [NSString stringWithFormat:@"%.2f倍",[scheme.earnings doubleValue]];
    self.shouyiLabel.keyWord = @"倍";
    
    self.labFollowCount.text = [NSString stringWithFormat:@"认购人次：%@",scheme.recommendCount];
    self.mingzhonglvLabel.text = [NSString stringWithFormat:@"%@%%",scheme.predictIndex];
    self.mingzhonglvLabel.keyWordFont = [UIFont systemFontOfSize:10];
    self.mingzhonglvLabel.keyWordColor = SystemLightGray;
    self.mingzhonglvLabel.keyWord = @"%";
    self.fanganNoLabel.text = [NSString stringWithFormat:@" 方案号:%@",scheme.recSchemeNo];
    
    NSString *timeStr = [scheme.dealLine substringWithRange:NSMakeRange(5, 11)];
    self.jiezhiLabel.text = [NSString stringWithFormat:@"截止:%@",timeStr];
//    NSString *moneyStr = [NSString stringWithFormat:@"%.2f",([scheme.earnings doubleValue] * [self.monery doubleValue])];
//    self.kezhongLabel.text = [NSString stringWithFormat:@"投%@可中%@元",self.monery,moneyStr];
    
    self.fanganNoLabel.adjustsFontSizeToFitWidth = YES;
    
    
}
- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (IBAction)actionTouZhu:(UIButton *)sender {
    
    if ([self.delegate respondsToSelector:@selector(touzhuAction:)]) {
        [self.delegate touzhuAction:self.scheme];
    }
}
@end
