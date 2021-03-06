//
//  ApplyInputCell.h
//  happyLottery
//
//  Created by LYJ on 2018/6/2.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ApplyInputCellDelegate <NSObject>

- (void)applayAgent:(NSString *)realName telephone:(NSString *)telephone agree:(BOOL)agree;

- (void)goToGroupInform;

@end


@interface ApplyInputCell: UITableViewCell

@property(weak,nonatomic)id <ApplyInputCellDelegate>delegate;

@property (weak, nonatomic) IBOutlet UITextField *realName;

@property (weak, nonatomic) IBOutlet UITextField *telephoneNum;
@property (weak, nonatomic) IBOutlet UIButton *agreeBtn;
@property (weak, nonatomic) IBOutlet UIButton *commitBtn;

@end
