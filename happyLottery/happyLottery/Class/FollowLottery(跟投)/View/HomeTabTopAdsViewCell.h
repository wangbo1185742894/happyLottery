//
//  TabTopAdsViewCell.h
//  appmall
//
//  Created by 王博 on 2018/4/23.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ADSModel.h"

@protocol HomeTabTopAdsViewDelegate <NSObject>

-(void)itemClickInTop:(ADSModel *)index;

@end

@interface HomeTabTopAdsViewCell : UITableViewCell

@property(nonatomic,weak)id <HomeTabTopAdsViewDelegate> delegate;

-(void)loadData:(NSArray *)model;

- (void)stopTimer;

- (void)openTimer;

@end
