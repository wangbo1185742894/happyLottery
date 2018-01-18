//
//  YuCeLiShiZhanJCell.m
//  Lottery
//
//  Created by onlymac on 2017/10/13.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "YuCeLiShiZhanJCell.h"
#import "MGLabel.h"

@interface YuCeLiShiZhanJCell ()
@property (weak, nonatomic) IBOutlet MGLabel *touzhuLabel;

@property (weak, nonatomic) IBOutlet MGLabel *zhongjiangLabel;
@property (weak, nonatomic) IBOutlet UILabel *memberName;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

@end

@implementation YuCeLiShiZhanJCell


+ (instancetype)cellWithTableView:(UITableView *)tableView{
    static NSString *CellID = @"YuCeLiShiZhanJCell";
    YuCeLiShiZhanJCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellID owner:nil options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    //    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
    
}

- (void)refreshData:( yucezjModel *)scheme{
    self.touzhuLabel.keyWordFont = [UIFont systemFontOfSize:10];
    
    self.touzhuLabel.text = [NSString stringWithFormat:@"%.2f元",[scheme.betCost doubleValue]];
    self.touzhuLabel.keyWord = @"元";

    self.zhongjiangLabel.keyWordFont = [UIFont systemFontOfSize:10];
    self.zhongjiangLabel.text = [NSString stringWithFormat:@"%.2f元",[scheme.bonus doubleValue]];
    self.zhongjiangLabel.keyWord = @"元";
    self.zhongjiangLabel.keyWordColor = [UIColor grayColor];
    self.timeLabel.text = [scheme.createTime substringWithRange:NSMakeRange(0,10)];
    NSString *nickStr = [scheme.tel stringByReplacingCharactersInRange:NSMakeRange(3, 4) withString:@"****"];
    self.memberName.text = scheme.memberName ? scheme.memberName : nickStr;
}

// 计算label的长度
- (CGFloat)getLeftConstant:(UILabel *)label{
    CGSize titleSize = [label.text sizeWithAttributes:[NSDictionary dictionaryWithObjectsAndKeys:[UIFont systemFontOfSize:18],NSFontAttributeName, nil]];
    return titleSize.width;
}



- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
    
    // Configure the view for the selected state
}
@end
