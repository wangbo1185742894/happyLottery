//
//  LegOrderMoneyTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"
#import "OrderProfile.h"

NS_ASSUME_NONNULL_BEGIN

@protocol OrderDetailDelegate

- (void)showOrderDetail;

@end



@interface LegOrderMoneyTableViewCell : UITableViewCell

@property (nonatomic, weak) id<OrderDetailDelegate> delegate;

- (void)loadNewDate:(JCZQSchemeItem *)detail andStatus:(NSString *)orderStatus;

- (void)loadZhuiHaoNewDate:(OrderProfile *)detail andStatus:(NSString *)orderStatus andName:(NSString *)name andWon:(BOOL)won;

@end

NS_ASSUME_NONNULL_END
