//
//  DeleteOrderView.m
//  happyLottery
//
//  Created by LYJ on 2018/7/6.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "LegAlertClickView.h"

@interface LegAlertClickView (){

    
}
@property (weak, nonatomic) IBOutlet UIView *clickItemView;

@end


@implementation LegAlertClickView

- (instancetype)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self = [[[NSBundle mainBundle]loadNibNamed:@"LegAlertClickView" owner:nil options:nil]lastObject];
    }
    self.frame = frame;
    self.clickItemView.layer.cornerRadius = 5;
    self.clickItemView.layer.masksToBounds = YES;
    self.backgroundColor = RGBACOLOR(0, 0, 0, 0.62);
    return self;
}

- (IBAction)actionClickWechat:(id)sender {
    UIPasteboard *pboard = [UIPasteboard generalPasteboard];
    
    BaseViewController *baseVC = (BaseViewController *)[self getCurrentVC];
    
    if (self.wechat == nil) {
        [baseVC showPromptText:@"暂未上传微信信息" hideAfterDelay:2.0];
    }else{
        [baseVC showPromptText:@"微信号已复制到剪贴板" hideAfterDelay:2.0];
        pboard.string = self.wechat;
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
- (IBAction)actionClickMobile:(id)sender {
    if (self.mobile == nil) {
        BaseViewController *baseVC = (BaseViewController *)[self getCurrentVC];
        
        [baseVC showPromptText:@"暂未上传手机号" hideAfterDelay:2.0];
    }else{
        [[UIApplication sharedApplication]openURL:[NSURL URLWithString:[NSString stringWithFormat:@"tel://%@",self.mobile]]];
    }
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.3 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        [self removeFromSuperview];
    });
}
- (IBAction)actionClose:(id)sender {
    [self removeFromSuperview];
}

@end
