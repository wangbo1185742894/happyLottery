//
//  MyCircleViewController.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "MyCircleViewController.h"
#import <ShareSDK/ShareSDK.h>
#import "CFLineChartView.h"
#import <ShareSDKUI/ShareSDKUI.h>
#import "MyAgentInfoModel.h"
#import "YongjinListViewController.h"
#import "MyCricleFriendVC.h"
#import "MyCricleYongJinVC.h"
#import "RuZhangViewController.h"
#import "CricleCenterViewController.h"

@interface MyCircleViewController ()<AgentManagerDelegate>
@property (weak, nonatomic) IBOutlet UILabel *labRecentlyYongjinInfo;
@property (weak, nonatomic) IBOutlet UIImageView *imgBG;
@property (weak, nonatomic) IBOutlet UIView *viewRecentLy;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDis;
@property (weak, nonatomic) IBOutlet UILabel *labYue;
@property (weak, nonatomic) IBOutlet UIButton *btnRuZhang;
@property (nonatomic, strong) CFLineChartView *LCView;
@property(nonatomic,strong)MyAgentInfoModel *agentInfoModel;


@end

@implementation MyCircleViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"我的圈子";
    self.imgBG.layer.cornerRadius = 6;
    
    self.imgBG.layer.masksToBounds = YES;
    self.btnRuZhang.layer.borderColor = [UIColor whiteColor].CGColor;
    self.btnRuZhang.layer.borderWidth = 1;
    self.btnRuZhang.layer.cornerRadius = 10;
    self.btnRuZhang.layer.masksToBounds = YES;
    self.topDis.constant = NaviHeight;
    [self setRightBarItems];
    [self doWithCreateUI];
    self.agentMan.delegate = self;
    
}

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    [self loadData];
}
-(void)loadData{
    [self.agentMan getMyAgentInfo:@{@"cardCode":self.curUser.cardCode}];
}


-(void)getMyAgentInfodelegate:(NSDictionary *)param isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if (success == NO) {
        [self showPromptText:msg hideAfterDelay:1.8];
        return;
    }
    
    self.agentInfoModel = [[MyAgentInfoModel alloc]initWith:param];
    
    self.labYue.text = [NSString stringWithFormat:@"%.2f",[self.agentInfoModel.commission doubleValue]];
    NSMutableArray *listX = [NSMutableArray arrayWithCapacity:0];
    NSMutableArray *listY = [NSMutableArray arrayWithCapacity:0];
    
    for (NSInteger i = self.agentInfoModel.agentTotalList.count - 1; i >= 0; i --) {
        MyAgentTotalModel *model = self.agentInfoModel.agentTotalList[i];
        [listX addObject: [model.totalDay substringFromIndex:5] ];
        [listY addObject: [NSString stringWithFormat:@"%.2f",[model.totalCommission doubleValue]] ];
    }
    self.labRecentlyYongjinInfo.text = [NSString stringWithFormat:@"近%ld日佣金走势",listX.count];
   self. LCView.xValues = listX;
    self. LCView.yValues = listY ;
    //@[@23,@35,@89];
    [self setupConditions];
}

-(void)setRightBarItems{
    
    UIBarButtonItem *itemQuery = [self creatBarItem:@"" icon:@"icon_share" andFrame:CGRectMake(0, 10, 30, 30) andAction:@selector(pressPlayIntroduce)];
    UIBarButtonItem *faqi = [self creatBarItem:@"" icon:@"icon_shezhi" andFrame:CGRectMake(0, 10, 30, 30) andAction:@selector(optionRightButtonAction)];
    self.navigationItem.rightBarButtonItems = @[faqi,itemQuery];
}

-(void)pressPlayIntroduce{
    [self  initshare];
}

-(void)optionRightButtonAction{
    CricleCenterViewController *cricleVC = [[CricleCenterViewController alloc]init];
    cricleVC.agentModel = self.agentInfoModel;
    [self.navigationController pushViewController:cricleVC animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)initshare{
    NSString *url ;
    if ([self.curUser.memberType isEqualToString:@"CIRCLE_MASTER"]) {
        url = [NSString stringWithFormat:@"%@%@?shareCode=%@",H5BaseAddress,KcircleRegister,self.curUser.shareCode];
    }else{
        url = [NSString stringWithFormat:@"%@%@?shareCode=%@",H5BaseAddress,KcircleRegisterCopy,self.curUser.shareCode];
    }
    //    标题：用户名+邀请你加入+圈名
    //    内容：加入+圈名，一起快乐购彩！
    NSString *nickName = self.curUser.nickname==nil?[self.curUser.cardCode stringByReplacingCharactersInRange:NSMakeRange(2,4) withString:@"****"]:self.curUser.nickname;
    
    NSString *circleName = self.agentInfoModel.circleName == nil?[NSString stringWithFormat:@"@%@",self.agentInfoModel._id]:self.agentInfoModel.circleName;
    
    NSString *titleString = [NSString stringWithFormat:@"%@邀请你加入%@",nickName,circleName];
    
    NSString *textString = [NSString stringWithFormat:@"加入%@，一起快乐购彩！",circleName];
    
    
    
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[[NSBundle mainBundle] pathForResource:@"logo120@2x" ofType:@"png"]];
    [shareParams SSDKSetupShareParamsByText:textString
                                     images:imageArray
                                        url:[NSURL URLWithString:url]
                                      title:titleString
                                       type:SSDKContentTypeWebPage];
    
    [ShareSDK showShareActionSheet:nil
                             items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           //设置UI等操作
                           //Instagram、Line等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformSubTypeWechatSession)
                           {
                               
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                           
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           if (platformType == SSDKPlatformSubTypeWechatTimeline)
                           {
                        
                               
                           }
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           NSLog(@"%@",error);
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           if (userData != nil) {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                           }
                           break;
                       }
                       default:
                           break;
                   }
               }];
    
}

- (void)doWithCreateUI{
    CFLineChartView *LCView = [CFLineChartView lineChartViewWithFrame:CGRectMake(0, 40, CGRectGetWidth([UIScreen mainScreen].bounds) - 20, 220)];
     self.LCView = LCView;
    [self.viewRecentLy addSubview:self.LCView];
    
 
}

- (void)setupConditions{
    self.LCView.isShowLine = NO;
    self.LCView.isShowPoint = YES;
    self.LCView.isShowPillar = NO;
    self.LCView.isShowValue = YES;
    
    [self.LCView drawChartWithLineChartType:LineChartType_Curve pointType:PointType_Circel];
}

- (IBAction)actionRuzhang:(id)sender {
    RuZhangViewController *ruzhuangVC = [[RuZhangViewController alloc]init];
    ruzhuangVC.agentInfo = self.agentInfoModel;
    [self.navigationController pushViewController:ruzhuangVC animated:YES];
}
- (IBAction)actionMyFirend:(id)sender {
    MyCricleFriendVC *cricleFirendVC = [[MyCricleFriendVC alloc]init];
    [self.navigationController  pushViewController: cricleFirendVC animated:YES];
}
- (IBAction)actionYongjinBili:(id)sender{
    MyCricleYongJinVC *cricleFirendVC = [[MyCricleYongJinVC alloc]init];
    cricleFirendVC.agentModel = self.agentInfoModel;
    [self.navigationController  pushViewController: cricleFirendVC animated:YES];
    
}
- (IBAction)actionYongjinChaxun:(id)sender {
    YongjinListViewController *yongjinVC = [[YongjinListViewController alloc]init];
    yongjinVC.model = self.agentInfoModel;
    [self.navigationController  pushViewController:yongjinVC animated:YES];
}

@end
