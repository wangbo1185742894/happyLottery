//
//  FeedbackViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedBackHistoryViewController.h"
#import "QuestionsViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate,MemberManagerDelegate>{
       NSString *myscore;
    UIButton *noticeBtn;
    UILabel *label;
    long rednum;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder1;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder2;
@property (weak, nonatomic) IBOutlet UILabel *stirngLenghLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UITextView *feedBackTextView;
@property  (nonatomic,strong) NSMutableArray *allStar;
@property (weak, nonatomic) IBOutlet UIView *scoerView;
@property (nonatomic,strong) NSMutableDictionary *contentDictionary;//参数字典

@end

@implementation FeedbackViewController

- (NSMutableArray *)allStar {
    if (!_allStar) {
        self.allStar = [[NSMutableArray alloc] init];
    }
    return _allStar;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo  = @"A209";
    self.title = @"意见反馈";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    myscore=@"5";
    self.memberMan.delegate = self;
    self.feedBackTextView.delegate = self;
    self.placeHolder1.userInteractionEnabled = NO;
    self.placeHolder2.userInteractionEnabled = NO;
    self.commitButton.userInteractionEnabled = NO;
   [self noticeCenterSet];
    self.feedBackTextView.layer.borderWidth = 0.5;
    self.feedBackTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self creatStarUI];
    self.contentDictionary =  [[NSMutableArray alloc]init];
   
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
     [self CheckFeedBackRedNumClient];
}

-(void)noticeCenterSet{
    noticeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    noticeBtn.frame = CGRectMake(0, 0, 35, 30);
    label = [[UILabel alloc]init];
    label.frame =CGRectMake(25, 0,10, 10);
    label.layer.cornerRadius = label.bounds.size.width/2;
    label.layer.masksToBounds = YES;
   
    label.font = [UIFont systemFontOfSize:10];
    label.textAlignment = NSTextAlignmentCenter;
    label.backgroundColor = [UIColor redColor];
    label.textColor = [UIColor whiteColor];
    [noticeBtn addSubview:label];
    label.hidden = YES;
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: noticeBtn];
    [noticeBtn setImage:[UIImage imageNamed:@"dialogfeedback@2x.png"] forState:UIControlStateNormal];
    [noticeBtn addTarget: self action: @selector(noticeBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

-(void)updateRed{
    NSString *red = [NSString stringWithFormat: @"%ld",rednum];
    label.text = red;
    if ([red isEqualToString:@"0"]) {
        label.hidden = YES;
    }else{
        label.hidden = NO;
    }
}

-(void)noticeBtnClick{
    
        [self ResetFeedBackReadStatusClient];
        FeedBackHistoryViewController * nVC = [[FeedBackHistoryViewController alloc]init];
        [self.navigationController pushViewController:nVC animated:YES];
}


- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@", textView.text);
    
    //实时显示字数
    self.stirngLenghLabel.text = [NSString stringWithFormat:@"字数%lu/200字", (unsigned long)textView.text.length];
    
    //字数限制操作
    if (textView.text.length >= 200) {
        
        textView.text = [textView.text substringToIndex:200];
        self.stirngLenghLabel.text = @"字数200/200字";
        
    }
    //取消按钮点击权限，并显示提示文字
    if (textView.text.length == 0) {
    
        self.commitButton.userInteractionEnabled = NO;
        self.commitButton.backgroundColor = [UIColor lightGrayColor];
        
    }else{
         self.commitButton.userInteractionEnabled = YES;
         [self.commitButton setBackgroundColor: SystemGreen];
    }
    
}

-(void)textViewDidBeginEditing:(UITextView *)textView{
    self.placeHolder1.hidden = YES;
    self.placeHolder2.hidden = YES;
}

- (IBAction)commitClick:(id)sender {
     NSString *text = self.feedBackTextView.text;
    text = [text stringByReplacingOccurrencesOfString:@"\r" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@"\n" withString:@""];
    text = [text stringByReplacingOccurrencesOfString:@" " withString:@""];
    
    if (text.length < 10) {
        [self showPromptText:@"最少输入十个字！" hideAfterDelay:1.7];
        return;
    }
    
    if (text.length==0||[text isEqualToString:@""]) {
         [self showPromptText:@"请输入您的宝贵意见！" hideAfterDelay:1.7];
        return;
    }else{
       
        [self FeedBackClient];
        
    }

    
}
-(void)FeedBack:(BOOL)success errorMsg:(NSString *)msg{
    
    if ([msg isEqualToString:@"执行成功"]) {
        [self showPromptText:@"意见反馈成功！" hideAfterDelay:1.7];
        [self performSelector:@selector(delayMethod) withObject:nil afterDelay:1.0];
        
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
}

- (void)delayMethod{
    [self.navigationController popViewControllerAnimated:YES];
}

-(void)FeedBackClient{
    NSString *text = self.feedBackTextView.text;

    NSDictionary *Info;
    @try {
        
        Info = @{@"cardCode":self.curUser.cardCode,
                 @"feedbackContent":text,
                 @"fkscore":myscore
                 };
        
    } @catch (NSException *exception) {
      return;
    }
        [self.memberMan FeedBack:Info];

}

- (IBAction)actionToWenda:(id)sender {
    QuestionsViewController * quesVC = [[QuestionsViewController alloc]init];
    [self.navigationController pushViewController:quesVC animated:YES];
}

-(void)FeedBackUnReadNum:(NSDictionary *)Info IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
       // [self showPromptText:@"获取意见反馈小红点成功！" hideAfterDelay:1.7];
        rednum = [[Info valueForKey:@"unReadNum"] longValue];
        [self updateRed];
    }else{
        [self showPromptText:msg hideAfterDelay:1.7];
    }
}

- (BOOL)textView:(UITextView *)textView shouldChangeTextInRange:(NSRange)range replacementText:(NSString *)text {
    
    dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.1 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
        if (textView.text.length >= 10) {
            _commitButton.enabled = YES;
        }else{
            _commitButton.enabled = NO;
        }
    });
    
    if (textView.text.length + text.length > 200){
        [self showPromptText:@"字数不能超过200个字!" hideAfterDelay:1.7];
        return NO;
    }
    if ([text isEqualToString:@"\n"]) {
        [textView resignFirstResponder];
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
    return YES;
}

-(void)CheckFeedBackRedNumClient{
    NSDictionary *Info;
    @try {
        
        Info = @{@"cardCode":self.curUser.cardCode
                 };
        
    } @catch (NSException *exception) {
      return;
    }
        [self.memberMan FeedBackUnReadNum:Info];
}

-(void)ResetFeedBackReadStatusClient{
    NSDictionary *Info;
    @try {
        
        Info = @{@"cardCode":self.curUser.cardCode
                 };
        
    } @catch (NSException *exception) {
       return;
    }
        [self.memberMan ResetFeedBackReadStatus:Info];

}

-(void)ResetFeedBackReadStatusSmsIsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
       // [self showPromptText:@"更新意见反馈小红点成功！" hideAfterDelay:1.7];
     
    }else{
        
        [self showPromptText:msg hideAfterDelay:1.7];
        
    }
    
}

#pragma mark - creatStar
- (void)creatStarUI {
    
    for (int i = 0; i < 5; i++) {
        UIImageView *imageStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_light"]];
//        if (i == 0) {
//            imageStar = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"star_selected"]];
//        }
        imageStar.frame = CGRectMake(90 + (24 + 5)*i, 48, 24, 24);
        imageStar.contentMode = UIViewContentModeScaleAspectFit;
        [self.scoerView addSubview:imageStar];
        [self.allStar addObject:imageStar];
    }
}
#pragma mark - 点击的坐标
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.scoerView];
    UIImageView *imageTouch;
    for(int i = 0;i < 5 ; i++){
        imageTouch = self.allStar[i];
        if ((touchPoint.x > 80)&&(touchPoint.x < 230)&&(touchPoint.y > 0)&&(touchPoint.y < 80)) {
         
            if (touchPoint.x > 90 && touchPoint.x < 119) {
                myscore = [NSString stringWithFormat:@"%d",1];
            } else if (touchPoint.x > 119 && touchPoint.x < 143) {
                myscore = [NSString stringWithFormat:@"%d",2];
            }else if (touchPoint.x > 143 && touchPoint.x < 172) {
                myscore = [NSString stringWithFormat:@"%d",3];
            }else if (touchPoint.x > 172 && touchPoint.x < 201) {
                myscore = [NSString stringWithFormat:@"%d",4];
            }else if (touchPoint.x > 201 && touchPoint.x < 230) {
                myscore = [NSString stringWithFormat:@"%d",5];
            }
            
            [self.contentDictionary setValue:myscore forKey:@"fkscore"];
            
            if (imageTouch.frame.origin.x > touchPoint.x) {
                imageTouch.image =[UIImage imageNamed:@"starUnselecte"];
            }else{
                imageTouch.image =[UIImage imageNamed:@"star_light"];
            }
        }
    }
}
#pragma mark - 滑动的坐标
//-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
//    UITouch *touch = [touches anyObject];
//    CGPoint touchPoint = [touch locationInView:self.scoerView];
//    UIImageView *imageTouch;
//    for(int i = 0;i < 5 ; i++){
//        imageTouch = self.allStar[i];
//        if ((touchPoint.x > 80)&&(touchPoint.x < 230)&&(touchPoint.y > 0)&&(touchPoint.y < 80)) {
//            NSString *myscore;
//            if (touchPoint.x > 90 && touchPoint.x < 119) {
//                myscore = [NSString stringWithFormat:@"%d",1];
//            } else if (touchPoint.x > 119 && touchPoint.x < 143) {
//                myscore = [NSString stringWithFormat:@"%d",2];
//            }else if (touchPoint.x > 143 && touchPoint.x < 172) {
//                myscore = [NSString stringWithFormat:@"%d",3];
//            }else if (touchPoint.x > 172 && touchPoint.x < 201) {
//                myscore = [NSString stringWithFormat:@"%d",4];
//            }else if (touchPoint.x > 201 && touchPoint.x < 230) {
//                myscore = [NSString stringWithFormat:@"%d",5];
//            }
//            
//            [self.contentDictionary setValue:myscore forKey:@"fkscore"];
//            
//            if (imageTouch.frame.origin.x > touchPoint.x) {
//                imageTouch.image =[UIImage imageNamed:@"starUnselecte"];
//            }else{
//                imageTouch.image =[UIImage imageNamed:@"star_light"];
//            }
//        }
//    }
//}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
