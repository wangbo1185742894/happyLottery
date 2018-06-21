//
//  MyCricleFriendVC.m
//  happyLottery
//
//  Created by 阿兹尔 on 2018/6/4.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "MyCricleFriendVC.h"
#import "MyCircleFirendCell.h"
#import "AgentMemberModel.h"

#define KMyCircleFirendCell @"MyCircleFirendCell"
@interface MyCricleFriendVC ()<UITableViewDelegate,UITableViewDataSource,AgentManagerDelegate>

@property(nonatomic,strong)NSMutableArray <NSMutableArray  <AgentMemberModel * >*> *personArray;
@property(strong,nonatomic)NSMutableArray *openRow;
@property(assign,nonatomic)NSInteger page;
@end

@implementation MyCricleFriendVC

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"我的圈友";
    self.openRow = [NSMutableArray arrayWithCapacity:0];
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
    
    [self.agentMan listAgentMember:@{@"cardCode":self.curUser.cardCode}];
}

-(void)listAgentMemberdelegate:(NSArray *)array isSuccess:(BOOL)success errorMsg:(NSString *)msg{
    [self.tabFirendList tableViewEndRefreshCurPageCount:array.count];
    if (success == NO) {
        [self showPromptViewWithText:msg hideAfter:1.9];
        return;
    }

    if (_page == 1) {
        [self .personArray removeAllObjects];
    }
    if (array == nil || array.count == 0) {
        [self showPromptText:@"暂无圈友" hideAfterDelay:1.0];
    }else{
        for (NSDictionary *item in array ) {
            int flag = 0;
            AgentMemberModel *model = [[AgentMemberModel alloc]initWith:item];
            for (NSMutableArray *array in self.personArray) {
                AgentMemberModel *fModel = [array firstObject];
                if ([[fModel.createTime substringToIndex:10 ] isEqualToString:[model.createTime substringToIndex:10 ]]) {
                    [array addObject:model];
                    flag = 1;
                    break;
                }
            }
            
            if (flag == 0) {
                NSMutableArray *item = [NSMutableArray arrayWithCapacity:0];
                [item addObject:model];
                [self.personArray addObject:item];
                if (self.openRow.count >=1) {
                    [self.openRow addObject:@"0"];
                }else{
                    [self.openRow addObject:@"1"];
                }
                
            }
            
            
            // section data
            NSArray *itemArray = [self.personArray sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
                AgentMemberModel * timeFir = [(NSArray *)obj1 firstObject];
                AgentMemberModel * timeSec = [(NSArray *)obj2 firstObject];
                NSDate * dateFir = [Utility dateFromDateStr:timeFir.createTime withFormat:@"yyyy-MM-dd"];
                NSDate * dateSec = [Utility dateFromDateStr:timeSec.createTime withFormat:@"yyyy-MM-dd"];
                NSTimeInterval intervalFir = [dateFir timeIntervalSince1970];
                NSTimeInterval intervalSec = [dateSec timeIntervalSince1970];
                if (intervalFir > intervalSec) {
                    return NSOrderedDescending;
                }else{
                    return NSOrderedAscending;
                }
            }];
            self.personArray = [NSMutableArray arrayWithArray:itemArray];
        }
    }
    [self.tabFirendList reloadData];
}

-(void)setTableView{
    self.tabFirendList .delegate = self;
    self.tabFirendList.dataSource = self;
    [self.tabFirendList registerNib:[UINib nibWithNibName:KMyCircleFirendCell bundle:nil] forCellReuseIdentifier:KMyCircleFirendCell];
}

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return self.personArray.count;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if ([self.openRow[section] boolValue] == YES) {
        return self.personArray[section].count;
    }else{
        return 0;
    }
    
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    MyCircleFirendCell *cell = [tableView dequeueReusableCellWithIdentifier:KMyCircleFirendCell];
    [cell loadData:self.personArray[indexPath.section][indexPath.row]];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    return cell;
}

-(CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    return 0.1;
}

-(UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    return  [UIView new];
}

-(CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    return 60;
}

-(UIView*)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TableHeaderView *header = [[[NSBundle mainBundle]loadNibNamed:@"TableHeaderView" owner:nil options:nil] lastObject];
    header.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);
    header.labTime.text = [[self.personArray[section] firstObject].createTime substringToIndex:10];
    
    header.btnActionClick.tag = section;
    [header.btnActionClick addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.openRow[section] boolValue] == YES) {
        [header.imgDir setImage:[UIImage imageNamed:@"arrow_up"]];
        
    }else{
        [header.imgDir setImage:[UIImage imageNamed:@"arrow_down"]];
    }
    return header;
}
-(void)headerViewClick:(UIButton *)btn{
        
        BOOL isOpen = [self.openRow[btn.tag] boolValue];
        if (isOpen == YES) {
            [self.openRow removeObjectAtIndex:btn.tag];
            [self.openRow insertObject:@(NO) atIndex:btn.tag];
        }else{
            [self.openRow removeObjectAtIndex:btn.tag];
            [self.openRow insertObject:@(YES) atIndex:btn.tag];
        }
        NSIndexSet *set = [NSIndexSet indexSetWithIndex:btn.tag];
        [self.tabFirendList reloadSections:set withRowAnimation:UITableViewRowAnimationFade];
    

}

@end
