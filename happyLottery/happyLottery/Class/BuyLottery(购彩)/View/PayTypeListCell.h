//
//  PayTypeListCell.h
//  happyLottery
//
//  Created by 王博 on 2017/12/26.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ChannelModel.h"

@interface PayTypeListCell : UITableViewCell
-(void)loadDataWithModel:(ChannelModel *)model;
-(void)chongzhiLoadDataWithModel:(ChannelModel *)model;
@end
