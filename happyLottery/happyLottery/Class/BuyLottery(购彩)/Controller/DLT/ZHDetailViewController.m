//
//  ZHDetailViewController.m
//  Lottery
//
//  Created by 关阿龙 on 15/10/14.
//  Copyright © 2015年 AMP. All rights reserved.
//

#import "ZHDetailViewController.h"
#import "LotteryManager.h"
#import "LotteryBetObj.h"
#import "BetCalculationManage.h"
#import "WinInfoView.h"
//zwl
#import "AppDelegate.h"
#import <ShareSDK/ShareSDK.h>
#import "DLTPlayViewController.h"
#import "ZHTableViewCell.h"
#import "Lottery.h"
#import "Utility.h"
#import "DLTChaseSchemeDetail.h"
@interface ZHDetailViewController ()<LotteryManagerDelegate,UIActionSheetDelegate,UITableViewDataSource,UITableViewDelegate>{
    
    __weak IBOutlet NSLayoutConstraint *topHightConstant;
    __weak IBOutlet UILabel *playName;    //任选几
    __weak IBOutlet UILabel *results;     //结果 2/3未中奖
    __weak IBOutlet UILabel *playnumber;  //选号
    __weak IBOutlet UILabel *totleMoney;  //奖金
    __weak IBOutlet UILabel *beginnum;    //开始期号
    __weak IBOutlet UILabel *playMoner;   //投注金额
    __weak IBOutlet UILabel *zhqishu;     // 追号期数
    __weak IBOutlet UILabel *beginTime;   //开始时间
    __weak IBOutlet UILabel *zhID;        //追号方案Number
    __weak IBOutlet UILabel *winStop;    //是否中奖停追
    
    __weak IBOutlet NSLayoutConstraint *topViewHeight;

    __weak IBOutlet NSLayoutConstraint *numberWidth;
    __weak IBOutlet UITableView *orderTableView;
    
    UINib *cellNib;
    
    __weak IBOutlet UIView *controlVC;
    __weak IBOutlet UIButton *GoOn;//继续购买
    LotteryManager *lotteryMan;
    
    NSArray *_allLotter;//所有的彩种
    
    NSDictionary * date;
    
    IBOutletCollection(NSLayoutConstraint) NSArray *sepHeightArr;
}
@property (nonatomic , strong) NSMutableArray * ordersArray;
@property (nonatomic) int  sourcePage;
@property(nonatomic,strong)DLTChaseSchemeDetail *schemeDetail;
@property (nonatomic, strong) Lottery *lottery;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *numberViewWidth;
- (IBAction)actionStopChaseScheme:(UIButton *)sender;
@property (weak, nonatomic) IBOutlet UIButton *stopChaseBtn;

@end

@implementation ZHDetailViewController
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
  
}
- (void)viewDidLoad {
    [super viewDidLoad];
    /*zwl*/
    if ([self.order.chaseStatus isEqualToString:@"已取消"]) {
        self.stopChaseBtn.enabled = NO;
    }else{
        self.stopChaseBtn.enabled = YES;
    }
    self.title = ZHDetailPageTitle;
    
    self.lotteryMan.delegate = self;
    [self showLoadingViewWithText:TextLoading];
    for (NSLayoutConstraint *sepHeight in sepHeightArr) {
        sepHeight.constant = SEPHEIGHT;
    }
    _allLotter = [lotteryMan getAllLottery];
    self.view.backgroundColor = [UIColor whiteColor];
    [self initLottyBetObj:nil];
//
    totleMoney.adjustsFontSizeToFitWidth = YES;
    orderTableView.separatorStyle = UITableViewCellSeparatorStyleNone;

    self.lottery = [[Lottery alloc] init];
    NSArray *typeAr = [lotteryMan getAllLottery];
    self.lottery = typeAr.firstObject;
    
    
    //追号订单详情
    [self.lotteryMan getChaseDetailForApp:@{@"chaseSchemeNo":_order.chaseSchemeNo}];

//     [self addShareRighButton];
    orderTableView.tableFooterView = [[UIView alloc] init];
    //下拉刷新
    orderTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        _sourcePage = 0;
        //    [_ordersArray removeAllObjects];
//        [lotteryMan getZJOrderDetail:_order];
        [orderTableView.mj_header endRefreshing];
    }];
    
    if ([_order.name isEqualToString:@"大乐透"]) {
        winStop.hidden = YES;
        topViewHeight.constant = 90;
    }else{
        topViewHeight.constant = 110;
        winStop.hidden = NO;
    }
    [self showLoadingViewWithText:TextLoading];

}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

//10.12
-(void)gotChaseDetailForApp:(NSDictionary *)info errorMsg:(NSString *)msg{
    [self hideLoadingView];
    self.schemeDetail = [[DLTChaseSchemeDetail alloc]initWith:info];
    
    if (nil == _ordersArray) {
        self.ordersArray = [NSMutableArray array];
    }
    if (self.sourcePage == 0) {
        [_ordersArray removeAllObjects];
    }
    
    if (info && info.count != 0) {
        for (NSDictionary *itemDic in info[@"tempList"][@"rows"]) {
            OrderProfile *profile = [[OrderProfile alloc]initWith:itemDic];
            [_ordersArray addObject:profile];
        }
        
        if (orderTableView.hidden) {
            orderTableView.hidden = NO;
        }
        
    }else{
        
        if (nil == info || info.count ==0) {
            if(_ordersArray.count != 0){
                
            }else{
                orderTableView.hidden = YES;
                [self showPromptText:TextNoHistory hideAfterDelay:1];
            }
        }
    }
    [orderTableView reloadData];
}

#pragma mark --  UITableViewDataSource
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 1;
}
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.ordersArray.count;
}
-(ZHTableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString * cellIdentify = @"orderCell";
    ZHTableViewCell *cell = (ZHTableViewCell*)[tableView dequeueReusableCellWithIdentifier: cellIdentify];
    if (!cell) {
        if (cellNib == nil) {
            cellNib = [UINib nibWithNibName: @"ZHTableViewCell" bundle: nil];
        }
        cell = (ZHTableViewCell*)([cellNib instantiateWithOwner: nil options: 0][0]);
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    
    [cell setAccessoryType:UITableViewCellAccessoryNone];
    /* 计算累计投注 */
    NSMutableArray *datearray = [[NSMutableArray alloc]init];
    int number = 0;
    for (int i= 0; i<_ordersArray.count; i++) {
        //当期投入
        NSString * string = [_ordersArray[i] valueForKey:@"subscription"];//当期投入
        NSString * paystatus = [_ordersArray[i] valueForKey:@"payStatus"];//支付状态
        
        NSString *stry = [NSString stringWithFormat:@"%@",string];
        int  money;
        if ([paystatus isEqualToString:@"0"] || [paystatus isEqualToString:@"2"]) {
            money = 0;
        }else{
            money = [stry intValue];
        }
        number +=money;
        datearray[i] = [NSString stringWithFormat:@"%d",number];
    }

    OrderProfile * order = _ordersArray[indexPath.row];
    
    [cell orderInfoShow1:order index:_order.totalCatch leiji:datearray[indexPath.row]];
    
    return cell;
}
-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

- ( void )tableView:( UITableView *)tableView willDisplayCell :( UITableViewCell *)cell forRowAtIndexPath :( NSIndexPath *)indexPath
{
//    if (indexPath.row %2 ) {
//        cell .backgroundColor = [ UIColor whiteColor ];
//    }else
//    {
//        cell .backgroundColor = [ UIColor groupTableViewBackgroundColor ];
////        cell.alpha = 0.6;
//    }
    
     cell .backgroundColor = [ UIColor whiteColor ];
}

- (void)initLottyBetObj:(NSArray *)orderDetailInfo{

    playName.text = [NSString stringWithFormat:@"超级大乐透"];
    

    if ([_order.catchResult isEqualToString:@"已中奖"]) {
        results.textColor = TextCharColor;
    }
   
    
//    int balance = [_order.bonus intValue];
//    if(balance > 0)
//    {
//        results.text = [NSString stringWithFormat:@"%@/%@%@",_order.catchIndex,_order.totalCatch,@"已中奖"];
//        results.textColor = TextCharColor;
//        
//    }
//    else
//    {
        results.text = [NSString stringWithFormat:@"%@/%@%@",_order.catchIndex,_order.totalCatch,_order.chaseStatus];
//    }
    
   
    results.adjustsFontSizeToFitWidth = YES;
//    results.text = [NSString stringWithFormat:@"%@/%@%@",_order.catchIndex,_order.totalCatch,_order.catchResult];
    
    //选号显示
    
//   NSString *test = @"12 22#12 34 34 23+23 23#23 54 45; 12 22#12 34 54 34 23+23 23 45 56#23 54 45; 12 22#12 34 54 34 23+23 25 56#54 45;22#14 54 34 23+23 23 56#23";
    id ZHlotteryNumber ;
    if([_order.name isEqualToString:@"11选5"]||[_order.name isEqualToString:@"陕11选5"])
    {
        ZHlotteryNumber = _order.ZHlotteryNumberDesc;
        ZHlotteryNumber = [ZHlotteryNumber stringByReplacingOccurrencesOfString:@" " withString:@","];
    }else{
        ZHlotteryNumber = [self getChaseContent];
    }
    if (ZHlotteryNumber) {
        if ([ZHlotteryNumber isKindOfClass:[NSString class]]) {
            if ([ZHlotteryNumber isEqualToString:@"null"] || [ZHlotteryNumber isEqualToString:@"(null)"]) {
                playnumber.text = @"";
            }else
            {
                playnumber.text  = ZHlotteryNumber;
                NSMutableString*mStr = [ZHlotteryNumber mutableCopy];
                
                NSRange range = [mStr rangeOfString:@"胆:"];
                if (range.length!=0) {
                    
                [mStr replaceCharactersInRange:range withString:@""];
                    
                    
                }
                NSRange range1 = [mStr rangeOfString:@" 拖:"];
                if (range1.length!=0) {
                    [mStr replaceCharactersInRange:range1 withString:@"#"];
                    
                }
                NSRange range3 = [mStr rangeOfString:@",拖:"];
                if (range3.length!=0) {
                  [mStr replaceCharactersInRange:range3 withString:@"#"];
                    
                }
 
                NSArray*zhuNumber = [mStr  componentsSeparatedByString:@";"];
//                topHightConstant.constant = 28*zhuNumber.count;
                NSInteger hight = 0;
                NSArray*zhuArray;
                NSInteger  number  = 0;

                for (int zhu = 0; zhu < zhuNumber.count; zhu++) {
                    zhuArray = [zhuNumber[zhu] componentsSeparatedByString:@"+"];
                    hight = hight + zhuArray.count;
                    
                   
                    
                   
                    for (int i = 0; i<zhuArray.count; i++) {
                        
                        NSString *str = zhuArray[i];
                        

                        NSInteger num = [self NumberThis:@"#" inTargetStr:str];
                        if (num>=2||[_order.playType isEqualToString:@"14"] ||[_order.playType isEqualToString:@"22"]||[_order.playType isEqualToString:@"23"]) {

                            NSMutableString* mstr  = [str mutableCopy];
                            if ([_order.playType isEqualToString:@"14"]||[_order.playType isEqualToString:@"22"]) {
                                [mstr insertString:@"万:," atIndex:0];
                                //                            [mstr stringByReplacingOccurrencesOfString:@"#" withString:@",百:,"];

                                NSRange first = [mstr rangeOfString:@"#"];
                                [mstr replaceCharactersInRange:first withString:@",千:,"];
                                str = mstr;
                            }else if(num ==2 || [_order.playType isEqualToString:@"23"]){

                                [mstr insertString:@"万:," atIndex:0];
                                NSRange first = [mstr rangeOfString:@"#"];
                                [mstr replaceCharactersInRange:first withString:@",千:,"];
                                NSRange seconed = [mstr rangeOfString:@"#"];
                                [mstr replaceCharactersInRange:seconed withString:@",百:,"];
                                str = mstr;

                            }
                        }else{
//                        str = [str stringByReplacingOccurrencesOfString:@"#" withString:@","];

                        }
                        
                        UIImage*backImage = [UIImage imageNamed:@"redBall.png"];
                        if (i == 1) {
                            backImage = [UIImage imageNamed: @"blueBall"];
                        }
                        
                        NSArray*danArray = [str componentsSeparatedByString:@"#"];
                        if (danArray.count == 2) {
                            for (int j = 0; j<danArray.count; j++) {
                                NSArray*array = [danArray[j] componentsSeparatedByString:@","];
                                
                                NSMutableArray*arr = [[NSMutableArray alloc]init];
                                for (NSString *item in array) {
                                    if (![item isEqualToString:@""]) {
                                        [arr addObject:item];
                                    }
                                }
                            
                                if (j==0) {
                                    
                                    
                                    for (int k = 0; k<arr.count; k++) {
                                        
                                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                        button.userInteractionEnabled = NO;
                                        button.titleLabel.numberOfLines = 0;
                                        button.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        
                                        
                                        if (![arr[k] isEqualToString:@""]) {
                                            
                                            button.frame = CGRectMake(k*27, 28*(hight - zhuArray.count + i)+zhu*5, 27, 27);
                                            NSLog(@"胆\n%@",arr[k]);
                                            button.titleLabel.font = [UIFont systemFontOfSize:11];
                                            [button setTitle:[NSString stringWithFormat:@"胆\n%@",arr[k]] forState:UIControlStateNormal];
                                            [button setBackgroundImage:backImage forState:UIControlStateNormal];
//                                            button.layer.cornerRadius = 13;
//                                            button.layer.masksToBounds = YES;
                                            [self.numberBackground addSubview:button];
                                        }
                                        
                                    }
                                }else{
                                    NSArray*array = [danArray[0] componentsSeparatedByString:@","];
                                    
                                    NSMutableArray*arra = [[NSMutableArray alloc]init];
                                    for (NSString *item in array) {
                                        if (![item isEqualToString:@""]) {
                                            [arra addObject:item];
                                        }
                                    }
                                   
                                    
                                    for (int k = 0; k<arr.count; k++) {
                                        
                                        UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                        button.userInteractionEnabled = NO;
                                        button.titleLabel.numberOfLines = 0;
                                        button.titleLabel.textAlignment = NSTextAlignmentCenter;
                                        if (![arr[k] isEqualToString:@""]) {
                                            
                                            button.frame = CGRectMake((arra.count+k)*27, 28*(hight - zhuArray.count + i)+zhu*5, 27, 27);
                                            NSLog(@"n%@",arr[k]);
                                            [button setTitle:[NSString stringWithFormat:@"%@",arr[k]] forState:UIControlStateNormal];
                                            [button setBackgroundImage:backImage forState:UIControlStateNormal];
//                                            button.layer.cornerRadius = 13;
//                                            button.layer.masksToBounds = YES;
                                            [self.numberBackground addSubview:button];
                                        }
                                        if (number < arra.count +k) {
                                             number = arra.count + k;
                                        }
                                       
                                    }
                                
                                    
                                }
                            }
                        }else{
                            for (int j = 0; j<danArray.count; j++) {
                                NSArray*arr = [danArray[j] componentsSeparatedByString:@","];
                            for (int k = 0; k<arr.count; k++) {
                                
                                UIButton *button = [UIButton buttonWithType:UIButtonTypeCustom];
                                button.userInteractionEnabled = NO;
                                button.titleLabel.numberOfLines = 0;
                                if (![arr[k] isEqualToString:@""]) {
                                    
                                    button.frame = CGRectMake(k*27, 28*(hight - zhuArray.count + i)+zhu*5, 27, 27);
                                    NSLog(@"n%@",arr[k]);
                                    [button setTitle:[NSString stringWithFormat:@"%@",arr[k]] forState:UIControlStateNormal];
                                    [button setBackgroundImage:backImage forState:UIControlStateNormal];
//                                    button.layer.cornerRadius = 13;
//                                    button.layer.masksToBounds = YES;
                                    [self.numberBackground addSubview:button];
                                }
                                if (number <k) {
                                    number = k;
                                }
                            }
                        
                        }
                        
                    }
                    }
                }
                
                if (28*hight + zhuNumber.count*5>120) {
                    topHightConstant.constant = 120;
                    self.numberContentHight.constant = 28*hight + zhuNumber.count*5;
                }else{
                topHightConstant.constant = 28*hight + zhuNumber.count*5;
                    self.numberContentHight.constant = 28*hight + zhuNumber.count*5;
                }
                
//                self.numberViewWidth.constant = 500;
                if (number >=8) {
                    self.numberViewWidth.constant = number * 30;
                }else{
                self.numberViewWidth.constant = 7 * 30;
                }
        }
    }
    }

    if ([_order.bonus isEqualToString:@"(null)"]) {
        
        totleMoney.text = [NSString stringWithFormat:@""];
        numberWidth.constant = self.view.mj_w - 5;
    }else
    {
      
        NSString * balance;
        //格式化
        if ([_order.bonus doubleValue]  == 0.0) {
            numberWidth.constant = self.view.mj_w - 5;
            balance = @"";
        }else{
         balance = [NSString stringWithFormat:@"奖金: %.2f元",[_order.bonus doubleValue]];
            
              numberWidth.constant = self.view.mj_w - balance.length*9;
        }
        totleMoney.text = balance;
//        totleMoney.text = [NSString stringWithFormat:@"奖金：%@元",_order.bonus];
    }
    beginnum.text = [NSString stringWithFormat:@"开始期号：%@",_order.beginIssue];
    //订单时间
//    NSString * starttime = [NSString stringWithFormat:@"%@",_order.createTime];
//    NSInteger lenth = starttime.length;
//    beginTime.text = [starttime substringToIndex:lenth-2];
     beginTime.text = [NSString stringWithFormat:@"%@",_order.createTime];
    
    if ([_order.orderBonus isEqualToString:@"<null>"]) {
        playMoner.text = [NSString stringWithFormat:@"投注金额：%@元",@"0"];
    }
    else
    {
        playMoner.text = [NSString stringWithFormat:@"投注金额：%@元",_order.orderBonus];
    }
    
    zhqishu.text = [NSString stringWithFormat:@"追期期数：%@期",_order.totalCatch];
//    zhID.text = [NSString stringWithFormat:@"%@",_order.catchSchemeId];
    if(_order){
    
    }
    if ([_order.winStopStatus intValue] == 0) {
        winStop.text = @"中奖停追：否";
    }
    else
    {
        winStop.text = @"中奖停追：是";
    }
}

-(NSInteger)NumberThis:(NSString*)test inTargetStr:(NSString *)targetStr{

    NSInteger number = 0;
    for (int i = 0; i<targetStr.length; i++) {
        NSString *temp = [targetStr substringWithRange:NSMakeRange(i, 1)];
        if ([temp isEqualToString:test]) {
            number ++;
        }
    }
    return number;
}

- (IBAction)toPlayGoon:(UIButton *)sender {
    [[NSNotificationCenter defaultCenter]postNotificationName:@"NSNotificationJumpToPlayVC" object:@"DLT"];
    [self.navigationController popToRootViewControllerAnimated:YES];
}

- (void) shareRightButtonAction{
}
// iphone 截屏方法
- (UIImage *)imageFromView:(UIView *)theView
{
//        UIGraphicsBeginImageContext(theView.bounds.size);
//        CGContextRef context = UIGraphicsGetCurrentContext();
//        [theView.layer renderInContext: context];
//        UIImage *theImage = UIGraphicsGetImageFromCurrentImageContext();
//        UIGraphicsEndImageContext();
    
    UIGraphicsBeginImageContextWithOptions(CGSizeMake(KscreenWidth, KscreenHeight), YES, 0);     //设置截屏大小
    [[theView layer] renderInContext:UIGraphicsGetCurrentContext()];
    UIImage *viewImage = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    CGImageRef imageRef = viewImage.CGImage;
    //    CGRect rect = CGRectMake(166, 211, 426, 320);//这里可以设置想要截图的区域
    CGRect rect = CGRectMake(0, 0, KscreenWidth*2, KscreenHeight*2);//这里可以设置想要截图的区域
    CGImageRef imageRefRect =CGImageCreateWithImageInRect(imageRef, rect);
    UIImage *sendImage = [[UIImage alloc] initWithCGImage:imageRefRect];
    
    return sendImage;
}


// 手动停追
- (IBAction)actionStopChaseScheme:(UIButton *)sender {
    
    ZLAlertView *alert = [[ZLAlertView alloc] initWithTitle:@"放弃追号" message:@"确认后将停止追号，并且不可继续"];
    [alert addBtnTitle:@"确定" action:^{
        [self cancelChase];
    }];
    [alert addBtnTitle:@"取消" action:^{
        
    }];
    
    [alert showAlertWithSender:self];
    
}

- (void)cancelChase{
    NSDictionary *dic = @{@"chaseSchemeNo":_order.chaseSchemeNo};
    [self.lotteryMan getStopChaseScheme:dic];
}

- (void)gotStopChaseScheme:(BOOL)isSuccess errorMsg:(NSString *)errorMsg{
    
    if (isSuccess == YES) {
        [self showPromptText:@"停追成功" hideAfterDelay:1.7];
        
    }else{
        [self showPromptText:errorMsg hideAfterDelay:1.7];
    }
}

-(NSString *)getChaseContent{
    NSArray *chaseList = [Utility objFromJson:self.order.catchContent];
    NSMutableString *chaseContent = [[NSMutableString alloc]initWithCapacity:0];
    for (NSDictionary *itemDic in chaseList) {
        
        NSArray *blueList = itemDic[@"blueList"];
        NSArray *blueDanList = itemDic[@"blueDanList"];
        NSArray *redList = itemDic[@"redList"];
        NSArray *redDanList = itemDic[@"redDanList"];
        
        
        if (redDanList.count > 0) {
            
            [chaseContent appendString:[redDanList componentsJoinedByString:@","]];
            [chaseContent appendString:@"#"];
        }
        [chaseContent appendString:[redList componentsJoinedByString:@","]];
        [chaseContent appendString:@"+"];
        
        if (blueDanList.count > 0) {
            
            [chaseContent appendString:[blueDanList componentsJoinedByString:@","]];
            [chaseContent appendString:@"#"];
        }
        [chaseContent appendString:[blueList componentsJoinedByString:@","]];
        [chaseContent appendString:@";"];
    }
    return chaseContent;
}

@end
