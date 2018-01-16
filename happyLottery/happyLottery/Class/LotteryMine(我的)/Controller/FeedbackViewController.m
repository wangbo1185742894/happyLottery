//
//  FeedbackViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FeedbackViewController.h"
#import "FeedBackHistoryViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate,MemberManagerDelegate>{
       NSString *myscore;
    UIButton *noticeBtn;
    UILabel *label;
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
    [self noticeCenterSet];
    myscore=@"5";
    self.memberMan.delegate = self;
    self.feedBackTextView.delegate = self;
    self.placeHolder1.userInteractionEnabled = NO;
    self.placeHolder2.userInteractionEnabled = NO;
    self.commitButton.userInteractionEnabled = NO;
    
    self.feedBackTextView.layer.borderWidth = 0.5;
    self.feedBackTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
    [self creatStarUI];
    self.contentDictionary =  [[NSMutableArray alloc]init];
}

-(void)noticeCenterSet{
    noticeBtn = [UIButton buttonWithType: UIButtonTypeCustom];
    noticeBtn.frame = CGRectMake(0, 0, 35, 30);
//    label = [[UILabel alloc]init];
//    label.frame =CGRectMake(25, 0,10, 10);
//    label.layer.cornerRadius = label.bounds.size.width/2;
//    label.layer.masksToBounds = YES;
//    label.text = @"2";
//    label.font = [UIFont systemFontOfSize:10];
//    label.textAlignment = NSTextAlignmentCenter;
//    label.backgroundColor = [UIColor redColor];
//    label.textColor = [UIColor whiteColor];
//    [noticeBtn addSubview:label];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithCustomView: noticeBtn];
    [noticeBtn setImage:[UIImage imageNamed:@"dialogfeedback@2x.png"] forState:UIControlStateNormal];
    [noticeBtn addTarget: self action: @selector(noticeBtnClick) forControlEvents: UIControlEventTouchUpInside];
}

-(void)noticeBtnClick{
    
    
        FeedBackHistoryViewController * nVC = [[FeedBackHistoryViewController alloc]init];
        [self.navigationController pushViewController:nVC animated:YES];
}

// 开始编辑
- (void)textViewDidBeginEditing:(UITextView *)textView{
    
    
    self.placeHolder1.hidden = YES;
    self.placeHolder2.hidden = YES;
}

// 结束编辑
- (void)textViewDidEndEditing:(UITextView *)textView{
    
    [self.feedBackTextView resignFirstResponder];
    //允许提交按钮点击操作
    
    
}

- (void)textViewDidChange:(UITextView *)textView
{
    NSLog(@"%@", textView.text);
    
   
    //实时显示字数
    self.stirngLenghLabel.text = [NSString stringWithFormat:@"%lu/200", (unsigned long)textView.text.length];
    
    //字数限制操作
    if (textView.text.length >= 200) {
        
        textView.text = [textView.text substringToIndex:200];
        self.stirngLenghLabel.text = @"200/200";
        
    }
    //取消按钮点击权限，并显示提示文字
    if (textView.text.length == 0) {
        
        self.placeHolder1.hidden = NO;
         self.placeHolder2.hidden = NO;
        self.commitButton.userInteractionEnabled = NO;
        self.commitButton.backgroundColor = [UIColor lightGrayColor];
        
    }else{
         self.commitButton.userInteractionEnabled = YES;
    }
    
}

- (IBAction)commitClick:(id)sender {
     NSString *text = self.feedBackTextView.text;
    if (text.length==0) {
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
        Info = nil;
    } @finally {
        [self.memberMan FeedBack:Info];
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
-(void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self.scoerView];
    UIImageView *imageTouch;
    for(int i = 0;i < 5 ; i++){
        imageTouch = self.allStar[i];
        if ((touchPoint.x > 80)&&(touchPoint.x < 230)&&(touchPoint.y > 0)&&(touchPoint.y < 80)) {
            NSString *myscore;
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
