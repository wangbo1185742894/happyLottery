//
//  CashAndIntegrationWaterTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2017/12/26.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentTransferModel.h"

@interface CashAndIntegrationWaterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labDidTop;
@property (weak, nonatomic) IBOutlet UILabel *retainLab;
-(void)loadData:(AgentTransferModel *)model;
@end
