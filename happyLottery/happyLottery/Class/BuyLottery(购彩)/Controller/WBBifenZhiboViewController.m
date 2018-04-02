//
//  WBBifenZhiboViewController.m
//  Lottery
//
//  Created by 关阿龙 on 17/3/3.
//  Copyright © 2017年 AMP. All rights reserved.
//  http://info.sporttery.cn/m2/bk_result_list.html

//http://info.sporttery.cn/m2/fb_result_detail.html?mid=90889   详情

//[{"itemName":"比分直播","url":"http://info.sporttery.cn/m2/fb_livescore.html","lottery":"JCZQ","sortVal":"2"},
//{"itemName":"受注赛程","url":"http://info.sporttery.cn/m2/fb_match_list.html","lottery":"JCZQ","sortVal":"1"},
//{"itemName":"赛果开奖","url":"http://info.sporttery.cn/m2/fb_result_list.html","lottery":"JCZQ","sortVal":"3"}]

#import "WBBifenZhiboViewController.h"

#import "LotteryManager.h"
#import "Utility.h"
#import "BiFenZhiboModel.h"
@interface WBBifenZhiboViewController ()<UIWebViewDelegate,LotteryManagerDelegate>
{

    LotteryManager *lotteryMan;
}
@property (weak, nonatomic) IBOutlet UIButton *btnCareMatch;
@property (weak, nonatomic) IBOutlet UIButton *btnBiFenIng;
@property (weak, nonatomic) IBOutlet UIButton *btnMatchResult;
@property (weak, nonatomic) IBOutlet UIWebView *wbContentView;
@property (weak, nonatomic) IBOutlet UIImageView *imgWebBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wbContentViewTop;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *wbContentViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topViewHeight;

@property(strong,nonatomic)NSMutableArray *dataArray;
@property(strong,nonatomic)UIButton *backBtn;

@end

@implementation WBBifenZhiboViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo = @"A108";
    self.dataArray = [NSMutableArray arrayWithCapacity:0];
    
    
    self.title = @"比分直播";
    
    self.lotteryMan.delegate = self;
    
    [self.lotteryMan getBFZBInfo];
    [self showLoadingViewWithText:@"正在加载"];
    
    self.backBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, 90, 44)];
    self.backBtn.backgroundColor = [UIColor clearColor];
    [self.navigationController.navigationBar addSubview:self.backBtn];
    self.backBtn.userInteractionEnabled = NO;
    [self.backBtn addTarget:self action:@selector(actionWebViewBack) forControlEvents:UIControlEventTouchUpInside];
    
    self.wbContentView.scrollView.bounces = NO;
    self.btnBiFenIng.selected = YES;
    self.wbContentView.delegate = self;
    if ([Utility isIOS11After]) {
        _wbContentViewTop.constant = -55;
    }else{
        _wbContentViewTop.constant = 4;
    }
}

-(void)gotBFZBInfo:(NSArray *)dataArray{

//    *itemName,*lottery,*sortVal,*url;
    if (dataArray == nil || dataArray .count ==0) {
        dataArray = @[@{@"itemName":@"比分直播",@"url":@"http://info.sporttery.cn/m2/fb_livescore.html",@"lottery":@"JCZQ",@"sortVal":@"2"},
                     @{@"itemName":@"受注赛程",@"url":@"http://info.sporttery.cn/m2/fb_match_list.html",@"lottery":@"JCZQ",@"sortVal":@"1"},
                     @{@"itemName":@"赛果开奖",@"url":@"http://info.sporttery.cn/m2/fb_result_list.html",@"lottery":@"JCZQ",@"sortVal":@"3"}];
    }
        for (NSDictionary *dic in dataArray) {
            BiFenZhiboModel *model = [[BiFenZhiboModel alloc]initWithDic:dic];
            [self.dataArray addObject:model];
            
        }
        [self.dataArray sortUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
            BiFenZhiboModel *model1 = (BiFenZhiboModel*) obj1;
            BiFenZhiboModel *model2 = (BiFenZhiboModel*) obj2;
            return [model1.sortVal integerValue] > [model2.sortVal integerValue];
        }];
        
        for (int i = 0; i < self.dataArray.count; i++) {
            
            BiFenZhiboModel *model  = self.dataArray[i];
            if (i == 0) {
                [self.btnCareMatch setTitle:model.itemName forState:0];
            }
            if (i == 1) {
                [self.btnBiFenIng setTitle:model.itemName forState:0];
                [self.wbContentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.url]]];
            }
            if (i == 2) {
                [self.btnMatchResult setTitle:model.itemName forState:0];
            }
        }
}

-(void)actionWebViewBack{

    [self.wbContentView goBack];
    self.backBtn.userInteractionEnabled = NO;
    
}

- (IBAction)actionMatchResult:(UIButton *)sender {
    
 
    [self setBtnSState:sender];
    if (self.dataArray == nil || self.dataArray.count == 0) {
        return;
    }
    BiFenZhiboModel *model  = self.dataArray[2];
    
    [self.wbContentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.url]]];
}
- (IBAction)actionBiFenIng:(UIButton *)sender {
    [self setBtnSState:sender];
    if (self.dataArray == nil || self.dataArray.count == 0) {
        return;
    }
    BiFenZhiboModel *model  = self.dataArray[1];
    
    [self.wbContentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.url]]];
}
- (IBAction)actionCareMatch:(UIButton *)sender {
    [self setBtnSState:sender];
    if (self.dataArray == nil || self.dataArray.count == 0) {
        return;
    }
    BiFenZhiboModel *model  = self.dataArray[0];
    
    [self.wbContentView loadRequest:[NSURLRequest requestWithURL:[NSURL URLWithString:model.url]]];
}

-(void)setBtnSState:(UIButton *)sender{

    self.btnBiFenIng.selected = NO;
    self.btnCareMatch.selected = NO;
    self.btnMatchResult.selected = NO;
    
    sender.selected = YES;
}

-(void)webViewDidStartLoad:(UIWebView *)webView{
    webView.hidden = YES;
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{

    // 1.获取页面标题
    NSString *string = @"document.title";
    [webView stringByEvaluatingJavaScriptFromString:string];
    // 2.去掉页面标题
    NSMutableString *str = [NSMutableString string];
    // 4.去掉footer一栏
    [str appendString:@"var header = document.getElementsByClassName(\"header\")[0];"];
    [str appendString:@"header.parentNode.removeChild(header);"];
    [str appendString:@"var footer = document.getElementsByClassName(\"footer\")[0];"];
    [str appendString:@"footer.parentNode.removeChild(footer);"];
    [webView stringByEvaluatingJavaScriptFromString:str];
    [self hideLoadingView];
    webView.hidden = NO;
}

-(void)addview{
    UIView *viwe = [[UIView alloc]initWithFrame:CGRectMake(0, 0, 320, 300)];
    viwe.backgroundColor = [UIColor redColor];
    
    
    [self.wbContentView.scrollView addSubview:viwe];
    viwe.mj_y = self.wbContentView.scrollView.contentSize.height-300;
}



- (BOOL)webView:(UIWebView *)webView shouldStartLoadWithRequest:(NSURLRequest *)request navigationType:(UIWebViewNavigationType)navigationType{
   
    [self showLoadingViewWithText:@"正在加载"];
    NSString *requsetIngUrlStr =[NSString stringWithFormat:@"%@",request.URL];
    
    
    if ([requsetIngUrlStr rangeOfString:@"?m="].length == 0 ) {
        
        if ([Utility isIOS11After]) {
            self.wbContentViewTop.constant = -55;
        }else{
            self.wbContentViewTop.constant = 4;
        }

        self.backBtn.userInteractionEnabled= NO;
//        self.topViewHeight.constant = 96;
        return YES;
    }else{
        self.wbContentViewTop.constant = -120;
//        self.wbContentViewTop.constant = -22;
        self.backBtn.userInteractionEnabled = YES;
//        self.wbContentViewBottom.constant = 0;
        return YES;
    }
}

-(void)viewWillAppear:(BOOL)animated{

    [super viewWillAppear:animated];
    
}

-(void)viewWillDisappear:(BOOL)animated{
    [self.backBtn removeFromSuperview];
}

@end
