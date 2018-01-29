//
//  MyNickSetViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "MyNickSetViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface MyNickSetViewController ()<UITextFieldDelegate,MemberManagerDelegate>{
    
       UIButton *completeBtn;
    
       UIButton *cancleBtn;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UITextField *nickField;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;

@end

@implementation MyNickSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"设置昵称";
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
    self.nickField.delegate = self;
    self.memberMan.delegate = self;
    self.nickField.layer.borderColor = [[UIColor grayColor] CGColor];
    self.nickField.layer.borderWidth = 0.5f;
    if (![self.curUser.nickname isEqualToString:@""]) {
        self.nickField.text = self.curUser.nickname;
    }
    [self navBarItemSet];
}

-(void)navBarItemSet{
    completeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(0, 0, 35, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: completeBtn];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn addTarget: self action: @selector(completeBtnClick) forControlEvents: UIControlEventTouchUpInside];
    
    cancleBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 0, 35, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: cancleBtn];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn addTarget: self action: @selector(cancleBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

-(void)completeBtnClick{
  NSString *nickname = self.nickField.text;

    if(nickname.length==0){
         [self showPromptText:@"昵称不能为空！" hideAfterDelay:1.7];
        return;
    }else if (nickname.length >8) {
        [self showPromptText: @"昵称不能超过8位" hideAfterDelay: 1.7];
        return;
    }else{
        
        [self commitClient];

    }
    
    
}

#pragma mark Regex
//姓名一般只允许包含中文或英文字母

-(void)cancleBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
    
}

- (IBAction)closeBtnClick:(id)sender {
    self.nickField.text =@"";
}

-(void)commitClient{
    
    NSDictionary *resetNickInfo;
    @try {
        NSString *nickname = self.nickField.text;
        
        resetNickInfo = @{@"cardCode":self.curUser.cardCode,
                          @"nickname":nickname
                          };
        
    } @catch (NSException *exception) {
       return;
    }
        [self.memberMan resetNickSms:resetNickInfo];

}

-(void)resetNickSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
   
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"重置昵称成功" hideAfterDelay:1.7];
        self.curUser.nickname = self.nickField.text;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
    if (textField ==  _nickField) {
        if (_nickField.text.length > 8) {
            [self showPromptText:@"昵称不能超过8位" hideAfterDelay:2];
            
        }
    }
}

#pragma UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    
  
    if ([string isEqualToString:@"\n"]) {
        
    }
    
    if ([textField isFirstResponder]) {
        
        if ([[[textField textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textField textInputMode] primaryLanguage]) {
            return NO;
        }
        
        //判断键盘是不是九宫格键盘
        if ([self isNineKeyBoard:string] ){
            return YES;
        }else{
            if ([self hasEmoji:string] || [self stringContainsEmoji:string]){
                return NO;
            }
        }
     }
     if (textField == self.nickField) {
         if (![self isValidateName:string]) {
             return NO;
         }
     }
    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
