//
//  BounsYouViewCell.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/27.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "SelectView.h"
#import "BounsYouHuaViewController.h"

@protocol BounsYouViewCellDelegate <NSObject>
-(void)actionUpdagte;
@end

@interface BounsYouViewCell : UITableViewCell

@property(nonatomic,weak)id <BounsYouViewCellDelegate> delegate;
@property (weak, nonatomic) IBOutlet SelectView *labBeiSelect;
@property (weak, nonatomic) IBOutlet UILabel *labBetContent;
@property (weak, nonatomic) IBOutlet UILabel *labBouns;


-(void)reloadModel:(BounsModelItem *)model;

@end
