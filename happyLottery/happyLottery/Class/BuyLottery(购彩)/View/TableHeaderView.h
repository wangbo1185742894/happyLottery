//
//  TableHeaderView.h
//  Lottery
//
//  Created by 王博 on 16/8/22.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TableHeaderView : UIView
@property (weak, nonatomic) IBOutlet UIButton *btnActionClick;

@property (weak, nonatomic) IBOutlet UIImageView *imgDir;
@property (weak, nonatomic) IBOutlet UILabel *labTime;
@property (weak, nonatomic) IBOutlet UILabel *labMatchInfo;

@end
