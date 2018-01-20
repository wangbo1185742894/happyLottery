//
//  NoticeCenterViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/29.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "NoticeCenterViewController.h"
#import "NoticeCenterTableViewCell.h"
#import "NoticeDetailViewController.h"
#import "LoadData.h"
#import "Notice.h"

@interface NoticeCenterViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    NSMutableArray *listSystemNoticeArray;
    NSMutableArray *listPersonNoticeArray;
  
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIButton *systemBtn;
@property (weak, nonatomic) IBOutlet UIButton *personBtn;
@property (weak, nonatomic) IBOutlet UIImageView *line1;
@property (weak, nonatomic) IBOutlet UIImageView *line2;
@property (weak, nonatomic) IBOutlet UITableView *tableView1;
@property (weak, nonatomic) IBOutlet UITableView *tableView2;
@property (weak, nonatomic) IBOutlet UIImageView *enptyImage;
@property (weak, nonatomic) IBOutlet UILabel *emptyLab;
@property(nonatomic,strong)  LoadData  *loadDataTool;

@end

@implementation NoticeCenterViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.viewControllerNo  = @"A107";
    self.title = @"我的消息";
    self.memberMan.delegate = self;
    self.tableView1.delegate = self;
    self.tableView1.dataSource = self;
    self.tableView2.delegate = self;
    self.tableView2.dataSource = self;
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    listSystemNoticeArray = [[NSMutableArray alloc]init];
    listPersonNoticeArray = [[NSMutableArray alloc]init];
    self.loadDataTool = [LoadData singleLoadData];
    [self getSystemNoticeClient];
}

- (IBAction)systemBtnClick:(id)sender {
    self.systemBtn.selected = YES;
    self.personBtn.selected = NO;
    self.line1.hidden = NO;
    self.line2.hidden = YES;
    self.tableView1.hidden=NO;
    self.tableView2.hidden = YES;
}

- (IBAction)personBtnClick:(id)sender {
    self.systemBtn.selected = NO;
    self.personBtn.selected = YES;
    self.line2.hidden = NO;
    self.line1.hidden = YES;
    self.tableView2.hidden=NO;
    self.tableView1.hidden = YES;
}

-(void)getSystemNoticeClient{
    NSString *theRequest;
//    theRequest= [GlobalInstance instance].h5Url;
//    theRequest = [[theRequest componentsSeparatedByString:@"/h5"] firstObject];
//
//    theRequest = [[theRequest componentsSeparatedByString:@"/ms"] firstObject];
        theRequest  = @"http://192.168.88.244:8086";
    [self.loadDataTool RequestWithString:[NSString stringWithFormat:@"%@/app/inform/byChannel?usageChannel=3",theRequest] isPost:YES andPara:nil andComplete:^(id data, BOOL isSuccess) {
       // [self hideLoadingView];
        if (isSuccess) {
            NSString *resultStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
            NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
            NSDictionary  *resultDic1 = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
            if ([resultDic1[@"code"] integerValue] != 0) {
                return ;
            }
            NSArray  *array =  resultDic1[@"result"];
            for (int i=0; i<array.count; i++) {
                
                Notice *notice = [[Notice alloc]initWith:array[i]];
                [listSystemNoticeArray addObject:notice];
                NSLog(@"redPacket%@",notice.content);
                
            }
            [self.tableView1 reloadData];
        }else{
            [self showPromptText: @"服务器连接失败" hideAfterDelay: 1.7];
        }
    }];
    
}

#pragma UITableViewDataSource methods
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (tableView ==self.tableView1) {
        if (listSystemNoticeArray.count > 0) {
            return listSystemNoticeArray.count;
        }
    }else if (tableView ==self.tableView2){
        
        if (listPersonNoticeArray.count > 0) {
            return listPersonNoticeArray.count;
        }
    }
    
    return 0;
}


- (CGFloat)tableView:(UITableView *)tableiew heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return 100;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    //[self.tableView registerClass :[YourTableCell class] forCellReuseIdentifier:@"txTableCell"];
    static NSString *CellIdentifier = @"TabViewCell";
    //自定义cell类
    NoticeCenterTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (cell == nil) {
        //通过xib的名称加载自定义的cell
        cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCenterTableViewCell" owner:self options:nil] lastObject];
    }
    //    SCORE_CONVERT("积分兑换"),
    //    LUCKY_DRAW("抽奖"),
    //    SYSTEM("系统赠送"),
    //    ACTIVITY("活动");
    Notice *notice = [[Notice alloc]init];
    if (tableView ==self.tableView1) {
        if (listSystemNoticeArray.count > 0) {
            notice = listSystemNoticeArray[indexPath.row];
            //cell.endImage.hidden = YES;
            cell.nameLab.text = notice.title;
            cell.noticeLab.text =notice.content;
             NSString *date=[notice.endTime substringWithRange:NSMakeRange(0,10)];
            cell.dateLab.text =date;
        }
        
    }else if (tableView ==self.tableView2){
        
        if (listPersonNoticeArray.count > 0) {
//            coupon = listPersonNoticeArray[indexPath.row];
//            cell.endImage.hidden = NO;
//            cell.priceLab.text = coupon.deduction;
//            cell.nameLab.text =[NSString stringWithFormat:@"¥%@元优惠券",coupon.deduction];
//            cell.priceLab.textColor = [UIColor lightGrayColor];
//            cell.yuanLab.textColor =[UIColor lightGrayColor];
            //NSString *status =coupon.status;
          
//            cell.sourceLab.text = [NSString stringWithFormat:@"来源：%@",coupon.couponSource];
//            cell.dateLab.text = [NSString stringWithFormat:@"有效期：%@",coupon.invalidTime];
//            cell.descriptionLab.text=[NSString stringWithFormat:@"单笔订单满%@可用",coupon.quota];
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
    NoticeCenterTableViewCell  *selectCell = [tableView cellForRowAtIndexPath:indexPath];
     Notice* notice = listSystemNoticeArray[indexPath.row];
    NSString *type = notice.type;
    if ([type isEqualToString:@"APP"]) {
          NSString *pageCode=notice.thumbnailCode;
        [self goToYunshiWithInfo:notice];
    }else if ([type isEqualToString:@"H5PAGE"]) {
      
    }else if ([type isEqualToString:@"TEXT"]) {
        NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] init];
        if (tableView ==self.tableView1) {
            vc.notice = listSystemNoticeArray[indexPath.row];
        }else if (tableView ==self.tableView2){
            
            vc.notice = listPersonNoticeArray[indexPath.row];
        }
        [self.navigationController pushViewController: vc animated: YES];
    }
  
   
}


-(void)goToYunshiWithInfo:(Notice *)itemIndex{
    NSString *keyStr = itemIndex.thumbnailCode;
    
    if (keyStr == nil) {
        return;
    }
    
    if (itemIndex.status!= nil) {
        if ([itemIndex.status isEqualToString:@"ENABLE"] && self.curUser.isLogin == NO) {
            [self needLogin];
            return;
        }
    }
    BaseViewController *baseVC;
    NSDictionary * vcDic = [NSDictionary dictionaryWithContentsOfFile: [[NSBundle mainBundle] pathForResource: @"pageCodeConfig" ofType:@"plist"]];
    if (keyStr == nil || [keyStr isEqualToString:@""]) {
        return;
    }
    NSString *vcName = vcDic[keyStr];
    if (vcName==nil) {
        return;
    }
    Class class = NSClassFromString(vcName);
    
    baseVC =[[class alloc] init];
    
    
    baseVC.hidesBottomBarWhenPushed = YES;
    
    [self.navigationController pushViewController:baseVC animated:YES];
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
