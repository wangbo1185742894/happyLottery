//
//  WBMenuScrollView.h
//  WBMenuView
//
//  Created by 王博 on 16/1/6.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import <UIKit/UIKit.h>
@class WBContentView;

@protocol WBMenuViewDelegate <NSObject>

@required
-(BOOL)isRefresh;
-(void)refresh;

@end
@interface WBMenuScrollView : UIScrollView

@property(nonatomic,strong)NSMutableArray*VCList;

@property(nonatomic,weak)WBContentView *contentScrollView;

-(void)addMenuItems:(NSArray*)items andSize:(CGSize)itemSize;
-(void)clickAction:(UIButton*)btn;

@end
