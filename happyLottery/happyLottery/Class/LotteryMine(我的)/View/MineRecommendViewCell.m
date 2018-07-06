//
//  MineRecommendViewCell.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "MineRecommendViewCell.h"

#import "MineCollectionViewCell.h"
#define  KMineCollectionViewCell @"MineCollectionViewCell"


@interface MineRecommendViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>


@property(assign,nonatomic)NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UIView *borderView;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewItem;

@end
@implementation MineRecommendViewCell{
    NSArray *listArray;
}

- (void)awakeFromNib {
    [super awakeFromNib];
}

- (void)reloadDate:(NSArray *)groupArray{
    listArray = [groupArray copy];
    self.borderView.layer.masksToBounds = YES;
    self.borderView.layer.cornerRadius = 12;
    self.collectionViewItem.dataSource = self;
    self.collectionViewItem.delegate = self;
    [self.collectionViewItem registerNib:[UINib nibWithNibName:KMineCollectionViewCell bundle:nil] forCellWithReuseIdentifier:KMineCollectionViewCell];
    [self.collectionViewItem reloadData];
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}
- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    
    return listArray.count;
    
}


-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    MineCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:KMineCollectionViewCell forIndexPath:indexPath];
    NSDictionary *optionDic;
    optionDic = listArray[indexPath.row];
    cell.labRedPoint.hidden = NO;
    cell.imgItemIcon.hidden = NO;
    cell.labItemTitle.hidden = NO;
    cell.labRedPoint.adjustsFontSizeToFitWidth = YES;
    cell.imgItemIcon.image = [UIImage imageNamed:[NSString stringWithFormat:@"%@_mine",optionDic[@"icon"]]];
    if (self.listUseRedPacketArray.count>0 && [optionDic[@"title"] isEqualToString:@"我的红包"]) {
        cell.labRedPoint.hidden=  !self.login;
    }else  if (self.rednum>0 && [optionDic[@"title"] isEqualToString:@"意见反馈"]) {
        cell.labRedPoint.hidden= !self.login;
    }else{
        cell.labRedPoint.hidden= YES;
    }
    cell.labItemTitle.text = optionDic[@"title"];
    return cell;
}


-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    if (listArray.count<4) {
        return CGSizeMake(self.collectionViewItem.mj_w / listArray.count, 80);
    }
    if (listArray.count == 4) {
        return CGSizeMake(self.collectionViewItem.mj_w /4, 80);
    }
    return CGSizeMake(self.collectionViewItem.mj_w /4, 90);
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    NSDictionary *dic = listArray[indexPath.row];
    [self.delegate recommendViewCellClick:dic];
}

@end
