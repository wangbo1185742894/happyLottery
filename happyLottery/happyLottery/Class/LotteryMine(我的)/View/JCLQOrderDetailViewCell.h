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
@property (weak, nonatomic) IBOutlet UILabel *labBetCount;
@property (weak, nonatomic) IBOutlet UILabel *labBeishu;
@property (weak, nonatomic) IBOutlet UILabel *labChupiao;
@property (weak, nonatomic) IBOutlet UILabel *labJiangjin;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *lbaTitlewidth;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *labPlayTypeWidth;
@property (weak, nonatomic) IBOutlet UILabel *labPlayType;
@property (weak, nonatomic) IBOutlet UILabel *labRemark;

@property(assign,nonatomic)BOOL isX115;
@property(assign,nonatomic)BOOL isP3P5;
-(void)reloadData:(NSDictionary *)dic;

-(CGFloat)getCellHeight:(NSDictionary*)dic;
@end
