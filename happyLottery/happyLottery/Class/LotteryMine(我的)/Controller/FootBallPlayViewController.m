//
//  FootBallPlayViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FootBallPlayViewController.h"
#import "LotteryProfileSelectView.h"
#import "WBButton.h"

@interface FootBallPlayViewController (){
    WBButton * titleBtn;
}
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UIView *selectView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;

@property (weak, nonatomic) IBOutlet UIButton *spfBtn;

@property (weak, nonatomic) IBOutlet UIButton *bfBtn;
@property (weak, nonatomic) IBOutlet UIButton *rqspfBtn;
@property (weak, nonatomic) IBOutlet UIButton *jqsBtn;
@property (weak, nonatomic) IBOutlet UIButton *bqcBtn;
@property (weak, nonatomic) IBOutlet UIButton *hhggNtm;

@end

@implementation FootBallPlayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
   // self.title = @"竞足玩法介绍";
    [self loadHtml:@"jingcaizuqiu_shengpingfu"];
    [self setTitleView];
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }else  if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
    }
}

-(void)loadHtml:(NSString*)htmlname{
    
    NSString *path = [[NSBundle mainBundle] bundlePath];
    NSURL *baseURL = [NSURL fileURLWithPath:path];
    NSString * htmlPath = [[NSBundle mainBundle] pathForResource:htmlname
                                                          ofType:@"html"];
    NSString * htmlCont = [NSString stringWithContentsOfFile:htmlPath
                                                    encoding:NSUTF8StringEncoding
                                                       error:nil];
    [self.webView loadHTMLString:htmlCont baseURL:baseURL];
    
   
}

-(void)setTitleView{
  
    
   
    titleBtn = [WBButton buttonWithType:UIButtonTypeCustom];
    titleBtn.frame = CGRectMake(0, 10, 150, 40);
    [titleBtn addTarget:self action:@selector(showProfileType) forControlEvents:UIControlEventTouchUpInside];
    [titleBtn setTitle:@"胜平负" forState:0];
    [titleBtn setImage:[UIImage imageNamed:@"wanfaxiala"] forState:0];
    titleBtn.titleLabel.font = [UIFont systemFontOfSize:18];
//    if (profileSelectView == nil) {
//  profileSelectView = [[LotteryProfileSelectView alloc]initWithFrame:CGRectMake(0, 64, KscreenWidth, KscreenHeight - 64)];
//    }
//    profileSelectView.delegate = self;
//    //_selectView.lotteryPros = self.profiles;
//    profileSelectView.hidden = YES;
//    [self.view addSubview:profileSelectView];
    self.navigationItem.titleView = titleBtn;
    
}

-(void)showProfileType{
    _selectView.hidden = !_selectView.hidden;

}

- (IBAction)BFClick:(id)sender {
     [titleBtn setTitle:@"比分" forState:0];
    self.bfBtn.selected=YES;
    self.spfBtn.selected=NO;
    self.rqspfBtn.selected=NO;
    self.jqsBtn.selected=NO;
    self.bqcBtn.selected=NO;
    self.hhggNtm.selected=NO;
     [self loadHtml:@"jingcaizuqiu_bifen"];
        [self showProfileType];
}

- (IBAction)SPFClick:(id)sender {
      [titleBtn setTitle:@"胜平负" forState:0];
    self.spfBtn.selected=YES;
    self.bfBtn.selected=NO;
    self.rqspfBtn.selected=NO;
    self.jqsBtn.selected=NO;
    self.bqcBtn.selected=NO;
    self.hhggNtm.selected=NO;
    [self loadHtml:@"jingcaizuqiu_shengpingfu"];
      [self showProfileType];
}
- (IBAction)RQSPFClick:(id)sender {
      [titleBtn setTitle:@"让球胜平负" forState:0];
    self.rqspfBtn.selected=YES;
    self.bfBtn.selected=NO;
    self.spfBtn.selected=NO;
    self.jqsBtn.selected=NO;
    self.bqcBtn.selected=NO;
    self.hhggNtm.selected=NO;
    [self loadHtml:@"jingcaizuqiu_rangqiushengpingfu"];
     [self showProfileType];
}
- (IBAction)JQSClick:(id)sender {
      [titleBtn setTitle:@"进球数" forState:0];
    self.jqsBtn.selected=YES;
    self.bfBtn.selected=NO;
    self.spfBtn.selected=NO;
    self.rqspfBtn.selected=NO;
    self.bqcBtn.selected=NO;
    self.hhggNtm.selected=NO;
    [self loadHtml:@"jingcaizuqiu_zongjinqiushu"];
     [self showProfileType];
}
- (IBAction)BQCClick:(id)sender {
      [titleBtn setTitle:@"半全场" forState:0];
    self.bqcBtn.selected=YES;
    self.bfBtn.selected=NO;
    self.spfBtn.selected=NO;
    self.rqspfBtn.selected=NO;
    self.jqsBtn.selected=NO;
    self.hhggNtm.selected=NO;
     [self loadHtml:@"jingcaizuqiu_banquanchang"];
     [self showProfileType];
}
- (IBAction)HHGGClick:(id)sender {
      [titleBtn setTitle:@"混合过关" forState:0];
    self.hhggNtm.selected=YES;
    self.bfBtn.selected=NO;
    self.spfBtn.selected=NO;
    self.rqspfBtn.selected=NO;
    self.jqsBtn.selected=NO;
    self.bqcBtn.selected=NO;
    [self loadHtml:@"jingcaizuqiu_hunheguoguan"];
     [self showProfileType];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
