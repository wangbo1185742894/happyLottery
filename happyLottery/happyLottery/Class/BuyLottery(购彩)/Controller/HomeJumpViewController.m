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
@interface HomeJumpViewController ()

@end

@implementation HomeJumpViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"活动信息";
    self.title = self.infoModel.title;
    [self showWeb];

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
    
    UIWebView *webView = [[UIWebView alloc] initWithFrame:CGRectMake(0, 64, KscreenWidth, KscreenHeight - 64)];
    [self.view addSubview:webView];
    
    [webView loadRequest:[NSURLRequest requestWithURL:linkUrl]];
}



@end
