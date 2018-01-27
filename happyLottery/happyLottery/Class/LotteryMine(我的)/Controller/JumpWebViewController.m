//
//  JumpWebViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/25.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "JumpWebViewController.h"

@interface JumpWebViewController ()
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIWebView *web;

@end

@implementation JumpWebViewController
@synthesize URL,title;
- (void)viewDidLoad {
    [super viewDidLoad];
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    self.title=title;
    [self showWeb];
}


- (void)showWeb{
    NSLog(@"网页");
    
    
    NSURL *linkUrl;
//    if (self.curUser.isLogin == YES) {
//
//        if (self.curUser.cardCode != nil) {
//            linkUrl = [NSURL URLWithString:[NSString stringWithFormat:@"%@?cardCode=%@",URL,self.curUser.cardCode]];
//        }else{
//            linkUrl = [NSURL URLWithString:URL];
//        }
//
//    }else{
//        linkUrl = [NSURL URLWithString:URL];
//    }
//
     linkUrl = [NSURL URLWithString:URL];
    
    [_web loadRequest:[NSURLRequest requestWithURL:linkUrl]];
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
