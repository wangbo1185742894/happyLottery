//
//  JCLQOrderDetailViewCell.h
//  Lottery
//
//  Created by 王博 on 16/10/13.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface JCLQOrderDetailViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *labNumber;
@property (weak, nonatomic) IBOutlet UILabel *labTouzhuneirong;
@property (weak, nonatomic) IBOutlet UILabel *labBetCost;
@property (weak, nonatomic) IBOutlet UILabel *labChupiao;
@property (weak, nonatomic) IBOutlet UILabel *labJiangjin;
@property (weak, nonatomic) IBOutlet UILabel *labPassType;
@property (weak, nonatomic) IBOutlet UIView *viewSubContent;
@property (weak, nonatomic) IBOutlet UIImageView *imgWinIcon;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disLeftPlayType;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *disLeftPlayTypeContent;
@property (weak, nonatomic) IBOutlet UILabel *labPlayType;


-(void)reloadData:(NSDictionary *)dic;

-(void)reloadDataGYJ:(NSDictionary *)dic;

-(CGFloat)getCellHeight:(NSDictionary*)dic;
@end
