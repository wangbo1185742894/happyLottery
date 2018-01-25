//
//  UITableView+XY.h
//  XYTableViewNoDataView
//
//  Created by 韩元旭 on 2017/7/19.
//  Copyright © 2017年 iCourt. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KpageSize 10
@interface UITableView (XY)
+(void)refreshHelperWithScrollView:(UIScrollView *)scrollView target:(id)target loadNewData:(SEL)loadNewData loadMoreData:(SEL)loadMoreData isBeginRefresh:(BOOL)beginRefreshing;
-(void)tableViewEndRefreshCurPageCount:(NSInteger )count;
@end
