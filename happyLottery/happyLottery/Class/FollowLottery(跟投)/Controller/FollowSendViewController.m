//
//  FollowSendViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/5/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FollowSendViewController.h"
#import "OptionSelectedView.h"
#import "JCLQPlayController.h"
#import "JCZQPlayViewController.h"
@interface FollowSendViewController ()<OptionSelectedViewDelegate>
{
    
        OptionSelectedView *optionView;
    
}

@end

@implementation FollowSendViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setRightBarItems];
    
}
-(void)setRightBarItems{
    
    UIBarButtonItem *itemQuery = [self creatBarItem:@"发起跟投" icon:@"" andFrame:CGRectMake(0, 10, 65, 25) andAction:@selector(optionRightButtonAction)];
    self.navigationItem.rightBarButtonItems = @[itemQuery];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) optionRightButtonAction {
    NSArray *titleArr = @[@" 竞猜篮球",
                          @" 竞猜足球"];
    CGFloat optionviewWidth = 100;
    CGFloat optionviewCellheight = 38;
    CGSize mainSize = [UIScreen mainScreen].bounds.size;
    if (optionView == nil) {
        optionView = [[OptionSelectedView alloc] initWithFrame:CGRectMake(mainSize.width - optionviewWidth, DisTop, optionviewWidth, optionviewCellheight * titleArr.count) andTitleArr:titleArr];
    }else{
        optionView.hidden = NO;
    }
    
    optionView.delegate = self;
    [self.view.window addSubview:optionView];
    
}

- (void)optionDidSelacted:(OptionSelectedView *)optionSelectedView andIndex:(NSInteger)index{
    if(index == 0){
        JCZQPlayViewController * playViewVC = [[JCZQPlayViewController alloc]init];
        playViewVC.hidesBottomBarWhenPushed = YES;
        playViewVC.fromSchemeType = SchemeTypeFaqiGenDan;
        [self.navigationController pushViewController:playViewVC animated:YES];
    }else if(index == 1){
        JCLQPlayController * playViewVC = [[JCLQPlayController alloc]init];
        playViewVC.hidesBottomBarWhenPushed = YES;
        playViewVC.fromSchemeType = SchemeTypeFaqiGenDan;
        [self.navigationController pushViewController:playViewVC animated:YES];
        
    }
}
@end
