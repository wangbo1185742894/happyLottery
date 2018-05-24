//
//  UITableView+XY.h
//  XYTableViewNoDataView
//
//  Created by 韩元旭 on 2017/7/19.
//  Copyright © 2017年 iCourt. All rights reserved.
//

#import <UIKit/UIKit.h>
#define KpageSize 10
@protocol XYTableViewDelegate <NSObject>
@optional
- (UIView   *)xy_noDataView;                //  完全自定义占位图
- (UIImage  *)xy_noDataViewImage;           //  使用默认占位图, 提供一张图片,    可不提供, 默认不显示
- (NSString *)xy_noDataViewMessage;         //  使用默认占位图, 提供显示文字,    可不提供, 默认为暂无数据
- (UIColor  *)xy_noDataViewMessageColor;    //  使用默认占位图, 提供显示文字颜色, 可不提供, 默认为灰色
- (NSNumber *)xy_noDataViewCenterYOffset;   //  使用默认占位图, CenterY 向下的偏移量
-(BOOL)havData;                                           //博哥是一个神  改的  

@end
@interface UITableView (XY)

+(void)refreshHelperWithScrollView:(UIScrollView *)scrollView target:(id)target loadNewData:(SEL)loadNewData loadMoreData:(SEL)loadMoreData isBeginRefresh:(BOOL)beginRefreshing;
-(void)tableViewEndRefreshCurPageCount:(NSInteger )count;

@end
