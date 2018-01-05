
//
//  PayTypeListCell.m
//  happyLottery
//
//  Created by 王博 on 2017/12/26.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "PayTypeListCell.h"

@interface PayTypeListCell ()

@end

@implementation PayTypeListCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ([super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"PayTypeListCell" owner:nil options:nil] lastObject];
    }
    return self;
}



@end
