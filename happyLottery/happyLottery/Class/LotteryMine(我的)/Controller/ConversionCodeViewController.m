//
//  ConversionCodeViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/5.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ConversionCodeViewController.h"
#import "NNValidationCodeView.h"

@interface ConversionCodeViewController ()<MemberManagerDelegate>
@property (weak, nonatomic) IBOutlet NNValidationCodeView *codeview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) NSString *shareCode;

@end

@implementation ConversionCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"推荐码";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    self.memberMan.delegate= self;
    NNValidationCodeView *view = [[NNValidationCodeView alloc] initWithFrame:CGRectMake((SCREEN_WIDTH-300)/2, 230, 300, 42) andLabelCount:8 andLabelDistance:0];
    
    //    NNValidationCodeView *view = [[NNValidationCodeView alloc] initWithFrame:CGRectMake(80, 100, 300, 45) andLabelCount:4 andLabelDistance:10];
    [self.codeview addSubview:view];
    //    view.changedColor = [UIColor yellowColor];
    view.codeBlock = ^(NSString *codeString) {
        self.shareCode = codeString;
        NSLog(@"验证码:%@", codeString);
    };
}
- (IBAction)commitBtnClick:(id)sender {
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
        Info = nil;
    } @finally {
        [self.memberMan upMemberShareSms:Info];
    }
    
}

-(void)upMemberShareSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    if ([msg isEqualToString:@"执行成功"]) {
        //NSLog(@"Info%@",Info);
         [self showPromptText: @"兑换推荐码成功" hideAfterDelay: 1.7];
          [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
    
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
         [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
    }
}

- (void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
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
