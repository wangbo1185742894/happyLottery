//
//  OmitEnquiresTableViewCell.m
//  Lottery
//
//  Created by only on 16/11/9.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "OmitEnquiresTableViewCell.h"

@implementation OmitEnquiresTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    self.numberButton.layer.borderColor = [UIColor lightGrayColor].CGColor;
    self.numberButton.layer.borderWidth = 0.7;
}
+ (instancetype)cellWithTableView:(UITableView *)tableView
{
    static NSString *CellID = @"OmitEnquiresTableViewCell";
    OmitEnquiresTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellID];
    if (!cell)
    {
        cell = [[[NSBundle mainBundle]loadNibNamed:CellID owner:nil options:nil] lastObject];
        
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

- (void)setCellValueFromModel:(QmitModel *)model andIndexPath:(NSIndexPath *)indexPath
{
    //numberLabel;
//    avgNumbsLabel;//平均遗漏
//    preOutProbLabel;//欲出几
//    curDayOutLabel;//本日已出
//    daysNoOutLabel;
    
    self.timesLabel.adjustsFontSizeToFitWidth =  YES;
    self.avgNumbsLabel.adjustsFontSizeToFitWidth = YES;
    self.curDayOutLabel.adjustsFontSizeToFitWidth = YES;
    self.daysNoOutLabel.adjustsFontSizeToFitWidth = YES;
    self.preOutProbLabel.adjustsFontSizeToFitWidth = YES;

    self.model = model;
    self.numberButton.selected = [self.model.isSelect isEqualToString:@"1"]?YES:NO;
    [self.numberButton setTitle:[model.number stringByReplacingOccurrencesOfString:@"," withString:@" "] forState:UIControlStateNormal] ;
    self.numberButton.tag = 100000+indexPath.row;
    
    
    
    if ([self.sureString isEqualToString:model.number]) {
        [self.numberButton setTitleColor:TextOrangeColor forState:UIControlStateNormal];
    }else {
        [self.numberButton setTitleColor:RGBCOLOR(72, 72, 72) forState:UIControlStateNormal];
    }
    self.avgNumbsLabel.text = model.avgNumbs;
    float times = [model.times floatValue];
    float avgNums = [model.avgNumbs floatValue];
    float endNumber = times/avgNums;
    int t = 0;
    
    if (avgNums == 0) {
        t  = 0;
    }else{
        t = (int)(endNumber * 100);
    }
    
    self.preOutProbLabel.text = [NSString stringWithFormat:@"%d%%", t<0?0:t];
    self.curDayOutLabel.text = model.curDayOut;
    self.daysNoOutLabel.text = model.daysNoOut;
    self.timesLabel.text = model.times;
}
- (IBAction)leftNumberClicked:(id)sender {
    self.model.isSelect = [self.model.isSelect isEqualToString: @"0"]?@"1":@"0";
    [[NSNotificationCenter defaultCenter]postNotificationName:NSNotificationModelSelect object:nil];
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

@end
