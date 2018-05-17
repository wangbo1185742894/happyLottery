//
//  SchemeInfoFollowCell.h
//  happyLottery
//
//  Created by LYJ on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"

@interface SchemeInfoFollowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *loterryLabel;

@property (weak, nonatomic) IBOutlet UIImageView *lotteryImage;

@property (weak, nonatomic) IBOutlet UILabel *labBetBouns;

@property (weak, nonatomic) IBOutlet UILabel *moneyLabel;

@property (weak, nonatomic) IBOutlet UIImageView *winImage;

@property (weak, nonatomic) IBOutlet UILabel *winLabel;
@property (weak, nonatomic) IBOutlet UILabel *zongShouruLabel;
@property (weak, nonatomic) IBOutlet UIButton *shuoMingBtn;

- (void)reloadDate:(JCZQSchemeItem * )model;
@end
