//
//  LegOrderStatueWaitTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/11/7.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@protocol LegOrderStatueWaitDelegate <NSObject>

- (void)actionToRecharge;

@end

@interface LegOrderStatueWaitTableViewCell :
UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *timeLab;

@property (nonatomic,strong)NSString *timeStr;

@property (weak, nonatomic) IBOutlet UIButton *continueBtn;

@property (weak, nonatomic) id<LegOrderStatueWaitDelegate>delegate;

@end

NS_ASSUME_NONNULL_END
