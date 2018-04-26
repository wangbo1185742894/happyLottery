//
//  LotteryAreaViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/4/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LotteryAreaViewController.h"
#import "LotteryAreaViewCell.h"
#import "GYJPlayViewController.h"
#import "JCZQPlayViewController.h"
#import "JCLQPlayController.h"
#import "DLTPlayViewController.h"
#import "SSQPlayViewController.h"
#import "CTZQPlayViewController.h"

#define rowNumber 3 //每行显示三个cell

@interface LotteryAreaViewController ()
{
    NSArray *_lotteryArr; //彩种详细
    MBProgressHUD *loadingView;
}

@end

@implementation LotteryAreaViewController

static NSString * const reuseIdentifier = @"LotteryAreaViewCell";

- (void)viewDidLoad {
    [super viewDidLoad];
    UINib *nib = [UINib nibWithNibName:@"LotteryAreaViewCell" bundle:nil];
    [self.collectionView registerNib:nib forCellWithReuseIdentifier:
     reuseIdentifier];
    self.collectionView.backgroundColor = [UIColor whiteColor];
    //加载数据
    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"LotteryArea" ofType:@"plist"];
    _lotteryArr = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
    [self setNavigationBack];
}

-(void)setNavigationBack{
    
    UIBarButtonItem *backBarButton = [[UIBarButtonItem alloc] initWithImage:[[UIImage imageNamed: @"newBack"]imageWithRenderingMode:UIImageRenderingModeAlwaysOriginal] style:UIBarButtonItemStylePlain target:self action:@selector(navigationBackToLastPage)];
    if (self.navigationController.viewControllers.count == 1) {
    }else{
        self.navigationItem.leftBarButtonItem = backBarButton;
    }
    
}

-(void)navigationBackToLastPage{
    
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


-(id)init{
    UICollectionViewFlowLayout *layout=[[UICollectionViewFlowLayout alloc]init];
    if (self=[super initWithCollectionViewLayout:layout]) {
    }
    return self;
}

//查找数组下标
- (NSInteger)arryIndex:(NSIndexPath *)indexpath {
    NSInteger index;
    if(indexpath.section == 0){
        index = indexpath.row;
    }
    else {
        index = indexpath.section*rowNumber + indexpath.row;
    }
    return index;
}

#pragma mark <UICollectionViewDataSource>

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView {
    if (_lotteryArr.count%rowNumber) {
        return _lotteryArr.count/rowNumber +1;
    } else {
        return _lotteryArr.count/rowNumber;
    }
    
}


- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section < _lotteryArr.count/rowNumber) {
        return rowNumber;
    }
    else {
        return _lotteryArr.count%rowNumber;
    }
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    LotteryAreaViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
    NSInteger index = [self arryIndex:indexPath];
    NSDictionary *lottery = (NSDictionary *)_lotteryArr[index];
    // Configure the cell
    [cell.lotteryImageView setImage:[UIImage imageNamed:[lottery objectForKey:@"lotteryImageName"]]];
    cell.lotteryName.text = [lottery objectForKey:@"lotteryName"];
    cell.lotteryIntroduce.text = [lottery objectForKey:@"lotteryInfo"];
    return cell;
}

#pragma mark <UICollectionViewDelegate>
-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)/rowNumber,115);
    
//    return CGSizeMake(125, 115);
}

//这个是两行cell之间的间距（上下行cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}

//两个cell之间的间距（同一行的cell的间距）
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
    return 0;
}


// Uncomment this method to specify if the specified item should be selected
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    return YES;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    LotteryAreaViewCell *cell = (LotteryAreaViewCell *)[collectionView cellForItemAtIndexPath:indexPath];
    NSString *lotteryName = cell.lotteryName.text;
    if ([lotteryName isEqualToString:@"竞彩足球"]) {
        JCZQPlayViewController * playViewVC = [[JCZQPlayViewController alloc]init];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playViewVC animated:YES];
    }
    else if ([lotteryName isEqualToString:@"胜负彩"]){
        CTZQPlayViewController *playVC = [[CTZQPlayViewController alloc] init];
        playVC.playType = CTZQPlayTypeRenjiu;
        playVC.hidesBottomBarWhenPushed = YES;
        playVC.lottery = self.lotteryDS[7];
        [self.navigationController pushViewController:playVC animated:YES];
    }
    else if ([lotteryName isEqualToString:@"竞彩篮球"]){
        JCLQPlayController * playViewVC = [[JCLQPlayController alloc]init];
        playViewVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:playViewVC animated:YES];
    }
    else if ([lotteryName isEqualToString:@"大乐透"]){
        DLTPlayViewController *playVC = [[DLTPlayViewController alloc] init];
        playVC.hidesBottomBarWhenPushed = YES;
        playVC.lottery = self.lotteryDS[1];
        [self.navigationController pushViewController:playVC animated:YES];
        
    }
    else if ([lotteryName isEqualToString:@"双色球"]){
        SSQPlayViewController *playVC = [[SSQPlayViewController alloc] init];
        playVC.hidesBottomBarWhenPushed = YES;
        playVC.lottery = self.lotteryDS[10];
        [self.navigationController pushViewController:playVC animated:YES];
    }
    else if ([lotteryName isEqualToString:@"冠亚军"]){
        GYJPlayViewController *gyjPlayVc = [[GYJPlayViewController alloc]init];
        gyjPlayVc.hidesBottomBarWhenPushed = YES;
        gyjPlayVc.navigationController.navigationBar.hidden = YES;
        [self.navigationController pushViewController:gyjPlayVc animated:YES];
    }
    else {
        [self showPromptText:@"此彩种暂停销售" hideAfterDelay:1.0];
    }
}

- (void) showPromptText: (NSString *) text hideAfterDelay: (NSTimeInterval) interval {
    if (nil != loadingView) {
        [loadingView hide: YES];
    }
    loadingView = [[MBProgressHUD alloc] initWithView: self.view];
    [self.view addSubview: loadingView];
    loadingView.labelText = text;
    loadingView.labelFont = [UIFont systemFontOfSize:13];
    loadingView.userInteractionEnabled = NO;
    loadingView.mode = MBProgressHUDModeText;
    loadingView.yOffset = self.view.frame.size.height/2 - 160;
    [loadingView showAnimated:YES whileExecutingBlock:^{
        sleep(interval);
    } completionBlock:^{
        [loadingView removeFromSuperview];
        loadingView = nil;
    }];
}

@end
