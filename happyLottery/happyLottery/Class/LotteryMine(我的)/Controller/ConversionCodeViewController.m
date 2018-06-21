//
//  ConversionCodeViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ConversionCodeViewController.h"


@interface ConversionCodeViewController ()<MemberManagerDelegate,UITextFieldDelegate>

@property (weak, nonatomic) IBOutlet UITextField *tfRecommCode;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) NSString *shareCode;

@end

@implementation ConversionCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐码";
    self.tfRecommCode.delegate = self;
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    self.memberMan.delegate= self;
}
- (IBAction)commitBtnClick:(id)sender {
    
    self.shareCode = self.tfRecommCode.text;
    
    if ([self.shareCode isEqualToString:@""]) {
           [self showPromptText: @"请输入推荐码！" hideAfterDelay: 1.7];
           return;
    }else{
           [self shareCodeClient];
    }
}

-(void)shareCodeClient{
    NSDictionary *Info;
    @try {
          NSLog(@"验证码:%@", self.shareCode);
        Info = @{@"cardCode":self.curUser.cardCode,
                 @"shareCode":self.shareCode ,
                 @"channelCode":@"TBZ"
                 };
        
    } @catch (NSException *exception) {
     return;
    }
    [self.memberMan upMemberShareSms:Info];
}

-(void)upMemberShareSmsIsSuccess:(BOOL)success result:(NSString *)result errorMsg:(NSString *)msg{
    
    if ([msg isEqualToString:@"执行成功"]) {
        //NSLog(@"Info%@",Info);
         [self showPromptText: result hideAfterDelay: 1.7];

          [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
    
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

- (void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];

}

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
    if (textField.text.length + string.length > 8) {
        return NO;
    }
    
    NSString * regex = @"^[A-Za-z0-9]{0,}$";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    return  [pred evaluateWithObject:string];
    
}



@end
