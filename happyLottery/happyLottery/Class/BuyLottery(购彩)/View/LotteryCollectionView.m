//
//  LotteryCollectionView.m
//  happyLottery
//
//  Created by LYJ on 2018/5/23.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LotteryCollectionView.h"
#import "LotteryAreaViewCell.h"

static NSString *ID = @"LotteryAreaViewCell";

@interface LotteryCollectionView()<UICollectionViewDataSource,UICollectionViewDelegateFlowLayout,UICollectionViewDelegate>



@end

@implementation LotteryCollectionView{
    
    NSArray *_lotteryArr; //彩种详细
}

- (instancetype)initWithFrame:(CGRect)frame collectionViewLayout:(UICollectionViewLayout *)layout{
    self = [super initWithFrame:frame collectionViewLayout:layout];
    if (self) {
        self.dataSource = self;
        self.delegate = self;
        [self registerNib:[UINib nibWithNibName:@"LotteryAreaViewCell" bundle:nil] forCellWithReuseIdentifier:ID];
        self.backgroundColor =[UIColor blackColor];
    }
    return self;
}


/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

@end
