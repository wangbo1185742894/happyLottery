//
//  MyCricleFriendVC.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "GroupMemberVC.h"
#import "MyCircleFirendCell.h"
#import "AgentMemberModel.h"

#define KMyCircleFirendCell @"MyCircleFirendCell"
@interface GroupMemberVC ()<UITableViewDelegate,UITableViewDataSource,AgentManagerDelegate>

@property(nonatomic,strong)NSMutableArray <AgentMemberModel * > *personArray;

@property(assign,nonatomic)NSInteger page;
@end

@implementation GroupMemberVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"圈成员";
    self.personArray = [NSMutableArray arrayWithCapacity:0];
    [self setTableView];
    self.agentMan.delegate = self;
    [UITableView refreshHelperWithScrollView:self.tabFirendList target:self loadNewData:@selector(loadNewData) loadMoreData:@selector(loadMoreData) isBeginRefresh:NO];
    [self loadNewData];
    
}

-(void)loadNewData{
    _page = 1;
    [self loadData];
}
-(void)loadMoreData{
    _page ++ ;
    [self loadData];
}

-(void)loadData{
//    NSArray *array = @[@"2什么os",@"4bc",@"3ab",@"3aa",@"3aa",@"e11",@"e23",@"s23",@"什么",@"娥皇"];
//    array = [array sortedArrayUsingComparator:^NSComparisonResult(id  _Nonnull obj1, id  _Nonnull obj2) {
//        NSString * stringa = (NSString *)obj1;
//        NSString * stringb = (NSString *)obj2;
//        if ([stringa compare:stringb]== NSOrderedDescending) {
//            return YES;
//        }
//        return NO;
//    }];
//    NSLog(@"%@",array);
    [self.agentMan listAgentMember:@{@"cardCode":self.curUser.cardCode,@"page":@(_page),@"pageSize":@(KpageSize)}];
}

-(void)listAgentMemberdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self.tabFirendList tableViewEndRefreshCurPageCount:array.count];
    if (success == NO) {
        [self showPromptViewWithText:msg hideAfter:1.9];
        return;
    }

    if (_page == 0) {
        [self.personArray removeAllObjects];
    }
    if (array == nil || array.count == 0) {
        [self showPromptText:@"暂无圈友" hideAfterDelay:1.0];
    }else{
        [self.personArray removeAllObjects];
        //添加数据
        for (NSDictionary *dic in array) {
            AgentMemberModel *model = [[AgentMemberModel alloc]initWith:dic];
            [_personArray addObject:model];
        }
        [self hideLoadingView];
    }
    [self.tabFirendList reloadData];
}

-(void)setTableView{
    self.tabFirendList .delegate = self;
    self.tabFirendList.dataSource = self;
    [self.tabFirendList registerNib:[UINib nibWithNibName:KMyCircleFirendCell bundle:nil] forCellReuseIdentifier:KMyCircleFirendCell];
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
   
    return self.personArray.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCircleFirendCell *cell = [tableView dequeueReusableCellWithIdentifier:KMyCircleFirendCell];
    [cell loadDataInQ:[self.personArray objectAtIndex:indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}


-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}


@end
