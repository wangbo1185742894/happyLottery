//
//  WBHomeYuceListCell.h
//  Lottery
//
//  Created by 王博 on 2017/10/18.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "HomeYCModel.h"



@protocol WBHomeYuceListCellDelegate <NSObject>

-(void)homeYuceListTouzhu:(HomeYCModel *)model;

@end

@interface WBHomeYuceListCell : UITableViewCell

@property(nonatomic,weak)id< WBHomeYuceListCellDelegate> delegate;
-(void)refreshCellWithModel:(HomeYCModel *)model isZuiXin:(BOOL )isZuixin;
@end
