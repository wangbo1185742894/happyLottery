//
//  MyRedPacketViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/27.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "MyRedPacketViewController.h"
#import "MyRedPacketTableViewCell.h"
#import "OpenRedPopView.h"
#import "RedPacketHisViewController.h"
#import "RedPacketGainModel.h"
#import "RedPacketSendModel.h"
#define AnimationDur 0.3

@interface MyRedPacketViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource,OpenRedPopViewDelegate,LotteryManagerDelegate>{
    
    NSMutableArray <RedPacketGainModel *> *listUseRedPacketArray;
    NSMutableArray <RedPacketSendModel *> *listUnUseRedPacketArray;
    NSString *packetId;
    RedPacketGainModel *redPacketGain;
    int page;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UIView *emptyView;


@end

@implementation MyRedPacketViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的红包";
    self.lotteryMan.delegate = self;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }else if ([Utility isIOS11After]) {
        self.automaticallyAdjustsScrollViewInsets = NO; // tableView 莫名其妙  contentOffset.y 成-64了  MMP
    }
    
    listUseRedPacketArray = [[NSMutableArray alloc]init];
    listUnUseRedPacketArray = [[NSMutableArray alloc]init];
    
    self.memberMan.delegate = self;
    if ( self.segment.selectedSegmentIndex == 0) {
        
       
        [self loadTrueNewData];
        self.tableView1.hidden = NO;
        self.tableView2.hidden = YES;
    }else  if (self.segment.selectedSegmentIndex == 1) {
        
        [self loadFalseNewData];
        self.tableView2.hidden = NO;
        self.tableView1.hidden = YES;
    }
    [self initRefresh1];
    [self initRefresh2];
    
}
    
-(void)bounsYouhua{
    RedPacketHisViewController *redPacket = [[RedPacketHisViewController alloc]init];
    [self.navigationController pushViewController:redPacket animated:YES];
}
-(void)initRefresh1{
    
    [UITableView refreshHelperWithScrollView:self.tableView1 target:self loadNewData:@selector(loadTrueNewData) loadMoreData:@selector(loadTrueMoreData) isBeginRefresh:NO];
}
-(void)initRefresh2{
   [UITableView refreshHelperWithScrollView:self.tableView2 target:self loadNewData:@selector(loadFalseNewData) loadMoreData:@selector(loadFalseMoreData) isBeginRefresh:NO];
}

- (IBAction)segmentClick:(id)sender {
    
    switch( self.segment.selectedSegmentIndex)
    {
        case 0:
            self.tableView1.hidden=NO;
            self.tableView2.hidden=YES;
            [listUnUseRedPacketArray removeAllObjects];
            [listUseRedPacketArray removeAllObjects];
            
            
            [self loadTrueNewData];
             break;
        case 1:
            self.tableView2.hidden=NO;
            self.tableView1.hidden=YES;
            [listUnUseRedPacketArray removeAllObjects];
            [listUseRedPacketArray removeAllObjects];
            
            
            [self loadFalseNewData];
             break;
        default:
            break;
    }
}

-(void)gotRedPacketHis:(NSArray *)redPacketInfo errorInfo:(NSString *)errMsg{
    
    if (redPacketInfo != nil) {
        
        if (self.segment.selectedSegmentIndex == 0) {
            [self.tableView1 tableViewEndRefreshCurPageCount:redPacketInfo.count];
        }else{
            [self.tableView2 tableViewEndRefreshCurPageCount:redPacketInfo.count];
        }
        
        UITableView *itemTableView;
        NSMutableArray *itemDataArray;
        if (self.segment.selectedSegmentIndex == 0) {
            itemTableView = self.tableView1;
            itemDataArray = listUseRedPacketArray;
        }else{
            itemTableView = self.tableView2;
            itemDataArray = listUnUseRedPacketArray;
        }
        
        if (page == 1) {
            [itemDataArray removeAllObjects];
        }
        if (self.segment.selectedSegmentIndex == 0) {
            for (NSDictionary *itemDic in redPacketInfo) {
                RedPacketGainModel *coupon = [[RedPacketGainModel alloc]initWith:itemDic];
                [itemDataArray addObject:coupon];
            }
        }else{
            for (NSDictionary *itemDic in redPacketInfo) {
                RedPacketSendModel *coupon = [[RedPacketSendModel alloc]initWith:itemDic];
                [itemDataArray addObject:coupon];
            }
        }
       
        self.tableView1.hidden = YES;
        self.tableView2.hidden = YES;
        itemTableView .hidden = NO;
        
        [itemTableView reloadData];
        
    }else{
        if (self.segment.selectedSegmentIndex == 0) {
            [self.tableView1 tableViewEndRefreshCurPageCount:redPacketInfo.count];
        }else{
            [self.tableView2 tableViewEndRefreshCurPageCount:redPacketInfo.count];
        }
        [self showPromptText:errMsg hideAfterDelay:1.7];
    }
}

-(void)openRedPacketSms:(NSDictionary *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    NSLog(@"redPacketInfo%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        RedPacketGainModel *red = [[RedPacketGainModel alloc]initWith:redPacketInfo];
        UIImageView *image = [[UIImageView alloc]initWithImage:[UIImage imageNamed:@"redpacket"]];
        
        image.frame  = CGRectMake(self.view.mj_w/2-105, 200, 210,294);
        [self.view addSubview:image];
        float width = image.mj_w/2;
        NSString *redPacketType = red.redPacketType;
        NSString *sourecs;
        if ([redPacketType isEqualToString:@"彩金红包"]) {
            sourecs = [NSString stringWithFormat:@"恭喜您获得了%@元",red.redPacketContent];
        } else if ([redPacketType isEqualToString:@"积分红包"]){
            sourecs = [NSString stringWithFormat:@"恭喜您获得了%@积分",red.redPacketContent];
        }else if ([redPacketType isEqualToString:@"优惠券红包"]){
            sourecs = [NSString stringWithFormat:@"恭喜您获得了%@张优惠券",red.redPacketContent];
        }
        [self rotation360repeatCount:2 view:image andHalf:width andCaijin:sourecs];
        page=1;
        [self loadTrueNewData];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)rotation360repeatCount:(int)repeatCount view:(UIView *)view andHalf:(float)width andCaijin:(NSString *)caijin{
    
    if (repeatCount == 0) {
        [UIView animateWithDuration:AnimationDur animations:^{
            view.mj_x += width;
            view.mj_w = 0;
            
        } completion:^(BOOL finished) {
            [view removeFromSuperview];
            OpenRedPopView *popView = [[OpenRedPopView alloc]initWithFrame:self.view.frame];
            popView.delegate = self;
            popView.labJiangjin.text =caijin;
            popView.alpha = 0.2;
            popView.layer.cornerRadius = 10;
            popView.layer.masksToBounds = YES;
            
            [self.view addSubview:popView];
            [UIView animateWithDuration:AnimationDur animations:^{
              
                popView.alpha = 1.0;
            }];
            
        }];
        
    }else{
        
        repeatCount --;
        [UIView animateWithDuration:AnimationDur animations:^{
            view.mj_x += width;
            view.mj_w = 0;
            
        } completion:^(BOOL finished) {
            [UIView animateWithDuration:AnimationDur animations:^{
                view.mj_x-= width;
                view.mj_w = 210;
            } completion:^(BOOL finished) {
                
                [self rotation360repeatCount:repeatCount view:view andHalf:width andCaijin:caijin];
            }];
        }];
    }
    
}

-(void)loadTrueNewData{
    page = 1;
      [self.lotteryMan getRedPacketHis:@{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(KpageSize)} andUrl:APIgainRedPacket];
}

-(void)loadFalseNewData{
    page = 1;
      [self.lotteryMan getRedPacketHis:@{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(KpageSize)} andUrl:APIsendOutRedPacket];
}

-(void)loadTrueMoreData{
    [self getRedPacketMoreData:YES];
}

-(void)loadFalseMoreData{
    [self getRedPacketMoreData:NO];
}

-(void)getRedPacketMoreData:(BOOL)isValid{
    page++;
    NSString *apiUrl;
    if (isValid == YES) {
        apiUrl = APIgainRedPacket;
    }else{
        apiUrl = APIsendOutRedPacket;
    }
    [self.lotteryMan getRedPacketHis:@{@"cardCode":self.curUser.cardCode,@"page":@(page),@"pageSize":@(KpageSize)} andUrl:apiUrl];

}

-(void)getRedPacketNewData:(NSString*)isValid{
    page = 1;
    NSDictionary *Info;
    @try {
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"isValid":isValid,
                 @"page":pagestr,
                 @"pageSize":@(KpageSize)
                 };
        
    } @catch (NSException *exception) {
        return;
    }
        [self.memberMan getRedPacketByStateSms:Info];

}

-(void)openRedPacketClient{
    NSDictionary *Info;
    @try {
        NSString *cardCode = redPacketGain._id;
        Info = @{@"id":cardCode
                 };
        
    } @catch (NSException *exception) {
       return;
    }
    [self.memberMan openRedPacketSms:Info];
}

#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView ==self.tableView1) {
        if (listUseRedPacketArray.count > 0) {
            return listUseRedPacketArray.count;
        }
    }else if (tableView ==self.tableView2){
        if (listUnUseRedPacketArray.count > 0) {
            return listUnUseRedPacketArray.count;
        }
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 111;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
    //自定义cell类
    MyRedPacketTableViewCell *cell ;
  
    //            REGISTER_CHANNEL("注册渠道"),
    //            LOGIN_CHANNEL("登录渠道"),
    //            SIGN_IN_CHANNEL("签到渠道"),
    //            RECHARGE_CHANNEL("充值渠道"),
    //            CONSUME_CHANNEL("消费渠道"),
    //            WIN_CHANNEL("中奖渠道");

    if (tableView ==self.tableView1) {
        
        static NSString *CellIdentifier = @"TabViewCell1";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRedPacketTableViewCell" owner:self options:nil] lastObject];
        }
        if (listUseRedPacketArray.count > 0) {
          RedPacketGainModel * redPacket = listUseRedPacketArray[indexPath.row];
             NSString *redPacketStatus = redPacket.trRedPacketStatus;
            
            
//            FOLLOW_CHANNEL("跟单红包"),
//
//            CIRCLE_CHANNEL("圈子红包");
            if ([redPacket.redPacketType isEqualToString:@"FOLLOW_CHANNEL"] || [redPacket.redPacketType isEqualToString:@"CIRCLE_CHANNEL"]) {
                
            }else{
                cell.sourceLab.text = [NSString stringWithFormat:@"来源：%@",redPacket.activityName];
            }
            if ([redPacketStatus isEqualToString:@"锁定"]) {
                cell.packetImage.image = [UIImage imageNamed:@"lockredpacket"];
            } else  if ([redPacketStatus isEqualToString:@"解锁"]) {
                cell.packetImage.image = [UIImage imageNamed:@"unlockredpacket"];
            }
            
           if ([redPacketStatus isEqualToString:@"领取"]) {
                cell.endImage.image = [UIImage imageNamed:@"yilingqu"];
                cell.packetImage.image = [UIImage imageNamed:@""];
            if ([redPacket.redPacketType isEqualToString:@"COUPON"]) {
                    cell.labRedPacketCost.text = [NSString stringWithFormat:@""];
                    cell.packetImage.image = [UIImage imageNamed:@"优惠券"];
            }else if([redPacket.redPacketType isEqualToString:@"INTEGRAL"]){
                cell.labRedPacketCost.adjustsFontSizeToFitWidth = YES;
                cell.labRedPacketCost.text = [NSString stringWithFormat:@"%@积分",redPacket.redPacketContent];
            }else{
                   cell.labRedPacketCost.adjustsFontSizeToFitWidth = YES;
                    cell.labRedPacketCost.text = [NSString stringWithFormat:@"￥%@",redPacket.redPacketContent];
               }
                   
              
            }else  if ([redPacketStatus isEqualToString:@"失效"]) {
                cell.endImage.image = [UIImage imageNamed:@"yiguoqi"];
                     cell.packetImage.image = [UIImage imageNamed:@"unlockredpacket"];
            }
         
            cell.nameLab.text = redPacket._description;
            
            NSString *redPacketChannel =redPacket.redPacketChannel;
            NSString *sourecs;
//            if ([redPacketChannel isEqualToString:@"注册渠道"]) {
//                sourecs = @"来源： 系统注册赠送";
//            } else if ([redPacketChannel isEqualToString:@"登录渠道"]){
//                sourecs = @"来源： 系统登录赠送";
//            }else if ([redPacketChannel isEqualToString:@"签到渠道"]){
//                sourecs = @"来源： 系统签到赠送";
//            }else if ([redPacketChannel isEqualToString:@"充值渠道"]){
//                sourecs = @"来源： 系统充值赠送";
//            }else if ([redPacketChannel isEqualToString:@"消费渠道"]){
//                sourecs = @"来源： 系统消费赠送";
//            }else if ([redPacketChannel isEqualToString:@"中奖渠道"]){
//                sourecs = @"来源： 系统中奖赠送";
//            }else if ([redPacketChannel isEqualToString:@"系统赠送"]){
//                sourecs = @"来源： 系统赠送";
//            }
        
            NSString *date = @"";
            
            if (redPacket.endValidTime.length != 0) {
                date=[redPacket.endValidTime substringWithRange:NSMakeRange(0,10)];
            }
            
            cell.endTimeLab.text = [NSString stringWithFormat:@"有效期至：%@",date];
            if (0) {
                cell.day.text = [self getTimesFromHours:redPacket.endValidTime];
            } else {
                if([redPacketStatus isEqualToString:@"领取"]){
                    cell.day.text = @"";
                    cell.endTimeLab.text = @"";
                }else{
                    const long long  dayInteger = [self getDifferenceByDate:redPacket.endValidTime];
                    //            const long long  dayInteger = [self getDifferenceByDate:@"2018-01-26 09:24:57"];
                    NSNumber *longlongNumber = [NSNumber numberWithLongLong:dayInteger];
                    NSString *time = @"";
                    if (redPacket.endValidTime .length != 0) {
                        time=[redPacket.endValidTime substringFromIndex:10];
                    }
                    
                    NSString *daystr = [longlongNumber stringValue];
                    if (dayInteger<=0) {
                        cell.day.text=[NSString stringWithFormat:@"截止%@过期",time];
                    }else{
                        cell.day.text=[NSString stringWithFormat:@"还有%@天过期",daystr];
                    }
                }
              
            }
        }
      
    }else if (tableView ==self.tableView2){
        static NSString *CellIdentifier = @"TabViewCell2";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRedPacketTableViewCell" owner:self options:nil] lastObject];
        }
        if (listUnUseRedPacketArray.count > 0) {
          RedPacketSendModel * redPacket = listUnUseRedPacketArray[indexPath.row];
             NSString *redPacketStatus = redPacket.trCompleteStatus;
            cell.nameLab.text = redPacket.trPacketChannel;
            if ([redPacket.refundAmount integerValue] != 0) {
                     cell.labBackCost.text = [NSString  stringWithFormat:@"已退款%@元",redPacket.refundAmount];
            }else{
                cell.labBackCost.text = @"";
            }
            
            if ([redPacket.openSize integerValue] == [redPacket.totalCount integerValue]) {
                cell.endImage.image = [UIImage imageNamed:@"yilingwan"];
                cell.packetImage.image = [UIImage imageNamed:@""];
            }
       
            cell.sourceLab.text = [NSString stringWithFormat:@"已领取%@/%@",redPacket.openSize ,redPacket.totalCount];
            cell.endTimeLab.text = redPacket.createTime;
            
            cell.labRedPacketCost.text = [NSString stringWithFormat:@"￥%@",redPacket.amount];
            
            cell.endImage.hidden = NO;
            cell.packetImage.image = [UIImage imageNamed:@""];
        }
    }
    cell.sourceLab.adjustsFontSizeToFitWidth = YES;
    return cell;
}


#pragma UITableViewDelegate methods
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    if (tableView == self.tableView1) {
     
        redPacketGain = listUseRedPacketArray[indexPath.row];
        if ([redPacketGain.trRedPacketStatus isEqualToString:@"解锁"]){
            if(redPacketGain){
                [self openRedPacketClient];
            }
        }
    }
}

- (NSInteger)getDifferenceByDate:(NSString *)date {
    //获得当前时间
    NSDate *now = [NSDate date];
    //实例化一个NSDateFormatter对象
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    //设定时间格式
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [dateFormatter dateFromString:date];
    NSCalendar *gregorian = [[NSCalendar alloc] initWithCalendarIdentifier:NSGregorianCalendar];
    unsigned int unitFlags = NSDayCalendarUnit;
    NSDateComponents *comps = [gregorian components:unitFlags fromDate:now  toDate:oldDate  options:0];
//    NSInteger era = [comps day];
//    NSLog(@"era:%d",era);
    return [comps day];
}

- (NSString *)getTimesFromHours:(NSString *)date {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm:ss"];
    NSDate *oldDate = [dateFormatter dateFromString:date];
    NSCalendar *calendar = [NSCalendar currentCalendar];
    
    NSDateComponents *components = [calendar components:NSCalendarUnitSecond fromDate:[NSDate date] toDate:oldDate options:0];
    if (components.second <60) {
        return [NSString stringWithFormat:@"还有%zd秒过期",components.second];
    }
    
    components = [calendar components:NSCalendarUnitMinute fromDate:[NSDate date] toDate:oldDate options:0];
    if (components.minute <60) {
        return [NSString stringWithFormat:@"还有%zd分钟过期",components.minute];
    }
    components = [calendar components:NSCalendarUnitHour fromDate:[NSDate date] toDate:oldDate options:0];
    if (components.hour <24) {
        return [NSString stringWithFormat:@"还有%zd小时过期",components.hour];
    }
    components = [calendar components:NSCalendarUnitDay fromDate:[NSDate date] toDate:oldDate options:0];
    return [NSString stringWithFormat:@"还有%zd天过期",components.day];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}


@end
