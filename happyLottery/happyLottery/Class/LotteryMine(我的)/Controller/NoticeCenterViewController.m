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
#import "FMDB.h"

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
@property (nonatomic, strong) FMDatabaseQueue *queue;


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
   // [self getDB];
    [self searchDB];
}

-(void)getDB{
    //    // 0.获得沙盒中的数据库文件名
    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
    NSError *error;
    
    NSBundle *bundle = [NSBundle mainBundle];
   // NSString *filenameAgo = [bundle pathForResource:@"userInfo" ofType:@"sqlite"];
   // NSLog(@"filenameAgo>>>>%@",filenameAgo);
    NSLog(@"filename%@",fileName);
//    NSFileManager *fileManager = [NSFileManager defaultManager];
//    [fileManager copyItemAtPath:filenameAgo toPath:fileName error:&error];
//
    // 1.创建数据库队列
    self.queue = [FMDatabaseQueue databaseQueueWithPath:fileName];
//    // 2.创表
//    [self.queue inDatabase:^(FMDatabase *db) {
//        BOOL result = [db executeUpdate:@"create table if not exists vcUserPushMsg(id integer primary key autoincrement, title text,content text, msgTime text,t1 text);"];
//        if (result) {
//            NSLog(@"创表成功");
//        } else {
//            NSLog(@"创表失败");
//        }
//    }];
}

-(void)searchDB{
    

//    NSString *doc=[NSSearchPathForDirectoriesInDomains (NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
//    NSString *fileName=[doc stringByAppendingPathComponent:@"userInfo.sqlite"];
//    self.fmdb =[FMDatabase databaseWithPath:fileName];
    
//    [self.queue inDatabase:^(FMDatabase *db) {
    [listPersonNoticeArray removeAllObjects];
        NSMutableArray *array = [NSMutableArray array];
        // 1.查询数据
            if ([self.fmdb open]) {
//        FMResultSet *rs = [db executeQuery:@"select * from vcUserPushMsg ;"];
       //    FMResultSet *rs = [self.fmdb executeQuery:@"select * from vcUserPushMsg"];
        // 2.遍历结果集
           
                    FMResultSet*  rs = [self.fmdb executeQuery:@"select * from vcUserPushMsg where cardcode=?",self.curUser.cardCode];
                
                        while (rs.next) {
                            Notice *notice =  [[Notice alloc] init];
                            notice.title = [rs stringForColumn:@"title"];
                            notice.content = [rs stringForColumn:@"content"];
                            notice.cardcode = [rs stringForColumn:@"cardcode"];
                            notice.endTime = [rs stringForColumn:@"msgTime"];
                            //            [self goImage:student.photo];
                            [array addObject: notice];
                        }

            listPersonNoticeArray = array;
                [self.tableView2 reloadData];
//    }];
            }
}

- (IBAction)systemBtnClick:(id)sender {
    self.systemBtn.selected = YES;
    self.personBtn.selected = NO;
    self.line1.hidden = NO;
    self.line2.hidden = YES;
    self.tableView1.hidden=NO;
    self.tableView2.hidden = YES;
    [listPersonNoticeArray removeAllObjects];
    [listSystemNoticeArray removeAllObjects];
       [self getSystemNoticeClient];
}

- (IBAction)personBtnClick:(id)sender {
    self.systemBtn.selected = NO;
    self.personBtn.selected = YES;
    self.line2.hidden = NO;
    self.line1.hidden = YES;
    self.tableView2.hidden=NO;
    self.tableView1.hidden = YES;
    [listPersonNoticeArray removeAllObjects];
    [listSystemNoticeArray removeAllObjects];
     [self searchDB];
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
                if ([self.fmdb open]) {
                    NSString *cardcode=[GlobalInstance instance ].curUser.cardCode;
                    if ([cardcode isEqualToString:@""]) {
                        cardcode = @"cardcode";
                    }
                    NSString *isread = @"0";
                    NSString *nid =[NSString stringWithFormat:@"A%d",i];
                    BOOL result =  [self.fmdb executeUpdate:[NSString stringWithFormat:@"insert into SystemNotice (title,content, msgTime , cardcode ,ieread,id) values ('%@', '%@', '%@', '%@', '%@', '%@');",notice.title,notice.content,notice.endTime,cardcode,isread,notice._id]];
                    if (result) {
                        [self.fmdb close];
                    }
                }
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
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCenterTableViewCell" owner:self options:nil] lastObject];
        }
        if (listSystemNoticeArray.count > 0) {
            notice = listSystemNoticeArray[indexPath.row];
            //cell.endImage.hidden = YES;
            cell.nameLab.text = notice.title;
            cell.noticeLab.text =notice.content;
             NSString *date=[notice.endTime substringWithRange:NSMakeRange(0,10)];
            cell.dateLab.text =date;
        }
        
    }else if (tableView ==self.tableView2){
        if (cell == nil) {
            //通过xib的名称加载自定义的cell
            cell = [[[NSBundle mainBundle] loadNibNamed:@"NoticeCenterTableViewCell" owner:self options:nil] lastObject];
        }
        if (listPersonNoticeArray.count > 0) {
            notice = listPersonNoticeArray[indexPath.row];
            //cell.endImage.hidden = YES;
            cell.nameLab.text = notice.title;
            cell.noticeLab.text =notice.content;
            NSString *date=[notice.endTime substringWithRange:NSMakeRange(0,10)];
            cell.dateLab.text =date;
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
    if (tableView ==self.tableView1) {
     Notice* notice = listSystemNoticeArray[indexPath.row];
        if ([self.fmdb open]) {
            NSString *cardcode=[GlobalInstance instance ].curUser.cardCode;
            if ([cardcode isEqualToString:@""]) {
                cardcode = @"cardcode";
            }
            NSString *isread = @"1";
            NSString *nid =[NSString stringWithFormat:@"A%ld",(long)indexPath.row];
            BOOL result =  [self.fmdb executeUpdate:[NSString stringWithFormat:@"update SystemNotice set ieread = '%@' where id = '%@';",isread,nid]];
            FMResultSet*  rs = [self.fmdb executeQuery:@"select * from vcUserPushMsg where id=?",nid];
            [listSystemNoticeArray removeAllObjects];
            
            while (rs.next) {
                Notice *notice =  [[Notice alloc] init];
                notice.title = [rs stringForColumn:@"title"];
                notice.content = [rs stringForColumn:@"content"];
                notice.cardcode = [rs stringForColumn:@"cardcode"];
                notice.endTime = [rs stringForColumn:@"msgTime"];
                 notice.isread = [rs stringForColumn:@"isread"];
                //            [self goImage:student.photo];
                [listSystemNoticeArray addObject: notice];
            }
            
            [self.tableView2 reloadData];
            if (result) {
                [self.fmdb close];
            }
        }
    NSString *type = notice.type;
    if ([type isEqualToString:@"APP"]) {
          NSString *pageCode=notice.thumbnailCode;
        [self goToYunshiWithInfo:notice];
    }else if ([type isEqualToString:@"H5PAGE"]) {
      
    }else if ([type isEqualToString:@"TEXT"]) {
        NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] init];
            vc.notice = listSystemNoticeArray[indexPath.row];
       
        [self.navigationController pushViewController: vc animated: YES];
    }
    }else if (tableView ==self.tableView2){
         NoticeDetailViewController *vc = [[NoticeDetailViewController alloc] init];
         vc.notice = listPersonNoticeArray[indexPath.row];
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
