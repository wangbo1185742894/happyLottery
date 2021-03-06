//
//  JCLQOrderDetailViewCell.h
//  Lottery
//
//  Created by 王博 on 16/10/13.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "JCLQSchemeModel.h"

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
@property (weak, nonatomic) IBOutlet UIButton *btnLeshanCode;
@property (weak, nonatomic) IBOutlet UILabel *labelTouTitle;


-(void)reloadData:(NSDictionary *)dic openResult:(NSMutableArray *)array;

-(void)reloadDataGYJ:(NSDictionary *)dic;

- (void)reloadDataFollowInit:(NSDictionary *)dic openResult:(NSMutableArray *)array;


-(CGFloat)getCellHeight:(NSDictionary*)dic;
@end
