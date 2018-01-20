//
//  UMChongZhiViewController.m
//  Lottery
//
//  Created by 王博 on 2017/8/17.
//  Copyright © 2017年 AMP. All rights reserved.
//

#import "UMChongZhiViewController.h"
#import "WBYCMatchDetailViewController.h"
@interface UMChongZhiViewController ()<UIWebViewDelegate>
@property (weak, nonatomic) IBOutlet UIWebView *webView;
@property (weak, nonatomic) IBOutlet UILabel *labPreIndex;
@property (weak, nonatomic) IBOutlet UIButton *btnSheng;
@property (weak, nonatomic) IBOutlet UIButton *btnPing;
@property (weak, nonatomic) IBOutlet UIButton *btnFu;
@property (weak, nonatomic) IBOutlet UIImageView *imgSheng;
@property (weak, nonatomic) IBOutlet UIImageView *imgPing;
@property (weak, nonatomic) IBOutlet UIImageView *imgFu;
@property (weak, nonatomic) IBOutlet UIButton *btnBack;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightViewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topWebView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *fuBtnWidth;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *rightDis;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *webViewdisBottom;

@property (weak, nonatomic) IBOutlet UIView *viewBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *leftDis;
@property (weak, nonatomic) IBOutlet UILabel *labYuCeGailv;
@property (weak, nonatomic) IBOutlet UILabel *labBackYuce;
@property (weak, nonatomic) IBOutlet UILabel *labForgroundYuce;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *widthLabForground;
@property (weak, nonatomic) IBOutlet UIView *viewYuceGailv;

@end

@implementation UMChongZhiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.webView.scrollView.bounces = NO;
    self.viewYuceGailv.layer.cornerRadius = 2;
    self.viewYuceGailv.layer.masksToBounds = YES;
    
    if (IS_IOS11) {
        self.topWebView.constant = -44;
    }else{
        self.topWebView.constant = -44;
    }
    self.title = @"预测详情";

    if (self.isHis == YES) {
        self.webViewdisBottom.constant = 0;
    }else{
        self.webViewdisBottom.constant = 50;
        
    }
    self.viewBottom.hidden = self.isHis;

    NSURL *strUrl =[NSURL URLWithString:self.model.h5Url];
    
    NSMutableURLRequest *request = [[NSMutableURLRequest alloc]initWithURL: strUrl];
    self.webView.delegate = self;
    [self.webView loadRequest:request];
    [self refreshData];
}

-(void)refreshData{

    self.labYuCeGailv .text = [NSString stringWithFormat:@"%@%%",self.model.predictIndex];
    self.widthLabForground.constant = [self.model.predictIndex doubleValue] / 100.0 * self.labBackYuce.mj_w;
    if ([self.curPlayType isEqualToString:@"jclq"]) {
        self.imgFu.hidden = YES;
        self.btnFu.hidden = YES;
        self.rightDis.constant = -30;
        self.leftDis.constant = 60;
        for (JcForecastOptions *ops in self.model.forecastOptions) {
            switch ([ops.options integerValue]) {
                case 0:
                    self.imgSheng.hidden = ![ops.forecast boolValue];
                    self.btnSheng.selected = [ops.forecast boolValue];
                    
                    [self.btnSheng setTitle:[NSString stringWithFormat:@"主负%.2f",[ops.sp doubleValue]] forState:0];
                    break;
                case 1:
                    self.imgPing.hidden = ![ops.forecast boolValue];
                    self.btnPing.selected = [ops.forecast boolValue];
                    [self.btnPing setTitle:[NSString stringWithFormat:@"主胜%.2f",[ops.sp doubleValue]] forState:0];
                    break;
               
                default:
                    break;
            }
        }
    }else if ([self.curPlayType isEqualToString:@"jczq"]){
        self.imgFu.hidden = NO;
        self.btnFu.hidden = NO;
        self.rightDis.constant = 8;
        self.leftDis.constant = 8;
        for (JcForecastOptions *ops in self.model.forecastOptions) {
            switch ([ops.options integerValue]) {
                case 0:
                    self.imgSheng.hidden = ![ops.forecast boolValue];
                    self.btnSheng.selected = [ops.forecast boolValue];
                    [self.btnSheng setTitle:[NSString stringWithFormat:@"主胜%.2f",[ops.sp doubleValue]] forState:0];
                    break;
                case 1:
                    self.imgPing.hidden = ![ops.forecast boolValue];
                    self.btnPing.selected = [ops.forecast boolValue];
                    [self.btnPing setTitle:[NSString stringWithFormat:@"平局%.2f",[ops.sp doubleValue]] forState:0];
                    break;
                case 2:
                    
                    self.imgFu.hidden = ![ops.forecast boolValue];
                    self.btnFu.selected = [ops.forecast boolValue];
                    [self.btnFu setTitle:[NSString stringWithFormat:@"主负%.2f",[ops.sp doubleValue]] forState:0];
                    break;
                    
                default:
                    break;
            }
        }
    }
}
- (IBAction)actionSelectItem:(UIButton *)sender {
    
    sender.selected = !sender.selected;
    
}
-(void)webViewDidFinishLoad:(UIWebView *)webView{
    [self hideLoadingView];
    
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitUserSelect='none';"];
    [webView stringByEvaluatingJavaScriptFromString:@"document.documentElement.style.webkitTouchCallout='none';"];
}

- (IBAction)actionClose:(UIButton *)sender {
    [UIView animateWithDuration:0.5 animations:^{
        self.btnBack.hidden = YES;
        self.heightViewBottom.constant = 35;
        [self.viewBottom.superview layoutIfNeeded];
        
    }];
}
- (IBAction)actionTouzhu:(UIButton *)sender {
    
    
    
    if (self.viewBottom.mj_h == 150) {
    
        
        [self touzhu];
        
    }else{
    
        dispatch_async(dispatch_get_main_queue(), ^{
            
            [UIView animateWithDuration:0.5 animations:^{
                self.btnBack.hidden = NO;
                
                self.heightViewBottom.constant = 150;
                [self.viewBottom.superview layoutIfNeeded];
                
            }];
        });
    }
}

-(void)touzhu{
    WBYCMatchDetailViewController * detailVC = [[WBYCMatchDetailViewController alloc]init];
    detailVC.model = self.model;
    detailVC.curPlayType = self.curPlayType;
    NSMutableArray *itemArray = [NSMutableArray arrayWithCapacity:0];
    for (JcForecastOptions *mode in self.model.forecastOptions) {
        JcForecastOptions *mode1 = [[JcForecastOptions alloc]init];
        mode1.sp = mode.sp;
        mode1.options = mode.options;
        if ([mode1.options integerValue] == 0) {
            mode1.forecast = [NSString stringWithFormat:@"%d",self.btnSheng.selected];
        }
        if ([mode1.options integerValue] == 1) {
            mode1.forecast = [NSString stringWithFormat:@"%d",self.btnPing.selected];
        }
        if ([mode1.options integerValue] == 2) {
            mode1.forecast = [NSString stringWithFormat:@"%d",self.btnFu.selected];
        }
        [itemArray addObject:mode1];
    }
    for (JcForecastOptions *ops in self.model.forecastOptions) {
        if ([ops.forecast boolValue] == YES && [ops.sp doubleValue] <= 0) {
            [self showPromptText:@"该赛事暂不支持胜平负玩法" hideAfterDelay:1.7];
            return;
        }
    }

    JczqShortcutModel* model = [detailVC.model copyNojcforecastOptions];
    model.forecastOptions = itemArray;

    NSInteger selectNum = 0;
    for (JcForecastOptions * op in model.forecastOptions) {
        if ([op.forecast boolValue] == YES) {
            selectNum ++ ;
        }
    }
    
    if (selectNum == 0) {
        [self showPromptText:@"请选择投注结果" hideAfterDelay:1.7];
        return;
    }
    
    detailVC.isFromYC = YES;
    detailVC.model = model;
    [self.navigationController pushViewController:detailVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}



@end
