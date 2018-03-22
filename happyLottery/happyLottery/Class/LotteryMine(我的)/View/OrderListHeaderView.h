//
//  OrderListHeaderView.h
//  Lottery
//
//  Created by only on 16/1/27.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface OrderListHeaderView : UIView
@property (weak, nonatomic) IBOutlet UILabel *titleLa;
@property (weak, nonatomic) IBOutlet UILabel *betInfoLa;
@property (weak, nonatomic) IBOutlet UIView *viewPeiLvInfo;
@property (weak, nonatomic) IBOutlet UIButton *btnOrderDetail;
@property (weak, nonatomic) IBOutlet UILabel *labLine;
@property (weak, nonatomic) IBOutlet UILabel *labSpinfo;
@property (weak, nonatomic) IBOutlet UIButton *labOrderDetail;

@end
