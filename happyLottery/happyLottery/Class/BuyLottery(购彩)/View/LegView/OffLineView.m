//
//  OffLineView.m
//  happyLottery
//
//  Created by LYJ on 2018/9/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "OffLineView.h"

#define LeftTextFrame     CGRectMake(0, 0, 90, 50)

#define RightTextFrame    CGRectMake(0, 0, 25, 50)

@interface OffLineView()<UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UIView *alertView;


@property (weak, nonatomic) IBOutlet UILabel *alertLab;



@end

@implementation OffLineView{
    
    __weak IBOutlet UILabel *orderNoLab;
}

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"OffLineView" owner:nil
                                           options:nil] lastObject];
    }
    self.frame = frame;
    self.backgroundColor = RGBACOLOR(37, 38, 38, 0.5);
    self.alertView.layer.masksToBounds = YES;
    self.alertView.layer.cornerRadius = 12;
    self.alertLab.text = @"";
    return self;
}


- (void)loadDate{
    orderNoLab.text = self.orderNo;
}

- (void)closeView {
    if (self.superview != nil) {
        [self removeFromSuperview];
    }
}

- (IBAction)actionToFuZhi:(id)sender {
     UIPasteboard *pboard = [UIPasteboard generalPasteboard];
     BaseViewController *baseVC = (BaseViewController *)[self getCurrentVC];
    if ([self.fanganHao.text isEqualToString:@"方案号"] ) {
        [baseVC showPromptText:@"方案号已复制到剪贴板" hideAfterDelay:2.0];
    } else {
        [baseVC showPromptText:@"订单号已复制到剪贴板" hideAfterDelay:2.0];
    }
     pboard.string = self.orderNo;
}

- (IBAction)actionOkBtn:(id)sender {
//    [self closeView];
    [self.delegate alreadyRechare];
}

- (IBAction)actionToWeiXin:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    BaseViewController *baseVC = (BaseViewController *)[self getCurrentVC];
    
    if (self.weiXianCode == nil || self.weiXianCode.length == 0) {
        [baseVC showPromptText:@"暂未上传微信信息" hideAfterDelay:2.0];
    }else{
        [baseVC showPromptText:@"微信号已复制到剪贴板" hideAfterDelay:2.0];
        pboard.string = self.weiXianCode;
    }
}

- (IBAction)actionToTelephone:(id)sender {
    BaseViewController *baseVC = (BaseViewController *)[self getCurrentVC];
    if (self.telephone.length == 0) {
        [baseVC showPromptText:@"暂未上传手机号" hideAfterDelay:1.7];
        return;
    }
    [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.telephone]]];
}

- (IBAction)actionToClose:(id)sender {
    [self closeView];
}

@end
