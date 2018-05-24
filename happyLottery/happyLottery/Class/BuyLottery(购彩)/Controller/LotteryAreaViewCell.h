//
//  LotteryAreaViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/4/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface LotteryAreaViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UILabel *isEable;

@property (weak, nonatomic) IBOutlet UIImageView *lotteryImageView;

@property (weak, nonatomic) IBOutlet UILabel *lotteryName;

@property (weak, nonatomic) IBOutlet UILabel *lotteryIntroduce;

@end
