//
//  LotteryAreaViewCell.m
//  happyLottery
//
//  Created by LYJ on 2018/4/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LotteryAreaViewCell.h"

@implementation LotteryAreaViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    self.lotteryImageView.clipsToBounds = NO;
    self.lotteryImageView.contentMode = UIViewContentModeScaleAspectFit;
}

//-(id)initWithFrame:(CGRect)frame{
//    if(self = [super initWithFrame:frame]){
//        NSArray *array = [[NSBundle mainBundle] loadNibNamed:@"LotteryAreaViewCell" owner:self options:nil];
//        if(array.count < 1)
//            return nil;
//        if(![[array firstObject] isKindOfClass:[UICollectionViewCell class]])
//            return nil;
//        self = [array firstObject];
//    }
//    return self;
//}


@end
