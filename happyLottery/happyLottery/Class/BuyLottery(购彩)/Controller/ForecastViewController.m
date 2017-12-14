//
//  ForecastViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/12.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "ForecastViewController.h"
#import "NewsListCell.h"
#import "TableHeaderView.h"
#define KNewsListCell @"NewsListCell"
@interface ForecastViewController ()<UITableViewDataSource,UITableViewDelegate>
{
    
    __weak IBOutlet UITableView *tabForecastListView;
}
@property(nonatomic,strong)NSMutableArray *arrayTableSectionIsOpen;
@end

@implementation ForecastViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self setViewController];
    [self setTableView];
}

-(void)setViewController{
    
    self.title = @"精准预测";
    self.arrayTableSectionIsOpen = [NSMutableArray arrayWithArray:@[@(YES),@(YES),@(YES),@(YES)]];
    
}

-(void)setTableView{
    
    tabForecastListView.delegate = self;
    tabForecastListView.dataSource = self;
    [tabForecastListView registerClass:[NewsListCell class] forCellReuseIdentifier:KNewsListCell];
    tabForecastListView.rowHeight = 117;
    [tabForecastListView reloadData];
}

#pragma UITableViewDelegate,UITableViewDataSource
-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{

    BOOL isOpen = [self.arrayTableSectionIsOpen[section] boolValue];
    if (isOpen ) {
        return 10;
    }else{
        return 0;
        
    }
    
}
-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 4;
}

-(UITableViewCell * )tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    NewsListCell * cell = [tableView dequeueReusableCellWithIdentifier:KNewsListCell];
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    
    return cell;
}

-(UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    
    TableHeaderView *header = [[[NSBundle mainBundle]loadNibNamed:@"TableHeaderView" owner:nil options:nil] lastObject];
    header.backgroundColor =RGBCOLOR(245, 245, 245);
    
    header.frame = CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, 30);

    header.btnActionClick.tag = section;
    [header.btnActionClick addTarget:self action:@selector(headerViewClick:) forControlEvents:UIControlEventTouchUpInside];
    
    if ([self.arrayTableSectionIsOpen [section] boolValue] == YES) {
        [header.imgDir setImage:[UIImage imageNamed:@"arrow_up"]];
        
    }else{
        [header.imgDir setImage:[UIImage imageNamed:@"arrow_down"]];
    }
    return header;
}

-(void)headerViewClick:(UIButton *)btn{
    [UIView animateWithDuration:1.0 animations:^{
        
        BOOL isOpen = [self.arrayTableSectionIsOpen[btn.tag] boolValue];
        if (isOpen == YES) {
            [self.arrayTableSectionIsOpen removeObjectAtIndex:btn.tag];
            [self.arrayTableSectionIsOpen insertObject:@(NO) atIndex:btn.tag];
        }else{
            [self.arrayTableSectionIsOpen removeObjectAtIndex:btn.tag];
            [self.arrayTableSectionIsOpen insertObject:@(YES) atIndex:btn.tag];
        }
        [tabForecastListView reloadData];
    }];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
