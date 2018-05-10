//
//  RecommendViewCell.m
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import "RecommendViewCell.h"
#define KMenuCollectionViewCell @"MenuCollectionViewCell"

@interface RecommendViewCell()<UICollectionViewDelegate,UICollectionViewDataSource,UICollectionViewDelegateFlowLayout>
@property(assign,nonatomic)NSInteger selectIndex;
@property (weak, nonatomic) IBOutlet UICollectionView *collectionViewItem;
@property(nonatomic,strong)NSArray *topList;
@property(nonatomic,strong)NSArray *eightList;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topMarginViewHeight;
@property(strong,nonatomic)id  model;

@end
@implementation RecommendViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
}

-(UICollectionViewFlowLayout *)getLayoutMenu{
    UICollectionViewFlowLayout *customLayout = [[UICollectionViewFlowLayout alloc] init]; // 自定义的布局对象
    customLayout.minimumLineSpacing = 0;
    customLayout.minimumInteritemSpacing = 0;
    customLayout.itemSize = CGSizeMake(KscreenWidth /4 , 85) ;
    return customLayout;
}
-(void)setCollection:(NSInteger )index andData:(NSArray * )model{
    self.selectIndex = index;
    if (index == 0) {
        self.topList = model;
    }else if (index == 2){
        self.eightList = model;
    }
    _collectionViewItem.backgroundColor = [UIColor whiteColor];
    _collectionViewItem.dataSource = self;
    _collectionViewItem.delegate = self;
    [_collectionViewItem registerNib:[UINib nibWithNibName:KMenuCollectionViewCell bundle:nil] forCellWithReuseIdentifier:KMenuCollectionViewCell];
    [_collectionViewItem setCollectionViewLayout:[self getLayoutMenu]];
    [_collectionViewItem reloadData];
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
//
    if (self.selectIndex == 0) {
        return 4;
    }else    if (self.selectIndex ==2) {
        return self.eightList.count;
    }
    return 1;
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCollectionViewCell* cell= [collectionView dequeueReusableCellWithReuseIdentifier:KMenuCollectionViewCell forIndexPath:indexPath];
    if (self.selectIndex == 0) {
        
        cell.index = indexPath.row;
        [cell setItemIcom:_topList[indexPath.row]];
    }else{
        cell.index = -1;
        [cell setEightItemIcom:_eightList[indexPath.row]];
    }
    cell.delegate = self.delegate;
    return cell;
}

-(void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    [self.delegate recommendViewCellClick:indexPath andTabIndex:self.selectIndex];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}


@end
