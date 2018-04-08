//
//  JCLQDXFCell.h
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "BaseCell.h"

@interface JCLQDXFCell : BaseCell

@property (weak, nonatomic) IBOutlet UILabel *labDXFGameName;
@property (weak, nonatomic) IBOutlet UILabel *labDXFGameDay;
@property (weak, nonatomic) IBOutlet UILabel *labDXFGameTime;
@property (weak, nonatomic) IBOutlet UILabel *labDXFHomeAndGoust;
@property (weak, nonatomic) IBOutlet UIButton *btnDXFDY;
@property (weak, nonatomic) IBOutlet UIButton *btnDXFXY;
@property (weak, nonatomic) IBOutlet UIImageView *imgDanguan;
@end
