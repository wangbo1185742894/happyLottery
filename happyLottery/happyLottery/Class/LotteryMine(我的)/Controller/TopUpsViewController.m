//
//  TopUpsViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/21.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "TopUpsViewController.h"

@interface TopUpsViewController ()<MemberManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *retainLab;
@property (weak, nonatomic) IBOutlet UITextField *topUpsTexeField;
@property (weak, nonatomic) IBOutlet UIButton *choose1Btn;
@property (weak, nonatomic) IBOutlet UIButton *choose2Btn;
@property (weak, nonatomic) IBOutlet UIButton *choose3Btn;
@property (weak, nonatomic) IBOutlet UIButton *yinlianPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *kuaijiePayBtn;
@property (weak, nonatomic) IBOutlet UIButton *weixinPayBtn;
@property (weak, nonatomic) IBOutlet UIButton *haveReadBtn;
@property (weak, nonatomic) IBOutlet UIButton *memberDetailBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation TopUpsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"充值";
    if ([self isIphoneX]) {
    
        self.top.constant = 88;
     
    }
}

-(void)rechargeSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText: @"会员充值成功" hideAfterDelay: 1.7];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

- (IBAction)chooseBtnClick:(id)sender {
}
- (IBAction)choose2BtnClick:(id)sender {
}
- (IBAction)choose3BtnClick:(id)sender {
}
- (IBAction)yinlianPay:(id)sender {
}
- (IBAction)kuaijiePay:(id)sender {
}
- (IBAction)weixinPay:(id)sender {
}
- (IBAction)haveead:(id)sender {
}
- (IBAction)memberDetail:(id)sender {
}
- (IBAction)commitBtnClick:(id)sender {
    [self commitClient];
}

-(void)commitClient{
    
    NSDictionary *rechargeInfo;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *checkCode = self.topUpsTexeField.text;
        
        rechargeInfo = @{@"cardCode":cardCode,
                          @"channelCode":CHANNEL_CODE,
                          @"checkCode":checkCode,
                          };
        
    } @catch (NSException *exception) {
        rechargeInfo = nil;
    } @finally {
        [self.memberMan rechargeSms:rechargeInfo];
    }
    
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
