//
//  optimizeView.m
//  Lottery
//
//  Created by LIBOTAO on 15/9/25.
//  Copyright (c) 2015年 AMP. All rights reserved.
//

#import "optimizeView.h"

@interface optimizeView()<UITextFieldDelegate>
@end
@implementation optimizeView
@synthesize parentView, containerView, dialogView, buttonView, onButtonTouchUpInside;

-(CGRect) initContainerViewFrame
{
    CGRect rect = [ UIScreen mainScreen ].applicationFrame;
    float x= rect.origin.x+10;
    float y= rect.origin.y+120;
    float w= rect.size.width-2*x;
    float h= rect.size.height-128;
    CGRect fram = CGRectMake(x, y, w, h);
    return fram;
}

- (void)addButtonsToView: (UIView *)container
{
    //title
    UILabel * TitleLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, container.bounds.size.width, 40)];
    TitleLabel.text = @"修改追号方案";
    TitleLabel.font = [UIFont systemFontOfSize: 16];
    TitleLabel.textAlignment = NSTextAlignmentCenter;
    [TitleLabel setTextColor:[UIColor whiteColor]];
    UIImageView *ImageViewTitle =
    [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, container.bounds.size.width, 40)];
    ImageViewTitle.backgroundColor = SystemGreen;
    [ImageViewTitle addSubview:TitleLabel];
    [container addSubview:ImageViewTitle];
    //连续追号，起始倍数、预期盈利，根据弹出视图大小，动态确定每行宽度，具体为view高度减去标题及底部按钮后等分
    float y = (container.bounds.size.height-90)/6;
    
    UILabel * issaddLabel = [[UILabel alloc] initWithFrame:CGRectMake(10, y-40, 85, 40)];
    issaddLabel.text = @"连续追号：";
    issaddLabel.font = [UIFont systemFontOfSize: 16];
    issaddLabel.textAlignment = NSTextAlignmentCenter;
    issaddLabel.textColor = TEXTGRAYCOLOR;
    
    UILabel * startmultipleLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,y+y-40, 85, 40)];
    startmultipleLabel.text = @"起始倍数：";
    startmultipleLabel.font = [UIFont systemFontOfSize: 16];
    startmultipleLabel.textAlignment = NSTextAlignmentCenter;
    startmultipleLabel.textColor = TEXTGRAYCOLOR;
    
    UIView * beishuView = [[UIView alloc]initWithFrame:CGRectMake(0, 40, container.bounds.size.width, 2*y+y-40)];
    beishuView.backgroundColor = [UIColor whiteColor];
    //期号减，倍数减
    _issuedownBtn = [[UIButton alloc]initWithFrame:CGRectMake(102, 1+y-40, 30, 30)];
    [_issuedownBtn setImage:[UIImage imageNamed:@"touzhubeishujian.png"] forState:UIControlStateNormal];
    [_issuedownBtn setImage:[UIImage imageNamed:@"touzhubeishujian.png"] forState:UIControlStateHighlighted];
    
    [_issuedownBtn addTarget: self action: @selector(issuedownBtnClick) forControlEvents: UIControlEventTouchUpInside];
    _beishudownBtn = [[UIButton alloc]initWithFrame:CGRectMake(102, 1+y+y-40, 30, 30)];
    [_beishudownBtn setImage:[UIImage imageNamed:@"touzhubeishujian.png"] forState:UIControlStateNormal];
    [_beishudownBtn setImage:[UIImage imageNamed:@"touzhubeishujian.png"] forState:UIControlStateHighlighted];
    
    [_beishudownBtn addTarget: self action: @selector(beishudownBtnClick) forControlEvents: UIControlEventTouchUpInside];
    //倍数label
    _issueLabel = [[UILabel alloc]initWithFrame:CGRectMake(131, 1+y-40, 40, 30)];
    _issueLabel.textAlignment = NSTextAlignmentCenter;
    NSString *strissue = [NSString stringWithFormat:@"%ld",(long)_issueNum];
    _issueLabel.text = strissue;
//    _issueLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_bg_normal.9.png"]];
    _issueLabel.layer.borderWidth = SEPHEIGHT;
    _issueLabel.layer.borderColor = SEPCOLOR.CGColor;
    _issueLabel.textColor = TEXTGRAYCOLOR;
    
    _beishuLabel = [[UILabel alloc]initWithFrame:CGRectMake(131, 1+y+y-40, 40, 30)];
    NSString *strmultiple = [NSString stringWithFormat:@"%ld",(long)_multipleNum];
    _beishuLabel.text = strmultiple;
    _beishuLabel.textAlignment = NSTextAlignmentCenter;
//    _beishuLabel.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_bg_normal.9.png"]];
    _beishuLabel.layer.borderWidth = SEPHEIGHT;
    _beishuLabel.layer.borderColor = SEPCOLOR.CGColor;
    _beishuLabel.textColor = TEXTGRAYCOLOR;
    //期号加，倍数加
    _issueUpBtn = [[UIButton alloc]initWithFrame:CGRectMake(171,1+y-40, 30, 30)];
    [_issueUpBtn setImage:[UIImage imageNamed:@"touzhubeishujia.png"] forState:UIControlStateNormal];
    [_issueUpBtn setImage:[UIImage imageNamed:@"touzhubeishujia.png"] forState:UIControlStateHighlighted];
    [_issueUpBtn addTarget: self action: @selector(issueUpBtnClick) forControlEvents: UIControlEventTouchUpInside];
    
    _beishuUpBtn = [[UIButton alloc]initWithFrame:CGRectMake(171,1+y+y-40, 30, 30)];
    [_beishuUpBtn setImage:[UIImage imageNamed:@"touzhubeishujia.png"] forState:UIControlStateNormal];
    [_beishuUpBtn setImage:[UIImage imageNamed:@"touzhubeishujia.png"] forState:UIControlStateHighlighted];
    [_beishuUpBtn addTarget: self action: @selector(beishuUpBtnClick) forControlEvents: UIControlEventTouchUpInside];
    
    UILabel* isslabel;
    UILabel* beishulabel;
    
    isslabel = [[UILabel alloc]initWithFrame:CGRectMake(205, y-40, 40, 30)];
    isslabel.text = @"期";
    beishulabel = [[UILabel alloc]initWithFrame:CGRectMake(205, y+y-40, 40, 30)];
    beishulabel.text = @"倍";
    beishulabel.textColor = TEXTGRAYCOLOR;
    isslabel.textColor = TEXTGRAYCOLOR;
    [beishuView addSubview:_beishudownBtn];
    [beishuView addSubview:_beishuLabel];
    [beishuView addSubview:_issueLabel];
    [beishuView addSubview:_beishuUpBtn];
    [beishuView addSubview:isslabel];
    [beishuView addSubview:beishulabel];
    [beishuView addSubview:_issuedownBtn];
    [beishuView addSubview:_issueUpBtn];
    [beishuView addSubview:issaddLabel];
    [beishuView addSubview:startmultipleLabel];
    [container addSubview:beishuView];
    //单选按钮
    _profitview = [[UIView alloc]initWithFrame:CGRectMake(0,3*y, container.bounds.size.width, 4*y)];
    _profitview.backgroundColor = [UIColor whiteColor];
    _rb1 = [[RadioButton alloc] initWithDelegate:self groupId:@"0"];
    _rb2 = [[RadioButton alloc] initWithDelegate:self groupId:@"0"];
    _rb3 = [[RadioButton alloc] initWithDelegate:self groupId:@"0"];
    
    _rb1.frame = CGRectMake(101,7, 25,25);
    _rb2.frame = CGRectMake(101,y+1, 25,25);
    _rb3.frame = CGRectMake(101,6+3*(y-7), 25,25);
//    rb1.tag = 1;
//    rb2.tag = 2;
//    rb3.tag = 3;
    [_profitview addSubview:_rb1];
    [_profitview addSubview:_rb2];
    [_profitview addSubview:_rb3];
    switch (_planTypeNum) {
        case 1:
            [_rb1 setChecked:YES];
            break;
        case 2:
            [_rb2 setChecked:YES];
            break;
        case 3:
            [_rb3 setChecked:YES];
            break;
        default:
            break;
    }
    [container addSubview:_profitview];
    //全程最低盈利率
    UILabel *minratelabel = [[UILabel alloc]initWithFrame:CGRectMake(130,6,_profitview.bounds.size.width-30,25)];
    minratelabel.text = @"全程最低盈利率";
    minratelabel.font = [UIFont systemFontOfSize: 13];
    minratelabel.textAlignment = NSTextAlignmentLeft;
    minratelabel.textColor = TEXTGRAYCOLOR;
    
    _minnumField = [[UITextField alloc]initWithFrame:CGRectMake(222, 6, 80, 30)];
    _minnumField.textAlignment = NSTextAlignmentCenter;
//    _minnumField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_bg_normal.9.png"]];
    _minnumField.layer.borderWidth = SEPHEIGHT;
    _minnumField.layer.borderColor = SEPCOLOR.CGColor;
    _minnumField.textColor = TEXTGRAYCOLOR;
    NSString *strlowrate = [NSString stringWithFormat:@"%ld",(long)_lowrateNum];
    _minnumField.text = strlowrate;
    
    UILabel *ratelabel = [[UILabel alloc]initWithFrame:CGRectMake(303,6,_profitview.bounds.size.width-30,25)];
    ratelabel.text = @"％";
    ratelabel.font = [UIFont systemFontOfSize: 13];
    ratelabel.textAlignment = NSTextAlignmentLeft;
    ratelabel.textColor = TEXTGRAYCOLOR;
    
    [_profitview addSubview:minratelabel];
    [_profitview addSubview:_minnumField];
    [_profitview addSubview:ratelabel];
    // 前几期盈利，之后盈利
    UILabel *qianlabel = [[UILabel alloc]initWithFrame:CGRectMake(130,y-1,13,25)];
    qianlabel.text = @"前";
    qianlabel.font = [UIFont systemFontOfSize: 13];
    qianlabel.textAlignment = NSTextAlignmentLeft;
    qianlabel.textColor = TEXTGRAYCOLOR;
    [_profitview addSubview:qianlabel];
    
    _qiannumField = [[UITextField alloc]initWithFrame:CGRectMake(144, y-1, 40, 30)];
    _qiannumField.textAlignment = NSTextAlignmentCenter;
//    _qiannumField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_bg_normal.9.png"]];
    _qiannumField.layer.borderWidth = SEPHEIGHT;
    _qiannumField.layer.borderColor = SEPCOLOR.CGColor;
    _qiannumField.textColor = TEXTGRAYCOLOR;
    NSString *strpreissue = [NSString stringWithFormat:@"%ld",(long)_preissueNum];
    _qiannumField.text = strpreissue;

    
    [_profitview addSubview:_qiannumField];
    
    UILabel *qilabel = [[UILabel alloc]initWithFrame:CGRectMake(187, y-1, 13, 30)];
    qilabel.text = @"期";
    qilabel.font = [UIFont systemFontOfSize: 13];
    qilabel.textAlignment = NSTextAlignmentCenter;
    qilabel.textColor = TEXTGRAYCOLOR;
    [_profitview addSubview:qilabel];
    
    _qinumField = [[UITextField alloc]initWithFrame:CGRectMake(202, y-1, 80, 30)];
    _qinumField.textAlignment = NSTextAlignmentCenter;
//    _qinumField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_bg_normal.9.png"]];
    _qinumField.layer.borderWidth = SEPHEIGHT;
    _qinumField.layer.borderColor = SEPCOLOR.CGColor;
    _qinumField.textColor = TEXTGRAYCOLOR;
    NSString *strprerate = [NSString stringWithFormat:@"%ld",(long)_prerateNum];
    _qinumField.text = strprerate;
    
    [_profitview addSubview:_qinumField];
    
    UILabel *ratelabel1 = [[UILabel alloc]initWithFrame:CGRectMake(285,y-1,_profitview.bounds.size.width-30,25)];
    ratelabel1.text = @"％";
    ratelabel1.font = [UIFont systemFontOfSize: 13];
    ratelabel1.textAlignment = NSTextAlignmentLeft;
    ratelabel1.textColor = TEXTGRAYCOLOR;
    [_profitview addSubview:ratelabel1];
    
    UILabel *lateratelabel = [[UILabel alloc]initWithFrame:CGRectMake(130,2*y-8,_profitview.bounds.size.width-30,25)];
    lateratelabel.text = @"之后盈利率";
    lateratelabel.font = [UIFont systemFontOfSize: 13];
    lateratelabel.textAlignment = NSTextAlignmentLeft;
    lateratelabel.textColor = TEXTGRAYCOLOR;
    [_profitview addSubview:lateratelabel];
    
    _ratenumField = [[UITextField alloc]initWithFrame:CGRectMake(195, 2*y-8, 80, 30)];
    _ratenumField.textAlignment = NSTextAlignmentCenter;
    _ratenumField.layer.borderWidth = SEPHEIGHT;
    _ratenumField.layer.borderColor = SEPCOLOR.CGColor;
    _ratenumField.textColor = TEXTGRAYCOLOR;
    NSString *strlaterate = [NSString stringWithFormat:@"%ld",(long)_laterateNum];
    _ratenumField.text = strlaterate;
    
    [_profitview addSubview:_ratenumField];
    
    UILabel *ratelabel2 = [[UILabel alloc]initWithFrame:CGRectMake(277,2*y-8,_profitview.bounds.size.width-30,25)];
    ratelabel2.text = @"％";
    ratelabel2.font = [UIFont systemFontOfSize: 13];
    ratelabel2.textAlignment = NSTextAlignmentLeft;
    ratelabel2.textColor = TEXTGRAYCOLOR;
    [_profitview addSubview:ratelabel2];
    
    //全程最低盈利
    UILabel *minlabel = [[UILabel alloc]initWithFrame:CGRectMake(130,6+3*(y-7),_profitview.bounds.size.width-30,25)];
    minlabel.text = @"全程最低盈利";
    minlabel.font = [UIFont systemFontOfSize: 13];
    minlabel.textAlignment = NSTextAlignmentLeft;
    minlabel.textColor = TEXTGRAYCOLOR;
    
    _minprofitField = [[UITextField alloc]initWithFrame:CGRectMake(209, 6+3*(y-7), 80, 30)];
    _minprofitField.textAlignment = NSTextAlignmentCenter;
//    _minprofitField.backgroundColor = [UIColor colorWithPatternImage:[UIImage imageNamed:@"input_bg_normal.9.png"]];
    _minprofitField.layer.borderWidth = SEPHEIGHT;
    _minprofitField.layer.borderColor = SEPCOLOR.CGColor;
    _minprofitField.textColor = TEXTGRAYCOLOR;
    NSString *strlowprofit = [NSString stringWithFormat:@"%ld",(long)_lowprofitNum];
    _minprofitField.text = strlowprofit;
    
    UILabel *yuanlabel = [[UILabel alloc]initWithFrame:CGRectMake(292,6+3*(y-7),_profitview.bounds.size.width-30,25)];
    yuanlabel.text = @"元";
    yuanlabel.font = [UIFont systemFontOfSize: 13];
    yuanlabel.textAlignment = NSTextAlignmentLeft;
    yuanlabel.textColor = TEXTGRAYCOLOR;
    
    [_profitview addSubview:minlabel];
    [_profitview addSubview:_minprofitField];
    [_profitview addSubview:yuanlabel];
    
    UILabel * profitLabel = [[UILabel alloc] initWithFrame:CGRectMake(10,0, 85, 40)];
    profitLabel.text = @"预期盈利：";
    profitLabel.font = [UIFont systemFontOfSize: 16];
    profitLabel.textAlignment = NSTextAlignmentCenter;
    profitLabel.textColor = TEXTGRAYCOLOR;
    
    [_profitview addSubview:profitLabel];
    //确定、取消按钮
    UIButton *CancelBtn = [[UIButton alloc]initWithFrame:CGRectMake(container.bounds.size.width/4-60, container.bounds.size.height - 50, 120, 40)];
    UIButton *submitBtn = [[UIButton alloc]initWithFrame:CGRectMake(container.bounds.size.width*3/4-60, container.bounds.size.height - 50, 120, 40)];
//    CancelBtn.layer.cornerRadius = 3;
//    CancelBtn.layer.masksToBounds = YES;
//    submitBtn.layer.cornerRadius = 3;
//    submitBtn.layer.masksToBounds = YES;
    [CancelBtn setTitle:@"取消" forState:UIControlStateNormal];
    [submitBtn setTitle:@"生成方案" forState:UIControlStateNormal];
    CancelBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
    CancelBtn.backgroundColor = SystemGreen;
    [CancelBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [CancelBtn setTitleColor:TEXTGRAYCOLOR forState:UIControlStateHighlighted];
    
    [submitBtn setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateNormal];
    [submitBtn setBackgroundImage:[UIImage imageWithColor:SystemGreen] forState:UIControlStateHighlighted];
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [submitBtn setTitleColor:[UIColor lightGrayColor] forState:UIControlStateHighlighted];
    submitBtn.titleLabel.textAlignment = NSTextAlignmentCenter;
//    submitBtn.backgroundColor = [UIColor redColor];
    
    [submitBtn setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    
    [CancelBtn addTarget:self action:@selector(CancelBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    [submitBtn addTarget:self action:@selector(submitBtnTouchUpInside) forControlEvents:UIControlEventTouchUpInside];
    
    [container addSubview:CancelBtn];
    [container addSubview:submitBtn];
    
    _minprofitField.delegate = self;
    _ratenumField.delegate = self;
    _qinumField.delegate = self;
    _qiannumField.delegate = self;
    _minnumField.delegate = self;
}


-(void)CancelBtnTouchUpInside
{
    self.hidden = YES;
//    [self close];
}
-(void)submitBtnTouchUpInside
{
    [self.delegate changeValue:_issueNum multiple:_multipleNum];
    if(_rb1.checked)
    {
        _lowrateNum = [_minnumField.text intValue];
        [self.delegate schemeValue:1 lowprofit:_lowrateNum];
    }
    else if(_rb2.checked)
    {
        _preissueNum = [_qiannumField.text intValue];
        _prerateNum = [_qinumField.text intValue];
        _laterateNum = [_ratenumField.text intValue];
        [self.delegate schemeValue:_preissueNum prerateNum:_prerateNum laterateNum:_laterateNum];
    }
    else if(_rb3.checked)
    {
        _lowprofitNum = [_minprofitField.text intValue];
        [self.delegate schemeValue:3 lowprofit:_lowprofitNum];
    }
//    [self close];
    self.hidden = YES;
}

-(void)beishudownBtnClick{
    if((unsigned int)_multipleNum == 1)
    {
        return;
    }
    _multipleNum -=1;
    NSString *str = [NSString stringWithFormat:@"%u",(unsigned int)_multipleNum];
    _beishuLabel.text = str;
}
-(void)beishuUpBtnClick{
    if (_multipleNum > 98){
        return;
    }
    _multipleNum +=1;
    NSString *str = [NSString stringWithFormat:@"%d",(unsigned int)_multipleNum];
    _beishuLabel.text = str;
}
-(void)issuedownBtnClick{
    if((unsigned int)_issueNum == 1)
    {
        return;
    }
    _issueNum -=1;
    NSString *str = [NSString stringWithFormat:@"%d",(unsigned int)_issueNum];
    _issueLabel.text = str;
}
-(void)issueUpBtnClick{
    NSString * curRoundnum = [_lottery.currentRound valueForKey:@"issueNumber"];
    NSInteger length = [curRoundnum length];
    NSString *strcut = [curRoundnum substringFromIndex:length-2];
    int intString = [strcut intValue];
    NSUInteger curiss = intString;
    
    if(_issueNum > MAXQI11X5 - curiss)
    {
        return;
    }
    _issueNum +=1;
    NSString *str = [NSString stringWithFormat:@"%d",(unsigned int)_issueNum];
    _issueLabel.text = str;
}
-(BOOL)textFieldShouldReturn:(UITextField *)textField
{
    [textField resignFirstResponder];
    return YES;
}
//点击屏幕空白处去掉键盘
- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [_minprofitField resignFirstResponder];
    [_ratenumField resignFirstResponder];
    [_qinumField resignFirstResponder];
    [_qiannumField resignFirstResponder];
    [_minnumField resignFirstResponder];
}
-(void)textFieldDidBeginEditing:(UITextField *)textField
{
    CGRect fram = self.profitview.frame;
    fram.origin.y -= 110;
    self.profitview.frame = fram;
    [UIView commitAnimations];
}

//输入框编辑完成以后，将视图恢复到原始状态
-(void)textFieldDidEndEditing:(UITextField *)textField
{
    CGRect fram = self.profitview.frame;
    fram.origin.y += 110;
//    float y = (container.bounds.size.height-90)/6;
//    fram.origin.y += 3*y-40;
    self.profitview.frame = fram;
}
//输入限
- (BOOL)textField:(UITextField *)textField shouldChangeCharactersInRange:(NSRange)range replacementString:(NSString *)string{
    if ([string isEqualToString:@""]) {
        return YES;
    }
    if (textField.text.length + string.length > 7) {
        return NO;
    }
    NSString * regex;
    regex = @"^[0-9]";
    NSPredicate *pred = [NSPredicate predicateWithFormat:@"SELF MATCHES %@", regex];
    BOOL isMatch = [pred evaluateWithObject:string];
    return isMatch;
}
@end
