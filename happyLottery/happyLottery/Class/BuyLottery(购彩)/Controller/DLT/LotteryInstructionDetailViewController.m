//
//  LotteryInstructionDetailViewController.m
//  Lottery
//
//  Created by YanYan on 6/8/15.
//  Copyright (c) 2015 AMP. All rights reserved.
//

#import "LotteryInstructionDetailViewController.h"
@interface LotteryInstructionDetailViewController () {
    __weak IBOutlet UIScrollView *scroViewMenu_;
    __weak IBOutlet UIWebView *webViewContent_;
    NSArray *actionHTMLFile;
    __block UIButton *selectedButton;
    UILabel *underlineofseclectbtn;
    UILabel *underline;
    
    __weak IBOutlet NSLayoutConstraint *webTopPadding;
}

@end
#define ButtonTagBase 1000
@implementation LotteryInstructionDetailViewController

- (void) viewDidLoad {
    [super viewDidLoad];

    // Do any additional setup after loading the view from its nib.
    self.title = [NSString stringWithFormat: @"%@%@", self.lotteryDetailDic[@"Name"], TextInsturction];
    [self showLoadingViewWithText: TextLoading];
    
    [self loadUI];
}

- (void) didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];

    
}
- (void)viewDidAppear:(BOOL)animated{
//    NSLog(@"%@",self.lotteryDetailDic);
//    if ([self.lotteryDetailDic[@"Name"] isEqualToString:@"胜负彩"]) {
//        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        if (appDelegate.ctzqType == CTZQPlayTypeShiSi) {
//            [self tabItemButtonAction:(UIButton *)[scroViewMenu_ viewWithTag:ButtonTagBase + 1]];
//        }
//    }
//    if ([self.lotteryDetailDic[@"Name"] isEqualToString:@""]) {
//        AppDelegate *appDelegate = (AppDelegate*)[UIApplication sharedApplication].delegate;
//        if (appDelegate.ctzqType == CTZQPlayTypeShiSi) {
//            [self tabItemButtonAction:(UIButton *)[scroViewMenu_ viewWithTag:ButtonTagBase + 1]];
//        }
//    }
    
}

#define ButtonPadding 7
#define ButtonTopPadding 10
#define ButtonMinWidth 65
- (void) loadUI {
    //draw buttons
    scroViewMenu_.backgroundColor = [UIColor whiteColor];
    NSArray *tabsInfo = self.lotteryDetailDic[@"tabs"];
    CGFloat btnMinWidth = ButtonMinWidth;
    if (tabsInfo.count<5) {
        btnMinWidth = KscreenWidth/tabsInfo.count;
    }
    NSMutableArray *actionHTMLFileTMP = [NSMutableArray arrayWithCapacity: tabsInfo.count];
    __block CGFloat curX = 0;
    [tabsInfo enumerateObjectsUsingBlock:^(id obj, NSUInteger idx, BOOL *stop) {
        NSDictionary *tabInfoDic = (NSDictionary *) obj;
        UIButton *tabButton = [UIButton buttonWithType: UIButtonTypeCustom];
//        UILabel *underline = [[UILabel alloc] init];
        NSString *title = tabInfoDic[@"title"];
        UIFont *textFont = [UIFont systemFontOfSize: 16];
        CGSize textSize = MB_TEXTSIZE(title, textFont);
        CGFloat buttonWidth = textSize.width + 20;
        if (buttonWidth < btnMinWidth) {
            buttonWidth = btnMinWidth;
        }
        
        tabButton.frame = CGRectMake(curX, 0, buttonWidth, scroViewMenu_.frame.size.height);
        [tabButton setTitleColor:TEXTGRAYCOLOR forState:UIControlStateNormal];
        [tabButton setTitle: title forState: UIControlStateNormal];
        [tabButton.titleLabel setFont: textFont];
        [tabButton addTarget: self action: @selector(tabItemButtonAction:) forControlEvents: UIControlEventTouchUpInside];
        tabButton.tag = ButtonTagBase+idx;
        NSLog(@"tag:%zd",tabButton.tag);
        [actionHTMLFileTMP addObject: tabInfoDic[@"fileName"]];
        [scroViewMenu_ addSubview: tabButton];
        curX = CGRectGetMaxX(tabButton.frame) ;
        
    }];
    
    
    curX += 0;
    actionHTMLFile = actionHTMLFileTMP;
    CGSize contentSize = scroViewMenu_.frame.size;
    contentSize.width = curX;
    scroViewMenu_.contentSize = contentSize;
    
    underlineofseclectbtn = [[UILabel alloc]init];
    underlineofseclectbtn.backgroundColor = SystemGreen;
    CGRect frame = scroViewMenu_.frame;
    frame.origin.y = 43;
    frame.size.width = contentSize.width;
    frame.size.height = SEPHEIGHT;
    underline = [[UILabel alloc]initWithFrame:frame];
    underline.backgroundColor = SEPCOLOR;
    [scroViewMenu_ addSubview:underlineofseclectbtn];
    [scroViewMenu_ addSubview:underline];

    [self tabItemButtonAction:(UIButton *)[scroViewMenu_ viewWithTag:ButtonTagBase]];
    if (tabsInfo.count == 1) {
        webTopPadding.constant = 64;
        [self.view bringSubviewToFront:webViewContent_];
    }
    [self hideLoadingView];
}

- (void) tabItemButtonAction: (UIButton *) button {
    
    if (button && button.tag != selectedButton.tag) {
        
        [selectedButton setBackgroundColor: [UIColor clearColor]];
        [selectedButton setTitleColor:TEXTGRAYCOLOR forState:UIControlStateNormal];
        selectedButton = button;
        NSString *fileName = actionHTMLFile[button.tag - ButtonTagBase];
        
        NSError *error = NULL;
        NSString *htmlStr = [NSString stringWithContentsOfFile: [[NSBundle mainBundle] pathForResource: fileName ofType: @"html"] encoding: NSUTF8StringEncoding error: &error];
        [webViewContent_ loadHTMLString: htmlStr baseURL: [NSURL fileURLWithPath:[ [NSBundle mainBundle] bundlePath]]];
    }
    [selectedButton setBackgroundColor: [UIColor clearColor]];
    [selectedButton setTitleColor:SystemGreen forState:UIControlStateNormal];
    CGRect fram = button.frame;
    fram.origin.y = 41;
    fram.size.height = 2;
    //增加选中按钮下划线
    [UIView animateWithDuration:0.3 animations:^{
        underlineofseclectbtn.frame = fram;
//        [self.view layoutIfNeeded];
    }];
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
