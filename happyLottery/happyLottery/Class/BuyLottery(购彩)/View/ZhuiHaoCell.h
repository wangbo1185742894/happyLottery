//
//  ZhuiHaoCell.h
//  happyLottery
//
//  Created by LYJ on 2018/7/17.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ZhuiHaoCellDelegate

-(void)beishuChange:(NSString *)state sender:(id)sender;

@end

@interface ZhuiHaoCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *numLabel; //序号
@property (weak, nonatomic) IBOutlet UILabel *isslabel; //期号
@property (weak, nonatomic) IBOutlet UIButton *beidownBtn;
@property (weak, nonatomic) IBOutlet UITextField *beiShutf;
@property (weak, nonatomic) IBOutlet UIButton *beiUpBtn;
@property (weak, nonatomic) IBOutlet UILabel *expenselabel;
@property (weak, nonatomic) IBOutlet UILabel *profitlabel;
@property (weak, nonatomic) IBOutlet UILabel *ratelabel;
@property (nonatomic, weak) id<ZhuiHaoCellDelegate> delegate;


@end
