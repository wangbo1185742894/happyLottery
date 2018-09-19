//
//  SendRedViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/9/14.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "SendRedViewController.h"
#import "TopUpsViewController.h"

@interface SendRedViewController ()<UITextFieldDelegate,AgentManagerDelegate>

@property (weak, nonatomic) IBOutlet UILabel *balanceLab;

@property (weak, nonatomic) IBOutlet UITextField *yuanTextField;

@property (weak, nonatomic) IBOutlet UITextField *countTextField;

@property (weak, nonatomic) IBOutlet UILabel *mountMoneyLab;

@property (weak, nonatomic) IBOutlet UIButton *sendBtn;
@property (weak, nonatomic) IBOutlet UIView *yuanView;
@property (weak, nonatomic) IBOutlet UIView *countView;

@end

@implementation SendRedViewController{
    NSInteger count;  //红包个数
    NSInteger yuan; //单个价格
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"发红包";
    self.balanceLab.text = [NSString stringWithFormat:@"账户余额 %.2f元",[self.curUser.balance doubleValue]];
    self.yuanTextField.text = @"1";
    self.countTextField.text = [NSString stringWithFormat:@"%ld",self.circleMember.count];
    self.yuanTextField.keyboardType = UIKeyboardTypeNumberPad;
    self.yuanTextField.delegate = self;
    self.agentMan.delegate = self;
    [self upDateCountMoney];
    self.yuanView.layer.masksToBounds = YES;
    self.countView.layer.masksToBounds = YES;
    self.yuanView.layer.cornerRadius = 10;
    self.countView.layer.cornerRadius = 10;
    self.sendBtn.layer.masksToBounds = YES;
    self.sendBtn.layer.cornerRadius = 2;
    // Do any additional setup after loading the view from its nib.
}


- (void)upDateCountMoney{
    count = [self.countTextField.text integerValue];
    yuan = [self.yuanTextField.text integerValue];
    self.mountMoneyLab.text = [NSString stringWithFormat:@"￥ %ld",count * yuan];
    if ([self.mountMoneyLab.text integerValue] < [self.curUser.balance integerValue]) {
        self.sendBtn.userInteractionEnabled=YES;
        self.sendBtn.alpha=1.0f;
    } else {
        self.sendBtn.userInteractionEnabled=NO;
        self.sendBtn.alpha=0.4f;
    }
}


- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    NSInteger strLength = textField.text.length - range.length + string.length;
    if (strLength > 4) {
        return NO;
    }
    if (textField.text.length == 0 && [string isEqualToString:@"0"]) {
        return NO;
    }
    return YES;
}

- (void)textFieldDidEndEditing:(UITextField *)textField{
    if ([textField.text integerValue]<1 && textField == self.yuanTextField) {
        textField.text = @"1";
    }
    [self upDateCountMoney];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionToRechage:(id)sender {
    if (!self.curUser.isLogin){
        [self needLogin];
    } else {
        TopUpsViewController *topUpsVC = [[TopUpsViewController alloc]init];
        topUpsVC.hidesBottomBarWhenPushed = YES;
        [self.navigationController pushViewController:topUpsVC animated:YES];
    }
}

- (IBAction)actionToSendRed:(id)sender {
    [self.agentMan sendAgentRedPacket:@{@"agentId":self.curUser.agentInfo._id, //圈子ID
                                        @"cardCode":self.curUser.cardCode,//圈主卡号
                                        @"amount":[NSString stringWithFormat:@"%ld",count * yuan],//总金额
                                        @"univalent":self.yuanTextField.text,//单个价格
                                        @"totalCount":self.countTextField.text,//红包个数
                                        @"randomType":@(0),//红包类型
                                        @"sendCardCodeList":self.circleMember //收红包的圈民cardCode
                                        }];
}

-(void)sendAgentRedPacketdelegate:(NSString *)string isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"发红包成功" hideAfterDelay:1.7];
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            [self.navigationController popViewControllerAnimated:YES];
        });
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
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
