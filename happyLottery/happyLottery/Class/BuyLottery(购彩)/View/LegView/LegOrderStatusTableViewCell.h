//
//  LegOrderStatusTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LegOrderStatusTableViewCell : UITableViewCell

- (void)loadNewDate:(NSString *)orderStatus;

- (void)loadZhuiHaoNewDate:(NSString *)orderStatus andWon:(BOOL)won;

@end

NS_ASSUME_NONNULL_END
