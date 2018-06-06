//
//  MyNickSetViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/19.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "SetCriNameSetViewController.h"
#import <QuartzCore/QuartzCore.h>

@interface SetCriNameSetViewController ()<UITextViewDelegate,AgentManagerDelegate>{
       UIButton *completeBtn;
       UIButton *cancleBtn;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *textViewHeight;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UILabel *labTextNum;
@property (weak, nonatomic) IBOutlet UITextView *nickField;
@property (weak, nonatomic) IBOutlet UIButton *closeBtn;
@end

@implementation SetCriNameSetViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    if ([self.titlestr isEqualToString:@"设置圈名"]) {
        _textViewHeight.constant = 50;
        self.labTextNum.text = [NSString stringWithFormat:@"%ld/%d",self.agentModel.circleName.length,10];
    }else{
        _textViewHeight.constant = 90;
        self.labTextNum.text = [NSString stringWithFormat:@"%ld/%d",self.agentModel.notice.length,30];
    }
    self.title = self.titlestr;
    if ([self isIphoneX]) {
        self.top.constant = 88;
    }
    self.nickField.delegate = self;
    self.agentMan.delegate = self;
//    self.nickField.layer.borderColor = [[UIColor grayColor] CGColor];
//    self.nickField.layer.borderWidth = 0.5f;
    if ([self.titlestr isEqualToString:@"设置圈名"]) {
        if ([self.agentModel.circleName isEqualToString:@""] ||self.agentModel.circleName == nil) {
            self.nickField.text = @"";
        }else{
            self.nickField.text = self.agentModel.circleName;
        }
    }else{
        if ([self.agentModel.notice isEqualToString:@""] ||self.agentModel.notice == nil) {
            self.nickField.text = @"";
        }else{
            self.nickField.text = self.agentModel.notice;
        }
    }

    [self navBarItemSet];
}

-(void)navBarItemSet{
    completeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    completeBtn.frame = CGRectMake(0, 0, 40, 30);
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: completeBtn];
    [completeBtn setTitle:@"完成" forState:UIControlStateNormal];
    [completeBtn addTarget: self action: @selector(completeBtnClick) forControlEvents: UIControlEventTouchUpInside];
    
    cancleBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    cancleBtn.frame = CGRectMake(0, 0, 40, 30);
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: cancleBtn];
    [cancleBtn setTitle:@"取消" forState:UIControlStateNormal];
    [cancleBtn addTarget: self action: @selector(cancleBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

-(void)completeBtnClick{
  NSString *nickname = self.nickField.text;
    if ([self.titlestr isEqualToString:@"设置圈名"]) {
        if(nickname.length==0){
            [self showPromptText:@"圈名不能为空！" hideAfterDelay:1.7];
            return;
        }else if (nickname.length >10) {
            [self showPromptText: @"圈名不能超过10个字符" hideAfterDelay: 1.7];
            return;
        }else{
            
            [self modifyCircleName];
            
        }
    }else{
        if(nickname.length==0){
            [self showPromptText:@"公告不能为空！" hideAfterDelay:1.7];
            return;
        }else if (nickname.length >30) {
            [self showPromptText: @"公告不能超过30个字符" hideAfterDelay: 1.7];
            return;
        }else{
            [self modifyNotice];
        }
    }

    
    
}

#pragma mark Regex
//姓名一般只允许包含中文或英文字母
-(void)cancleBtnClick{
    [self.navigationController popViewControllerAnimated:YES];
}

- (IBAction)closeBtnClick:(id)sender {
    self.nickField.text =@"";
    if ([self.titlestr isEqualToString:@"设置圈名"]) {
        
        self.labTextNum.text = [NSString stringWithFormat:@"%d/%d",0,10];
    }else{
        
        self.labTextNum.text = [NSString stringWithFormat:@"%d/%d",0,30];
    }
}

-(void)modifyNotice{
    
    NSDictionary *resetNickInfo;
    @try {
        NSString *nickname = self.nickField.text;
        
        resetNickInfo = @{@"agentId":self.agentModel._id,
                          @"notice":nickname
                          };
        
    } @catch (NSException *exception) {
        return;
    }
    [self.agentMan modifyNotice:resetNickInfo];
}

-(void)modifyCircleName{
    
    NSDictionary *resetNickInfo;
    @try {
        NSString *nickname = self.nickField.text;
        
        resetNickInfo = @{@"agentId":self.agentModel._id,
                          @"circleName":nickname
                          };
        
    } @catch (NSException *exception) {
       return;
    }
        [self.agentMan modifyCircleName:resetNickInfo];
}

-(void)textViewDidEndEditing:(UITextView *)textView{
}

#pragma UITextFieldDelegate
-(BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text{
    if ([text isEqualToString:@""]) {
        if ([self.titlestr isEqualToString:@"设置圈名"]) {
          
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                self.labTextNum.text = [NSString stringWithFormat:@"%ld/%d",textView.text.length,10];
            });
            
        }else{
         
            dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
                
                self.labTextNum.text = [NSString stringWithFormat:@"%ld/%d",textView.text.length ,30];
            });
        }
        return YES;
    }

    if ([self.titlestr isEqualToString:@"设置圈名"]) {
        if (textView.text.length + text.length > 10) {
            return NO;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            self.labTextNum.text = [NSString stringWithFormat:@"%ld/%d",textView.text.length,10];
        });
    }else{
        if (textView.text.length + text.length > 30) {
            return NO;
        }
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        
            self.labTextNum.text = [NSString stringWithFormat:@"%ld/%d",textView.text.length ,30];
        });
    }
    
   
    NSString *otherStr = @"~!@#$%^&*()_+=-.,/';[]\?><:《》，。、？‘；“：”}{|、】【";
    if ([otherStr rangeOfString:text].length > 0) {
        return YES;
    }

    
    if ([textView isFirstResponder]) {
        
        if ([[[textView textInputMode] primaryLanguage] isEqualToString:@"emoji"] || ![[textView textInputMode] primaryLanguage]) {
            return NO;
        }
        
        //判断键盘是不是九宫格键盘
        if ([self isNineKeyBoard:text] ){
            return YES;
        }else{
            if ([self hasEmoji:text] || [self stringContainsEmoji:text]){
                return NO;
            }
        }
     }
     if (textView == self.nickField) {
         if (![self isValidateName:text]) {
             return NO;
         }
     }
    return YES;
}

-(void)modifyNoticedelegate:(NSString *)string isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"设置成功" hideAfterDelay:1.7];
        self.agentModel.notice = self.nickField.text;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

-(void)modifyCircleNamedelegate:(NSString *)string isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"设置成功" hideAfterDelay:1.7];
        self.agentModel.circleName = self.nickField.text;
        [self.navigationController popViewControllerAnimated:YES];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

-(void)textFieldDidBeginEditing:(UITextField *)textField{
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
}

@end
