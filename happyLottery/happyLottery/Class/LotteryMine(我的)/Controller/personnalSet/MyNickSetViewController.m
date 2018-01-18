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
        return;}
//    }else if (nickname.length >8) {
//        [self showPromptText: @"昵称不能超过8位" hideAfterDelay: 1.7];
//        return;
//    }
    else{
        
        [self commitClient];

    }
    
    
}

#pragma mark Regex
//姓名一般只允许包含中文或英文字母
- (BOOL)isValidateName:(NSString *)name
{
    //NSString *nameRegex = @"^[\u4E00-\u9FA5A-Za-z0-9]{2,16}";
    NSPredicate *namePredicate = [NSPredicate predicateWithFormat:@"SELF MATCHES %@",REG_NICKNAME_STR];
    
    return [namePredicate evaluateWithObject:name];
}

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
        resetNickInfo = nil;
    } @finally {
        [self.memberMan resetNickSms:resetNickInfo];
    }
    
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

#pragma UITextFieldDelegate

-(BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
     NSString *str = [NSString stringWithFormat:@"%@%@",textField.text,string];
     if (textField == self.nickField) {
    if (str.length>8) {
               [self showPromptText: @"昵称不能超过8位" hideAfterDelay: 1.7];
         return NO;
    }
     }
   
    

    return YES;
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    textField.text =@"";
}

-(void)textFieldDidEndEditing:(UITextField *)textField{
   
    if (textField == self.nickField) {
        if (![self isValidateName:self.nickField.text]) {
            [self showPromptText: @"请输入正确的昵称" hideAfterDelay: 1.7];
            self.nickField.text= @"";
            return;
        }
        
    }
    [self.view resignFirstResponder];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
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
