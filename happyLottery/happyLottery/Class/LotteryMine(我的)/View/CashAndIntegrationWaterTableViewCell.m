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
    // Initialization code
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

-(void)loadData:(AgentTransferModel *)model{
    self.retainLab.textColor = RGBCOLOR(200, 200, 200);
    self.labDidTop.constant = 15;
    self.retainLab.text = model.createTime;
    if ([model.transferCost doubleValue] > 0) {
        self.nameLab.text = @"转账退款";
        self.image.image = [UIImage imageNamed:@"increase"];
 
        self.priceLab.textColor = SystemGreen;
        self.priceLab.text = [NSString stringWithFormat:@"+%.2f元",[model.transferCost doubleValue]];
    }else{
        self.nameLab.text = @"转账至余额";
        self.image.image = [UIImage imageNamed:@"decrease"];
        self.priceLab.textColor = [UIColor blackColor];
        self.priceLab.text = [NSString stringWithFormat:@"-%.2f元",[model.transferCost doubleValue]];
    }
    
}

@end
