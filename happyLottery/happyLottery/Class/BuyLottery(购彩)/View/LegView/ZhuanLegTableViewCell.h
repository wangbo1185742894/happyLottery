//
//  ZhuanLegTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/10/31.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PostboyAccountModel.h"

NS_ASSUME_NONNULL_BEGIN

@protocol ZhuanLegDelegate <NSObject>

- (void)actionToWeiXin:(NSString *)weiXin;

- (void)actionToTelephone:(NSString *)telephone;

@end

@interface ZhuanLegTableViewCell : UITableViewCell

@property (nonatomic , weak)id<ZhuanLegDelegate>delegate;
/**
 获取小哥cell详细信息

 @param legModel LegWordModel
 */
- (void)loadLegDate:(PostboyAccountModel *)legModel;

@end

NS_ASSUME_NONNULL_END
