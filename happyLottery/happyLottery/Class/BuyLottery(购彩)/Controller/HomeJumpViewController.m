//
//  HomeJumpViewController.m
//  Lottery
//
//  Created by LC on 16/6/1.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import "HomeJumpViewController.h"
#import "UIImage+RandomSize.h"
#import "UIImageView+WebCache.h"

#define LEFTPADDING 15
@interface HomeJumpViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet UILabel *labBack;

@end

@implementation HomeJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动信息";
    if (_isNeedBack) {
        
    }
    
    self.title = self.infoModel.title;
    [self showWeb];
    

}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (_isNeedBack) {
        
        self .navigationController.navigationBar.hidden = YES;
    }
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    if (_isNeedBack) {
        
        self .navigationController.navigationBar.hidden = NO;
    }
}

- (void)showWeb{
    NSLog(@"网页");
    
    
    NSURL *linkUrl;
    if (self.curUser.isLogin == YES) {
       NSString * slinkUrl = _infoModel.linkUrl;
        if (self.curUser.cardCode != nil) {
            linkUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?cardCode=%@",slinkUrl,self.curUser.cardCode]];
        }else{
            linkUrl = [NSURL URLWithString:_infoModel.linkUrl];
        }
        
    }else{
        linkUrl = [NSURL URLWithString:_infoModel.linkUrl];
    }
    UIWebView *webView;
    if (_isNeedBack) {
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 20, KscreenWidth, KscreenHeight - 20)];
    }else{
        webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, KscreenWidth, KscreenHeight - 64)];
    }
    webView.delegate = self;
    
    [self.view addSubview:webView];
    webView.scrollView.bounces = NO;
    
    [self.view bringSubviewToFront:_btnBack];
    [webView loadRequest:[NSURLRequest requestWithURL:linkUrl]];
}

- (IBAction)actionBack:(id)sender {
    [super navigationBackToLastPage];
}

-(void)webViewDidFinishLoad:(UIWebView *)webView{
    if (_isNeedBack) {
        self.btnBack.hidden = NO;
        self.labBack.hidden = NO;
    }
}

@end
