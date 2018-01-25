//
//  FeedBackHistoryViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/12.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "FeedBackHistoryViewController.h"
#import "FeedBackHistoryTableViewCell.h"
#import "FeedBackHistory.h"

static NSString * const ReuseIdentifier = @"cell";
@interface FeedBackHistoryViewController ()<MemberManagerDelegate,UITableViewDelegate,UITableViewDataSource>{
    
    int page;
}
@property (weak, nonatomic) IBOutlet UITableView *tableview;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, strong) NSMutableDictionary *heightAtIndexPath;//缓存高度

@end

@implementation FeedBackHistoryViewController

- (void)viewDidLoad {
    [super viewDidLoad];
     self.title = @"历史反馈";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
      self.memberMan.delegate = self;
      self.tableview.delegate=self;
      self.tableview.dataSource=self;
      self.tableview.estimatedRowHeight = 120;//很重要保障滑动流畅性
      self.tableview.rowHeight = UITableViewAutomaticDimension;
      [self.tableview registerNib:[UINib nibWithNibName:NSStringFromClass([FeedBackHistoryTableViewCell class]) bundle:nil] forCellReuseIdentifier:ReuseIdentifier];
      page=1;
      self.dataArray = [[NSMutableArray alloc]init];
      [self initRefresh];
    
}

-(void)initRefresh{
    __weak typeof(self) weakSelf = self;
    self.tableview.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        page=1;
        [weakSelf FeedBackHistoryClient];
        [self.tableview.mj_header endRefreshing];
    }];
    self.tableview.mj_footer = [MJRefreshAutoNormalFooter footerWithRefreshingBlock:^{
        page++;
        //[self.tableView2.mj_header beginRefreshing];
        [weakSelf FeedBackHistoryClient];
        
    }];
    
    // 马上进入刷新状态
    
    [self.tableview.mj_header beginRefreshing];
}

-(void)FeedBackHistoryClient{
    NSDictionary *Info;
    @try {
        NSString *pagestr=[NSString stringWithFormat:@"%d",page];
        NSString *cardCode = self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"page":pagestr,
                 @"pageSize":@"5"
                 };
        
    } @catch (NSException *exception) {
        return;
    } 
        [self.memberMan getFeedbackListSms:Info];

}

-(void)getFeedbackListSms:(NSArray *)redPacketInfo IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    NSLog(@"getFeedbackList%@",redPacketInfo);
    if ([msg isEqualToString:@"执行成功"]) {
        //[self showPromptText: @"现金流水成功" hideAfterDelay: 1.7];
        NSEnumerator *enumerator = [redPacketInfo objectEnumerator];
        id object;
        if ((object = [enumerator nextObject]) != nil)  {
            
            NSArray *array =redPacketInfo;
            
            
            if (page == 1) {
                [_dataArray removeAllObjects];
                if (array.count>0) {
                    for (int i=0; i<array.count; i++) {
                        NSDictionary *dic = [[NSDictionary alloc]init];
                        dic = array[i];
                        FeedBackHistory *feedBackHistory =  [[FeedBackHistory alloc]initWith:dic];
                        //feedBackHistory = array[i];
                        [_dataArray addObject:feedBackHistory];
                    }
                    [self.tableview.mj_footer endRefreshing];
                    self.tableview.hidden = NO;
                    [self.tableview reloadData];
                    //self.emptyView.hidden=YES;
                }else{
                    
                    //self.emptyView.hidden=NO;
                    self.tableview.hidden = YES;
                }
            }else{
                if (array.count>0) {
                    //
                    for (int i=0; i<array.count; i++) {
                        
                        FeedBackHistory *feedBackHistory = [[FeedBackHistory alloc]initWith:array[i]];
                        [_dataArray addObject:feedBackHistory];
                        
                    }
                    if (_dataArray.count>0) {
                        self.tableview.hidden = NO;
                        [self.tableview reloadData];
                        [self.tableview.mj_footer endRefreshing];
                    }else{
                        [self.tableview.mj_footer endRefreshingWithNoMoreData];
                        
                    }
                    
                }
            }
        }else{
            [self.tableview.mj_footer endRefreshingWithNoMoreData];
            if (page == 1){
                
                //self.emptyView.hidden=NO;
                self.tableview.hidden = YES;
            }
        }
        
        
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}

#pragma mark - UITableViewDelegate
-(CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    //    if (section == 0) {
    //        return 0;
    //    }
    return 10;
}
- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.5;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return self.dataArray.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedBackHistoryTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:ReuseIdentifier forIndexPath:indexPath];
    
    FeedBackHistory *f = self.dataArray[indexPath.row];
    NSString *feedbackContent = f.feedbackContent;
    cell.askLab.text =feedbackContent;
    if ([f.reply isEqualToString:@"1"]){
        [cell.answerBtn setBackgroundImage:[UIImage  imageNamed:@"answer.png"]  forState:UIControlStateNormal];
        cell.answerLab.text=f.replyContent;
    }else{
        [cell.answerBtn setBackgroundImage:[UIImage imageNamed:@"response.png"]  forState:UIControlStateNormal];
        cell.answerLab.text = @"平台会尽快回复您，请您耐心等待，也可拨打客服电话400-600-5558";
        
    }
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = [self.heightAtIndexPath objectForKey:indexPath];
    if(height)
    {
        return height.floatValue;
    }
    else
    {
        return 120;
    }
}
//
//- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
//{
//    return 120;
//}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
    NSNumber *height = @(cell.frame.size.height);
    [self.heightAtIndexPath setObject:height forKey:indexPath];
}

#pragma mark - Getters
- (NSMutableDictionary *)heightAtIndexPath
{
    if (!_heightAtIndexPath) {
        _heightAtIndexPath = [NSMutableDictionary dictionary];
    }
    return _heightAtIndexPath;
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
