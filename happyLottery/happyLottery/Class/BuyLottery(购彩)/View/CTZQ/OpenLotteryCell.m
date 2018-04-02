//
//  OpenLotteryCell.m
//  Lottery
//
//  Created by 王博 on 16/3/28.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "OpenLotteryCell.h"

@implementation OpenLotteryCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{

    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"OpenLotteryCell" owner:nil options:nil] lastObject];
        
    }
    return self;

}

@end
