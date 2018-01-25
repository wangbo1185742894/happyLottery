//
//  MyRedPacketViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/27.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "MyRedPacketViewController.h"
#import "MyRedPacketTableViewCell.h"
#import "RedPacket.h"
#import "OpenRedPopView.h"
#define AnimationDur 0.3

@interface MyRedPacketViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource,OpenRedPopViewDelegate>{
    
    NSMutableArray *listUseRedPacketArray;
    NSMutableArray *listUnUseRedPacketArray;
    NSString *packetId;
    RedPacket *r;
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
    self.memberMan.delegate = self;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    listUseRedPacketArray = [[NSMutableArray alloc]init];
    listUnUseRedPacketArray = [[NSMutableArray alloc]init];
    r = [[RedPacket alloc]init];
   // [self getRedPacketByStateClient:@"true"];
    page=1;
    if ( self.segment.selectedSegmentIndex == 0) {
        
        [self initRefresh1];
        
        self.tableView1.hidden = NO;
        self.tableView2.hidden = YES;
    }else  if (self.segment.selectedSegmentIndex == 1) {
        
        [self initRefresh2];
        self.tableView2.hidden = NO;
        self.tableView1.hidden = YES;
    }
}
-(void)initRefresh1{
    __weak typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.tableView1.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [weakSelf getRedPacketByStateClient:@"true"];
        [self.tableView1.mj_header endRefreshing];
    }];
    self.tableView1.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        ///[self.tableView1.mj_footer beginRefreshing];
        [weakSelf getRedPacketByStateClient:@"true"];
        
    }];
    // 马上进入刷新状态
    [self.tableView1.mj_header beginRefreshing];
}
-(void)initRefresh2{
    __weak typeof(self) weakSelf = self;
    
    self.tableView2.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [weakSelf getRedPacketByStateClient:@"false"];
        [self.tableView2.mj_header endRefreshing];
    }];
    self.tableView2.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        //[self.tableView2.mj_header beginRefreshing];
        [weakSelf getRedPacketByStateClient:@"false"];
        
    }];
    
    // 马上进入刷新状态
    
    [self.tableView2.mj_header beginRefreshing];
}

- (IBAction)segmentClick:(id)sender {
    
    switch( self.segment.selectedSegmentIndex)
    {
        case 0:
            self.tableView1.hidden=NO;
            self.tableView2.hidden=YES;
            [listUnUseRedPacketArray removeAllObjects];
            [listUseRedPacketArray removeAllObjects];
            page=1;
            
            [self initRefresh1];
             break;
        case 1:
            self.tableView2.hidden=NO;
            self.tableView1.hidden=YES;
            [listUnUseRedPacketArray removeAllObjects];
            [listUseRedPacketArray removeAllObjects];
            page=1;
            
            [self initRefresh2];
             break;
        default:
            break;
    }
}

-(void)getRedPacketByStateSms:(NSArray *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    
    NSLog(@"redPacketInfo%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
       
        NSEnumerator *enumerator = [redPacketInfo objectEnumerator];
        id object;
        if ((object = [enumerator nextObject]) != nil) {
            NSArray *array = redPacketInfo;
           
            
            if (self.segment.selectedSegmentIndex == 0) {
          
                if (page == 1) {
                    [listUseRedPacketArray removeAllObjects];
                    if (array.count>0) {
                        for (int i=0; i<array.count; i++) {
                            
                             RedPacket *redPacket = [[RedPacket alloc]initWith:array[i]];
                            [listUseRedPacketArray addObject:redPacket];

                        }
                        [self.tableView1.mj_footer endRefreshing];
                        self.tableView1.hidden = NO;
                        self.tableView2.hidden = YES;
                        [self.tableView1 reloadData];
                       self.emptyView.hidden=YES;
                    }else{
                        self.emptyView.hidden=NO;
                        self.tableView2.hidden = YES;
                        self.tableView1.hidden = YES;
                    }
                }else{
                    if (array.count>0) {
                        for (int i=0; i<array.count; i++) {
                            RedPacket *redPacket = [[RedPacket alloc]initWith:array[i]];
                            [listUseRedPacketArray addObject:redPacket];
                        }
                        if (listUseRedPacketArray.count>0) {
                            self.tableView1.hidden = NO;
                            self.tableView2.hidden = YES;
                            [self.tableView1 reloadData];
                            [self.tableView1.mj_footer endRefreshing];
                        }else{
                            [self.tableView1.mj_footer endRefreshingWithNoMoreData];
                            
                        }
                        
                    }
                }
            }else if(self.segment.selectedSegmentIndex==1){
      
                if (page == 1) {
                    [listUnUseRedPacketArray removeAllObjects];
                    if (array.count>0) {
                        for (int i=0; i<array.count; i++) {
                            
                             RedPacket *redPacket = [[RedPacket alloc]initWith:array[i]];
                            [listUnUseRedPacketArray addObject:redPacket];
                       
                            
                        }
                        self.tableView2.hidden = NO;
                        self.tableView1.hidden = YES;
                        [self.tableView2 reloadData];
                        self.emptyView.hidden=YES;
                        [self.tableView2.mj_footer endRefreshing];
                    } else{
                        
                        self.emptyView.hidden=NO;
                        self.tableView2.hidden = YES;
                        self.tableView1.hidden = YES;
                    }
                }else{
                    if (array.count>0) {
                        //
                        for (int i=0; i<array.count; i++) {
                            
                             RedPacket *redPacket = [[RedPacket alloc]initWith:array[i]];
                            [listUnUseRedPacketArray addObject:redPacket];
                         
                            
                        }
                        if (listUnUseRedPacketArray.count>0) {
                            self.tableView2.hidden = NO;
                            self.tableView1.hidden = YES;
                            [self.tableView2 reloadData];
                            [self.tableView2.mj_footer endRefreshing];
                        }else{
                            [self.tableView2.mj_footer endRefreshingWithNoMoreData];
                            
                        }
                        
                    }
                }
            }
            
        }else{
            if (page == 1){
                
                self.emptyView.hidden=NO;
                self.tableView2.hidden = YES;
                self.tableView1.hidden = YES;
            }
            [self.tableView1.mj_footer endRefreshingWithNoMoreData];
            [self.tableView2.mj_footer endRefreshingWithNoMoreData];
        }
           

      
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)openRedPacketSms:(NSDictionary *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    
    NSLog(@"redPacketInfo%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        RedPacket *red = [[RedPacket alloc]initWith:redPacketInfo];
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
       [self initRefresh1];
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

-(void)getRedPacketByStateClient:(NSString*)isValid{
    NSDictionary *Info;
    @try {
         NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"isValid":isValid,
                 @"page":pagestr,
                 @"pageSize":@"10"
                 };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan getRedPacketByStateSms:Info];
    }
    
}

-(void)openRedPacketClient{
    NSDictionary *Info;
    @try {
        NSString *cardCode = r._id;
        Info = @{@"id":cardCode
                 };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan openRedPacketSms:Info];
    }
    
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
    static NSString *CellIdentifier = @"TabViewCell";
    //自定义cell类
    MyRedPacketTableViewCell *cell ;
  
    //            REGISTER_CHANNEL("注册渠道"),
    //            LOGIN_CHANNEL("登录渠道"),
    //            SIGN_IN_CHANNEL("签到渠道"),
    //            RECHARGE_CHANNEL("充值渠道"),
    //            CONSUME_CHANNEL("消费渠道"),
    //            WIN_CHANNEL("中奖渠道");
    RedPacket *redPacket = [[RedPacket alloc]init];
    if (tableView ==self.tableView1) {
        static NSString *CellIdentifier = @"TabViewCell1";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRedPacketTableViewCell" owner:self options:nil] lastObject];
        }
        if (listUseRedPacketArray.count > 0) {
           redPacket = listUseRedPacketArray[indexPath.row];
             NSString *redPacketStatus = redPacket.redPacketStatus;
            if ([redPacketStatus isEqualToString:@"锁定"]) {
                cell.packetImage.image = [UIImage imageNamed:@"lockredpacket"];
            } else  if ([redPacketStatus isEqualToString:@"解锁"]) {
                cell.packetImage.image = [UIImage imageNamed:@"unlockredpacket"];
            }
         
            cell.endImage.hidden = YES;
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
            cell.sourceLab.text =  [NSString stringWithFormat:@"来源：%@",redPacket.activityName];
            NSString *date=[redPacket.endValidTime substringWithRange:NSMakeRange(0,10)];
            cell.endTimeLab.text = [NSString stringWithFormat:@"有效期至：%@",date];
            const long long  dayInteger = [self getDifferenceByDate:redPacket.endValidTime];
            NSNumber *longlongNumber = [NSNumber numberWithLongLong:dayInteger];
        
            NSString *daystr = [longlongNumber stringValue];
            cell.day.text=[NSString stringWithFormat:@"还有%@天过期",daystr];
        }
      
    }else if (tableView ==self.tableView2){
        static NSString *CellIdentifier = @"TabViewCell2";
        cell= [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"MyRedPacketTableViewCell" owner:self options:nil] lastObject];
        }
        if (listUnUseRedPacketArray.count > 0) {
           redPacket = listUnUseRedPacketArray[indexPath.row];
          
            cell.endImage.hidden = NO;
            cell.nameLab.text = redPacket._description;
            //已过期 全都是失效
            NSString *redPacketStatus =redPacket.redPacketStatus;
//            if ([redPacketStatus isEqualToString:@"锁定"]) {
//                cell.packetImage.image = [UIImage imageNamed:@"lock_cannot"];
//            } else  if ([redPacketStatus isEqualToString:@"解锁"]) {
//                cell.packetImage.image = [UIImage imageNamed:@"unlock_cannot"];
//            }
            cell.packetImage.image = [UIImage imageNamed:@"lock_cannot"];
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
            cell.sourceLab.text =  [NSString stringWithFormat:@"来源：%@",redPacket.activityName];;
            NSString *date=[redPacket.endValidTime substringWithRange:NSMakeRange(0,10)];
            cell.day.text = [NSString stringWithFormat:@"%@到期",date];
            cell.endTimeLab.hidden = YES;
        }
    }
    return cell;
}


#pragma UITableViewDelegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 0;
    //    }
    return 0.5;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
    if (tableView ==self.tableView1){
        r = listUseRedPacketArray[indexPath.row];
        
    [self openRedPacketClient];
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
