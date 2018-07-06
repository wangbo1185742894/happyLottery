//
//  WBMenu.h
//  WBMenuView
//
//  Created by 王博 on 16/1/7.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "WBContentView.h"
#import "WBMenuScrollView.h"

@interface WBMenu : UIView<UIScrollViewDelegate>

@property(strong,nonatomic)NSMutableArray*VClist;

@property(nonatomic,weak)WBContentView*contentScrollView;

@property(nonatomic,weak)WBMenuScrollView*menuView;

@property(nonatomic,strong)NSArray*titles;

-(void)createMenuView:(NSArray*)titles size:(CGSize)size;

-(void)addViewController:(UIViewController*)vc atIndex:(NSInteger)index;
-(void)setMenuViewOffset:(NSInteger)index;

-(void)addView:(UIView*)view andViewController :(UIViewController*)vc atIndex:(NSInteger )index;

@end
