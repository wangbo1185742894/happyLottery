//
//  SchemeInfoBuyCell.h
//  happyLottery
//
//  Created by LYJ on 2018/5/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"

@protocol BuyCellDelegate

- (void)showAlertFromBuy;

@end

@interface SchemeInfoBuyCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *loterryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *lotteryImage;

@property (weak, nonatomic) IBOutlet UILabel *labBetBouns;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *winImage;

@property (weak, nonatomic) IBOutlet UILabel *winLabel;

@property (weak, nonatomic) IBOutlet UILabel *yongJin;

@property (weak, nonatomic) IBOutlet UILabel *winMoney;

@property (nonatomic, weak) id<BuyCellDelegate> delegate;

- (void)reloadDate:(JCZQSchemeItem * )model;

@end
