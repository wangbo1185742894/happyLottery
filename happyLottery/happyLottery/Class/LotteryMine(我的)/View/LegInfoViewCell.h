//
//  LegInfoViewCell.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/10/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface LegInfoViewCell : UITableViewCell
-(void)LoadData:(NSString *)legName legMobile:(NSString *)mobile legWechat:(NSString *)wechat;
@end

NS_ASSUME_NONNULL_END
