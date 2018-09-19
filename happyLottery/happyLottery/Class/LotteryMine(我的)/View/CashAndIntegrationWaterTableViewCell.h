//
//  CashAndIntegrationWaterTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2017/12/26.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "AgentTransferModel.h"
#import "MGLabel.h"
#import "UserInfoBaseModel.h"

@interface CashAndIntegrationWaterTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lab1DisTop;
@property (weak, nonatomic) IBOutlet UIImageView *imgIcon;
@property (weak, nonatomic) IBOutlet UILabel *labRemark;
@property (weak, nonatomic) IBOutlet UIImageView *image;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgWidth;
@property (weak, nonatomic) IBOutlet MGLabel *nameLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imgDisLeft;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UIButton *btnZhuangZhangState;
@property (weak, nonatomic) IBOutlet MGLabel *priceLab;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labDidTop;
@property (weak, nonatomic) IBOutlet MGLabel *retainLab;
-(void)loadData:(AgentTransferModel *)model;
-(void)loadUserInfo:(UserInfoBaseModel *)userInfo;
@end
