//
//  YuCeSchemeCreateCell.h
//  Lottery
//
//  Created by onlymac on 2017/10/13.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "YuCeScheme.h"
@protocol YuCeSchemeCreateCellDelegate <NSObject>
- (void)touzhuAction:(YuCeScheme *)scheme;
@end

@interface YuCeSchemeCreateCell : UITableViewCell
@property (nonatomic, copy) NSString *monery;
@property (nonatomic, assign) id <YuCeSchemeCreateCellDelegate> delegate;
@property (nonatomic, strong) YuCeScheme *scheme;
+ (instancetype)cellWithTableView:(UITableView *)tableView;
-(void)refreshData:(NSDictionary *)scheme xuQiuBtn:(NSString *)string;
@end
