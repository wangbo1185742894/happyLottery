//
//  CunLegTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2018/10/31.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "LegWordModel.h"

NS_ASSUME_NONNULL_BEGIN

@interface CunLegTableViewCell : UITableViewCell


/**
 获取小哥cell详细信息

 @param legModel LegWordModel
 */
- (void)loadLegDate:(LegWordModel *)legModel;

@end

NS_ASSUME_NONNULL_END
