//
//  JCLQSchemeViewCell.h
//  Lottery
//
//  Created by 王博 on 17/4/25.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "BaseSchemeViewCell.h"
@interface GYJSchemeViewCell :BaseSchemeViewCell

@property (weak, nonatomic) IBOutlet UIView *betcontentView;
@property (weak, nonatomic) IBOutlet UILabel *labZhuBei;
@property (weak, nonatomic) IBOutlet UIButton *btnToOrderDetail;
@property (weak, nonatomic) IBOutlet UILabel *labBaoMi;
@property (weak, nonatomic) IBOutlet UILabel *guoguanlab;

@end
