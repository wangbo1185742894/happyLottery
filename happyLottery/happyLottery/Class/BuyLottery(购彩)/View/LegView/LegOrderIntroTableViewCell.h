//
//  LegOrderIntroTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/11/1.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LegOrderIntroTableViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *orderInfoLab;
@property (weak, nonatomic) IBOutlet UILabel *orderTimeLab;

@property (weak, nonatomic) IBOutlet UILabel *labTiao;

- (void)reloadDate:(NSDictionary *)dic;

@end

NS_ASSUME_NONNULL_END
