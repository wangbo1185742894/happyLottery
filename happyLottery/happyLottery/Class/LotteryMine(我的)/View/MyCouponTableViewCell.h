//
//  MyCouponTableViewCell.h
//  happyLottery
//
//  Created by LYJ on 2017/12/28.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "Coupon.h"

@interface MyCouponTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UILabel *priceLab;
@property (weak, nonatomic) IBOutlet UILabel *sourceLab;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UILabel *dateLab;
@property (weak, nonatomic) IBOutlet UILabel *descriptionLab;
@property (weak, nonatomic) IBOutlet UIButton *btnSelect;
@property (weak, nonatomic) IBOutlet UIImageView *endImage;
@property (weak, nonatomic) IBOutlet UILabel *yuanLab;
@property (weak, nonatomic) IBOutlet UIImageView *bjImage;



-(void)loadData:(Coupon *)model;

@end
