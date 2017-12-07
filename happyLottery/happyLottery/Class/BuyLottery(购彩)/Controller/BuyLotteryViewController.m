//
//  BuyLotteryViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "BuyLotteryViewController.h"
#import "WBAdsImgView.h"

@interface BuyLotteryViewController ()<WBAdsImgViewDelegate>
{
    
    __weak IBOutlet UIView *scrContentView;
    WBAdsImgView *adsView;
}
@end

@implementation BuyLotteryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.navigationController.navigationBar.hidden = YES;
    [self setADSUI];

}



-(void)setADSUI{
    
    adsView = [[WBAdsImgView alloc]initWithFrame:CGRectMake(0,[self isIphoneX]?24:0, KscreenWidth, 180)];
    
    adsView.delegate = self;
    [scrContentView addSubview:adsView];
    

    [adsView setImageUrlArray:@[@"",@"http://oy9n5uzrj.bkt.clouddn.com/ms/20171205/25b8ff0a955c475bbaf1aa1055dee4a9",@"http://oy9n5uzrj.bkt.clouddn.com/ms/20171128/6d6a844b31f8411e936c91c86ceb1a60"]];
}

-(void)adsImgViewClick:(NSInteger)itemIndex{
//    [self showPromptText:[NSString stringWithFormat:@"点击了%d",itemIndex] hideAfterDelay:1.9];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
