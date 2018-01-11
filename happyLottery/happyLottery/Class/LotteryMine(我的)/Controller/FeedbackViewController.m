//
//  FeedbackViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/10.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FeedbackViewController.h"

@interface FeedbackViewController ()<UITextViewDelegate>
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder1;
@property (weak, nonatomic) IBOutlet UILabel *placeHolder2;
@property (weak, nonatomic) IBOutlet UILabel *stirngLenghLabel;
@property (weak, nonatomic) IBOutlet UIButton *commitButton;
@property (weak, nonatomic) IBOutlet UITextView *feedBackTextView;

@end

@implementation FeedbackViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"意见反馈";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    self.feedBackTextView.delegate = self;
    self.placeHolder1.userInteractionEnabled = NO;
    self.placeHolder2.userInteractionEnabled = NO;
    self.commitButton.userInteractionEnabled = NO;
    
    self.feedBackTextView.layer.borderWidth = 0.5;
    self.feedBackTextView.layer.borderColor = [UIColor lightGrayColor].CGColor;
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
    
    self.commitButton.userInteractionEnabled = YES;
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
        
    }
    
}

- (IBAction)commitClick:(id)sender {
    
    
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
