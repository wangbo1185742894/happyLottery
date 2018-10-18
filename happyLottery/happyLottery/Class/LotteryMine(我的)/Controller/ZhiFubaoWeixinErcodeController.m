//
//  ZhiFubaoWeixinErcodeController.m
//  Lottery
//
//  Created by 王博 on 2017/10/20.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "ZhiFubaoWeixinErcodeController.h"
#import "QRCodeGenerator.h"
@interface ZhiFubaoWeixinErcodeController ()
@property (weak, nonatomic) IBOutlet UIImageView *imgErcode;
@property (weak, nonatomic) IBOutlet UILabel *labInfo1;
@property (weak, nonatomic) IBOutlet UILabel *labInfo2;
@property (weak, nonatomic) IBOutlet UIButton *btnOpenApp;

@end

@implementation ZhiFubaoWeixinErcodeController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.imgErcode.image = [QRCodeGenerator qrImageForString:self.erCode imageSize:self.imgErcode.mj_w];
    
    if ([self.chongzhitype isEqualToString:@"weixin"]) {
        [self.btnOpenApp setTitle:@"1.找他人微信扫一扫代付充值；" forState:0];
        self.title = @"微信扫码支付";
        self.labInfo2.text = @"2.截图保存并发送至其他设备，打开手机微信扫此截图二维码充值。";
    }else if ([self.chongzhitype isEqualToString:@"zhifubao"]) {
        self.title = @"支付宝扫码支付";
        self.labInfo2.text = @"2.打开支付宝”扫一扫“充值";
        [self.btnOpenApp setTitle:@"打开支付宝支付" forState:0];
    }
    
}

- (IBAction)actionOpenWXorZFB:(UIButton *)sender {
    
    if ([self.chongzhitype isEqualToString:@"zhifubao"]) {
        NSURL * url = [NSURL URLWithString:@"alipay://"];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
        //先判断是否能打开该url
        if (canOpen)
        {   //打开微信
            [[UIApplication sharedApplication] openURL:url];
        }
    }else if ([self.chongzhitype isEqualToString:@"weixin"]) {
        
        NSURL * url = [NSURL URLWithString:@"weixin://"];
        BOOL canOpen = [[UIApplication sharedApplication] canOpenURL:url];
        //先判断是否能打开该url
        if (canOpen)
        {
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:url]];
        }
        
    
    }
    
}

@end
