//
//  WithdrawalsViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/21.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "WithdrawalsViewController.h"
#import "AESUtility.h"

@interface WithdrawalsViewController ()<MemberManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *retainLab;
@property (weak, nonatomic) IBOutlet UILabel *topUpsLab;
@property (weak, nonatomic) IBOutlet UITextField *withdrawTextField;
@property (weak, nonatomic) IBOutlet UILabel *nameLab;
@property (weak, nonatomic) IBOutlet UIButton *bankBtn;
@property (weak, nonatomic) IBOutlet UITextView *commitBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;

@end

@implementation WithdrawalsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"提现";
    if ([self isIphoneX]) {
        
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
}

-(void)withdrawSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText: @"会员提现成功 " hideAfterDelay: 1.7];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}

- (IBAction)bankBtnClick:(id)sender {
    
}
- (IBAction)commitBtnClick:(id)sender {
    [self commitClient];
}

-(void)commitClient{
    
    NSDictionary *withdrawInfo;
    @try {
        NSString *cardCode = self.curUser.cardCode;
        NSString *paypwd = self.withdrawTextField.text;
        
        withdrawInfo = @{@"cardCode":cardCode,
                         @"paypwd": [AESUtility encryptStr: paypwd],
                         @"bankId":CHANNEL_CODE,
                         @"amounts":@"10",
                         };
        
    } @catch (NSException *exception) {
        withdrawInfo = nil;
    } @finally {
        [self.memberMan rechargeSms:withdrawInfo];
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
