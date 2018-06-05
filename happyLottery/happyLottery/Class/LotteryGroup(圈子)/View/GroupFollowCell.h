//
//  GroupFollowCell.h
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol GroupFollowDelegate

- (void)groupFollowScheme;

@end

@interface GroupFollowCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *followCountLab;

@property (weak, nonatomic) IBOutlet UIButton *gendanBtn;

@property (weak, nonatomic) IBOutlet UIView *cornorView;

@property (weak, nonatomic) id<GroupFollowDelegate> delegate;

- (void)reloadDate:(NSString *)followCount;

@end
