//
//  CashAndIntegrationWaterTableViewCell.m
//  happyLottery
//
//  Created by LYJ on 2017/12/26.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "CashAndIntegrationWaterTableViewCell.h"

@implementation CashAndIntegrationWaterTableViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    _btnZhuangZhangState.hidden = YES;
    [_btnZhuangZhangState setTitleColor:SystemGreen forState:0];
    [_btnZhuangZhangState setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(220, 220, 220)] forState:0];
    
    [_btnZhuangZhangState setTitleColor:[UIColor whiteColor] forState:0];
    [_btnZhuangZhangState setBackgroundImage:[UIImage imageWithColor:TEXTGRAYOrange] forState:0];
    
    _btnZhuangZhangState.layer.cornerRadius = _btnZhuangZhangState.mj_h/ 2;
    _btnZhuangZhangState.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadData:(AgentTransferModel *)model{
    _btnZhuangZhangState.hidden = NO;
    self.retainLab.textColor = RGBCOLOR(200, 200, 200);
    self.labDidTop.constant = 15;
    self.retainLab.text = model.createTime;
    self.imgWidth.constant = 0;
    self.imgDisLeft.constant = 0;
//    /**     * 待审核     */
//    AUDITING,
//    /**     * 审批通过     */
//    AUDITED,
//    /**     * 审批驳回     */
//    AUDIT_REJECT
    
    if ([model.applyStatus isEqualToString:@"AUDITING"]) {
        _btnZhuangZhangState.selected = NO;
        [_btnZhuangZhangState setTitle:@"审核中" forState:0];
    }else if ([model.applyStatus isEqualToString:@"AUDITED"]){
        _btnZhuangZhangState.selected = YES;
        [_btnZhuangZhangState setTitle:@"转账成功" forState:UIControlStateSelected];
    }else{
        _btnZhuangZhangState.selected = NO;
        [_btnZhuangZhangState setTitle:@"转账驳回" forState:0];
    }
    
    if ([model.transferCost doubleValue] < 0) {
        self.nameLab.text = @"转账退款";
        self.image.image = [UIImage imageNamed:@"increase"];
 
        self.priceLab.textColor = [UIColor blackColor];
        self.priceLab.text = [NSString stringWithFormat:@"%.2f元",[model.transferCost doubleValue]];
    }else{
        self.nameLab.text = @"转账至余额";
        self.image.image = [UIImage imageNamed:@"decrease"];
        self.priceLab.textColor = [UIColor blackColor];
        self.priceLab.text = [NSString stringWithFormat:@"%.2f元",[model.transferCost doubleValue]];
    }
    
}

@end
