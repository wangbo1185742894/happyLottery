//
//  ZHDetailViewController.h
//  Lottery
//
//  Created by 关阿龙 on 15/10/14.
//  Copyright © 2015年 AMP. All rights reserved.
//

#import "BaseViewController.h"
#import "OrderProfile.h"
#import "OrderBetsListView.h"


@protocol ZHDetailViewControllerDelegate <NSObject>

@end

@interface ZHDetailViewController : BaseViewController
//@property (weak, nonatomic) IBOutlet UIView *numberBackground;
@property (weak, nonatomic) IBOutlet UIView *numberBackground;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberContentHight;

@property (nonatomic , strong) OrderProfile * order;
@property (nonatomic , weak) id<ZHDetailViewControllerDelegate>delegate;
@end
