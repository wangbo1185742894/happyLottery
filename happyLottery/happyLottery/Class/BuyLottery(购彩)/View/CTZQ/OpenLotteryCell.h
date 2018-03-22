//
//  OpenLotteryCell.h
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OpenLotteryCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labPrizeRank;
@property (weak, nonatomic) IBOutlet UILabel *labPrizeCount;
@property (weak, nonatomic) IBOutlet UILabel *labPrizeEachTotal;

@end
