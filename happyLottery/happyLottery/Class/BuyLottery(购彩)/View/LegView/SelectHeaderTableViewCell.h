//
//  SelectHeaderTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/11/17.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface SelectHeaderTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *moneyLab;

- (void)reloadDateWithMoney:(double)money;

@end

NS_ASSUME_NONNULL_END
