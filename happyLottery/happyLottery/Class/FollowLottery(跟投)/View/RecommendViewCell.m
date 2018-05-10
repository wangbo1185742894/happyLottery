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
    
    if (index == 0) {
        self.topList = model;
        self.selectIndex = index;
    }else if (index == 2){
        self.eightList = model;
        self.selectIndex = -1;
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
        return 8;
    }
    return 1;
}

-(NSInteger )getArrayCount:(NSArray *)itemArray{
    if(itemArray  == nil || itemArray.count == 0){
        return 1;
    }else{
        return itemArray.count;
    }
}


- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    MenuCollectionViewCell* cell= [collectionView dequeueReusableCellWithReuseIdentifier:KMenuCollectionViewCell forIndexPath:indexPath];
    if (self.selectIndex == 0) {
        [cell setItemIcom:_topList[indexPath.row]];
    }else{
        cell.index = indexPath.row;
        [cell setEightItemIcom:_eightList[0]];
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
- (IBAction)actionMore:(id)sender {
    [self.delegate recommendViewCellDelegateMore:self.selectIndex];
}

@end
