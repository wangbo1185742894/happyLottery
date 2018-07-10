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
#import "LotteryPlayViewController.h"
#import "DLTPlayViewController.h"
#import "SSQPlayViewController.h"
#import "CTZQPlayViewController.h"

#define rowNumber 3 //每行显示三个cell

@interface LotteryAreaViewController ()<LotterySelectViewObjcDelegate,UIWebViewDelegate>
{
    NSArray *_lotteryArr; //彩种详细
    MBProgressHUD *loadingView;
    __weak IBOutlet UIWebView *webView;
    UIWebView *lotterySelectView;
    JSContext *context;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;

@end

@implementation LotteryAreaViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    webView.scrollView.bounces = NO;
    if ([self isIphoneX]) {
        self.topDis.constant = 44;
    }else{
        self.topDis.constant = 20;
        if ([Utility isIOS11After]) {
            self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
        }
    }
//
    NSURL *url = [NSURL URLWithString:[NSString stringWithFormat:@"%@/app/award/listSellLottery",H5BaseAddress]];
    webView.delegate  =self;
    [webView loadRequest:[NSURLRequest requestWithURL:url]];
    
//    UINib *nib = [UINib nibWithNibName:@"LotteryAreaViewCell" bundle:nil];
//    [self.collectionView registerNib:nib forCellWithReuseIdentifier:
//     reuseIdentifier];
//    self.collectionView.backgroundColor = [UIColor whiteColor];
//    //加载数据
//    NSString *plistPath = [[NSBundle mainBundle]pathForResource:@"LotteryArea" ofType:@"plist"];
//    _lotteryArr = [[NSMutableArray alloc] initWithContentsOfFile:plistPath];
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

- (void)webViewDidFinishLoad:(UIWebView *)webView
{
    context = [webView valueForKeyPath:@"documentView.webView.mainFrame.javaScriptContext"];
    context[@"appObj"] = self;
    context.exceptionHandler = ^(JSContext *context, JSValue *exceptionValue) {
        context.exception = exceptionValue;
    };
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
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

-(void)goCathectic:(NSString *)lotteryName{
    dispatch_async(dispatch_get_main_queue(), ^{
        if ([lotteryName isEqualToString:@"JCZQ"]) {
            JCZQPlayViewController * playViewVC = [[JCZQPlayViewController alloc]init];
            playViewVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:playViewVC animated:YES];
        }
        else if ([lotteryName isEqualToString:@"SFC"]){
            CTZQPlayViewController *playVC = [[CTZQPlayViewController alloc] init];
            playVC.playType = CTZQPlayTypeRenjiu;
            playVC.hidesBottomBarWhenPushed = YES;
            playVC.lottery = self.lotteryDS[7];
            [self.navigationController pushViewController:playVC animated:YES];
        }
        else if ([lotteryName isEqualToString:@"JCLQ"]){
            JCLQPlayController * playViewVC = [[JCLQPlayController alloc]init];
            playViewVC.hidesBottomBarWhenPushed = YES;
            [self.navigationController pushViewController:playViewVC animated:YES];
        }
        else if ([lotteryName isEqualToString:@"DLT"]){
       
            DLTPlayViewController *playVC = [[DLTPlayViewController alloc] init];
            playVC.hidesBottomBarWhenPushed = YES;
            playVC.lottery = self.lotteryDS[1];
            [self.navigationController pushViewController:playVC animated:YES];
            
        }
        else if ([lotteryName isEqualToString:@"SSQ"]){
            
            SSQPlayViewController *playVC = [[SSQPlayViewController alloc] init];
            playVC.hidesBottomBarWhenPushed = YES;
            playVC.lottery = self.lotteryDS[10];
            [self.navigationController pushViewController:playVC animated:YES];
        }
        else if ([lotteryName isEqualToString:@"GYJ"]){
            GYJPlayViewController *gyjPlayVc = [[GYJPlayViewController alloc]init];
            gyjPlayVc.hidesBottomBarWhenPushed = YES;
            gyjPlayVc.navigationController.navigationBar.hidden = YES;
            [self.navigationController pushViewController:gyjPlayVc animated:YES];
        }
        else if ([lotteryName isEqualToString:@"SD115"]){
            LotteryPlayViewController *gyjPlayVc = [[LotteryPlayViewController alloc]init];
            gyjPlayVc.hidesBottomBarWhenPushed = YES;
            gyjPlayVc.lottery = self.lotteryDS[11];
            [self.navigationController pushViewController:gyjPlayVc animated:YES];
        }
        else if ([lotteryName isEqualToString:@"SX115"]){
            LotteryPlayViewController *gyjPlayVc = [[LotteryPlayViewController alloc]init];
            gyjPlayVc.hidesBottomBarWhenPushed = YES;
            gyjPlayVc.lottery = self.lotteryDS[0];
            [self.navigationController pushViewController:gyjPlayVc animated:YES];
            
        }
        else {
            [self showPromptText:@"此彩种暂停销售" hideAfterDelay:1.0];
        }
    });
    
 
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    if (section < _lotteryArr.count/rowNumber) {
        return rowNumber;
    }
    else {
        return _lotteryArr.count%rowNumber;
    }
}

//- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
//    LotteryAreaViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:reuseIdentifier forIndexPath:indexPath];
//    NSInteger index = [self arryIndex:indexPath];
//    NSDictionary *lottery = (NSDictionary *)_lotteryArr[index];
//    // Configure the cell
//    cell.isEable.hidden = [lottery[@"enable"] boolValue];
//    if ([lottery[@"enable"] boolValue] == NO) {
//        cell.lotteryIntroduce.text = @"暂停销售";
//    }else{
//        cell.lotteryIntroduce.text = [lottery objectForKey:@"lotteryInfo"];
//    }
//    [cell.lotteryImageView setImage:[UIImage imageNamed:[lottery objectForKey:@"lotteryImageName"]]];
//    cell.lotteryName.text = [lottery objectForKey:@"lotteryName"];
//
//    return cell;
//}
//
//#pragma mark <UICollectionViewDelegate>
//-(CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath{
//    return CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds)/rowNumber,125);
//
////    return CGSizeMake(125, 115);
//}
//
////这个是两行cell之间的间距（上下行cell的间距）
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section{
//    return 0;
//}
//
////两个cell之间的间距（同一行的cell的间距）
//- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section{
//    return 0;
//}
//
//
//// Uncomment this method to specify if the specified item should be selected
//- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
//    return YES;
//}

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
    } else if ([lotteryName isEqualToString:@"十一选五"]){
        LotteryPlayViewController *gyjPlayVc = [[LotteryPlayViewController alloc]init];
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
-(void)exchangeToast:(NSString *)msg{
    [self showPromptText:msg hideAfterDelay:1.7];
}


@end
