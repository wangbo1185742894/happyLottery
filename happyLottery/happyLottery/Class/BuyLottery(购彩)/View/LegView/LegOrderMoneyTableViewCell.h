//
//  LegOrderMoneyTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface LegOrderMoneyTableViewCell : UITableViewCell

- (void)loadNewDate:(JCZQSchemeItem *)detail andStatus:(NSString *)orderStatus;

@end

NS_ASSUME_NONNULL_END
