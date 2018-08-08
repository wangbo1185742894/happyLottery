//
//  SchemeDetailViewCell.h
//  happyLottery
//
//  Created by 王博 on 2018/1/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCZQSchemeModel.h"

@protocol SchemeDetailViewDelegate

- (void)showAlert;

@end

@interface SchemeDetailViewCell : UITableViewCell
-(void)reloadDataModel:(JCZQSchemeItem*)model;

@property (nonatomic, weak) id<SchemeDetailViewDelegate> delegate;

@end
