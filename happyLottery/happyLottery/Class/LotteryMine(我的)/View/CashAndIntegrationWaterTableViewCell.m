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
  
    
    
    
    _btnZhuangZhangState.layer.cornerRadius = _btnZhuangZhangState.mj_h/ 2;
    _btnZhuangZhangState.layer.masksToBounds = YES;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadUserInfo:(UserInfoBaseModel *)userInfo{
    self.imgWidth.constant = 0;
    self.imgDisLeft.constant = 0;
    if ([userInfo isKindOfClass:[MemberRedPacketOrderModel class]]) {
        MemberRedPacketOrderModel *model =(MemberRedPacketOrderModel *) userInfo;
        //FOLLOW_INITIATE("送出发单红包"),
        //
        //FOLLOW_FOLLOW("收到跟单红包"),
        //
        //CIRCLE_GIVEN("送出圈子红包"),
        //
        //CIRCLE_RECEIVE("收到圈子红包");
        if ([model.orderType isEqualToString:@"FOLLOW_INITIATE"] || [model.orderType isEqualToString:@"CIRCLE_GIVEN"]) {
            self.imgIcon.image = [UIImage imageNamed:@"zhichured.png"];
        }else{
             self.imgIcon.image = [UIImage imageNamed:@"shourured.png"];
        }
    }
    self.nameLab.text = [userInfo get1Name];
    self.nameLab.keyWord = @"(驳回)";
    if ([[userInfo get1Name] isEqualToString:@"提现(驳回)"]) {
        self.priceLab.textColor =SystemRed;
    }else{
        self.priceLab.textColor = RGBCOLOR(37,186,96);
    }
    self.nameLab.keyWordColor = SystemRed;
    self.nameLab.font = [UIFont boldSystemFontOfSize:15];
    
    if ([userInfo get3Name ].length == 0) {
        self.lab1DisTop.constant  =20;
    }else{
        self.lab1DisTop.constant  =0;
    }
    self.priceLab.font = [UIFont systemFontOfSize:16];
    
//    self.priceLab.keyWordFont = [UIFont systemFontOfSize:12];
    self.priceLab.keyWord = @"元";
    
    
self.priceLab.text = [userInfo get2Name];
    
    self.retainLab.text = [userInfo get3Name];
    self.dateLab.text = [userInfo get4Name];
    self.labRemark.text = [userInfo getRemark];
    
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
        [_btnZhuangZhangState setTitleColor:SystemGreen forState:0];
        [_btnZhuangZhangState setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(220, 220, 220)] forState:0];
    }else if ([model.applyStatus isEqualToString:@"AUDITED"]){
        _btnZhuangZhangState.selected = YES;
        [_btnZhuangZhangState setTitle:@"转账成功" forState:UIControlStateSelected];
        [_btnZhuangZhangState setTitleColor:[UIColor whiteColor] forState:0];
        [_btnZhuangZhangState setBackgroundImage:[UIImage imageWithColor:TEXTGRAYOrange] forState:0];
    }else{
        _btnZhuangZhangState.selected = NO;
        [_btnZhuangZhangState setTitle:@"转账驳回" forState:0];
        [_btnZhuangZhangState setTitleColor:SystemGreen forState:0];
        [_btnZhuangZhangState setBackgroundImage:[UIImage imageWithColor:RGBCOLOR(220, 220, 220)] forState:0];
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
