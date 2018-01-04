//
//  MyCouponViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/28.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "MyCouponViewController.h"
#import "MyCouponTableViewCell.h"
#import "Coupon.h"

@interface MyCouponViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listUseCouponArray;
    NSMutableArray *listUnUseCouponArray;
    int currPage1;
    int pageSize1;
    int totalCount1;
    int totalPage1;
    int currPage2;
    int pageSize2;
    int totalCount2;
    int totalPage2;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UISegmentedControl *segment;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;

@end

@implementation MyCouponViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的优惠券";
    self.memberMan.delegate = self;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    listUseCouponArray = [[NSMutableArray alloc]init];
    listUnUseCouponArray = [[NSMutableArray alloc]init];
     [self getCouponByStateClient:@"true"];
}
- (IBAction)segmetClick:(id)sender {
    switch( self.segment.selectedSegmentIndex)
    {
        case 0:
            self.tableView1.hidden=NO;
            self.tableView2.hidden=YES;
            [listUseCouponArray removeAllObjects];
            [self getCouponByStateClient:@"true"];
            break;
        case 1:
            self.tableView2.hidden=NO;
            self.tableView1.hidden=YES;
            [listUnUseCouponArray removeAllObjects];
            [self getCouponByStateClient:@"false"];
            break;
        default:
            break;
    }
}

-(void)getCouponByStateSms:(NSDictionary *)couponInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    NSLog(@"redPacketInfo%@",couponInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        // [self showPromptText: @"memberInfo成功" hideAfterDelay: 1.7];
        if (couponInfo!=nil) {
            
                if (self.segment.selectedSegmentIndex == 0) {
                    currPage1 =(int)[couponInfo valueForKey:@"currPage"];
                    pageSize1 = (int)[couponInfo valueForKey:@"pageSize"];
                    totalCount1 = (int)[couponInfo valueForKey:@"totalCount"];
                    totalPage1 = (int)[couponInfo valueForKey:@"totalPage"];
                    NSArray *array =[couponInfo valueForKey:@"list"];
                    if (array.count>0) {
                        [listUseCouponArray removeAllObjects];
                        for (int i=0; i<array.count; i++) {
                            
                            Coupon *coupon = [[Coupon alloc]initWith:array[i]];
                            [listUseCouponArray addObject:coupon];
                             NSLog(@"redPacket%@",coupon.status);
                            if (listUseCouponArray.count>0) {
                                self.tableView1.hidden = NO;
                                self.tableView2.hidden = YES;
                                [self.tableView1 reloadData];
                            }
                        }
                        
                    }
  
                }else if(self.segment.selectedSegmentIndex==1){
                    currPage2 =(int)[couponInfo valueForKey:@"currPage"];
                    pageSize2 = (int)[couponInfo valueForKey:@"pageSize"];
                    totalCount2 = (int)[couponInfo valueForKey:@"totalCount"];
                    totalPage2 = (int)[couponInfo valueForKey:@"totalPage"];
                    NSArray *array =[couponInfo valueForKey:@"list"];
                    if (array.count>0) {
                        [listUnUseCouponArray removeAllObjects];
                        for (int i=0; i<array.count; i++) {
                            
                            Coupon *coupon = [[Coupon alloc]initWith:array[i]];
                            [listUnUseCouponArray addObject:coupon];
                            NSLog(@"redPacket%@",coupon.status);
                            if (listUnUseCouponArray.count>0) {
                                self.tableView2.hidden = NO;
                                self.tableView1.hidden = YES;
                                [self.tableView2 reloadData];
                            }
                        }
                }
            }
    
        }
        
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

-(void)getCouponByStateClient:(NSString*)isValid{
    NSDictionary *Info;
    @try {
        
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"isValid":isValid
                 };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan getCouponByStateSms:Info];
    }
    
}

#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView ==self.tableView1) {
        if (listUseCouponArray.count > 0) {
            return listUseCouponArray.count;
        }
    }else if (tableView ==self.tableView2){
        
        if (listUnUseCouponArray.count > 0) {
            return listUnUseCouponArray.count;
        }
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 101;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
    static NSString *CellIdentifier = @"TabViewCell";
    //自定义cell类
    MyCouponTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"MyCouponTableViewCell" owner:self options:nil] lastObject];
    }
//    SCORE_CONVERT("积分兑换"),
//    LUCKY_DRAW("抽奖"),
//    SYSTEM("系统赠送"),
//    ACTIVITY("活动");
    Coupon *coupon = [[Coupon alloc]init];
    if (tableView ==self.tableView1) {
        if (listUseCouponArray.count > 0) {
            coupon = listUseCouponArray[indexPath.row];
            cell.endImage.hidden = YES;
            cell.priceLab.text = coupon.deduction;
            cell.nameLab.text =[NSString stringWithFormat:@"¥%@元优惠券",coupon.deduction];
            NSString *status =coupon.status;
            NSString *sourecs;
//            if ([redPacketChannel isEqualToString:@"REGISTER_CHANNEL"]) {
//                sourecs = @"来源： 系统注册赠送";
//            } else if ([redPacketChannel isEqualToString:@"LOGIN_CHANNEL"]){
//                sourecs = @"来源： 系统登录赠送";
//            }else if ([redPacketChannel isEqualToString:@"SIGN_IN_CHANNEL"]){
//                sourecs = @"来源： 系统签到赠送";
//            }else if ([redPacketChannel isEqualToString:@"RECHARGE_CHANNEL"]){
//                sourecs = @"来源： 系统充值赠送";
//            }else if ([redPacketChannel isEqualToString:@"CONSUME_CHANNEL"]){
//                sourecs = @"来源： 系统消费赠送";
//            }else if ([redPacketChannel isEqualToString:@"WIN_CHANNEL"]){
//                sourecs = @"来源： 系统中奖赠送";
//            }
            cell.sourceLab.text = [NSString stringWithFormat:@"来源：%@",coupon.couponSource];
            cell.dateLab.text = [NSString stringWithFormat:@"有效期：%@",coupon.invalidTime];
            cell.descriptionLab.text=[NSString stringWithFormat:@"单笔订单满%@可用",coupon.quota];
        }

    }else if (tableView ==self.tableView2){

        if (listUnUseCouponArray.count > 0) {
            coupon = listUnUseCouponArray[indexPath.row];
            cell.endImage.hidden = NO;
            cell.priceLab.text = coupon.deduction;
            cell.nameLab.text =[NSString stringWithFormat:@"¥%@元优惠券",coupon.deduction];
            cell.priceLab.textColor = [UIColor lightGrayColor];
            cell.yuanLab.textColor =[UIColor lightGrayColor];
            NSString *status =coupon.status;
            NSString *sourecs;
            //            if ([redPacketChannel isEqualToString:@"REGISTER_CHANNEL"]) {
            //                sourecs = @"来源： 系统注册赠送";
            //            } else if ([redPacketChannel isEqualToString:@"LOGIN_CHANNEL"]){
            //                sourecs = @"来源： 系统登录赠送";
            //            }else if ([redPacketChannel isEqualToString:@"SIGN_IN_CHANNEL"]){
            //                sourecs = @"来源： 系统签到赠送";
            //            }else if ([redPacketChannel isEqualToString:@"RECHARGE_CHANNEL"]){
            //                sourecs = @"来源： 系统充值赠送";
            //            }else if ([redPacketChannel isEqualToString:@"CONSUME_CHANNEL"]){
            //                sourecs = @"来源： 系统消费赠送";
            //            }else if ([redPacketChannel isEqualToString:@"WIN_CHANNEL"]){
            //                sourecs = @"来源： 系统中奖赠送";
            //            }
            cell.sourceLab.text = [NSString stringWithFormat:@"来源：%@",coupon.couponSource];
            cell.dateLab.text = [NSString stringWithFormat:@"有效期：%@",coupon.invalidTime];
            cell.descriptionLab.text=[NSString stringWithFormat:@"单笔订单满%@可用",coupon.quota];
        }
    }

    
    
    
    
    
    
    return cell;
}


#pragma UITableViewDelegate methods
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 0;
    //    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    [tableView deselectRowAtIndexPath: indexPath animated: YES];
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
