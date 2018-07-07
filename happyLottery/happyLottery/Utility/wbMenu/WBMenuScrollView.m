//
//  WBMenuScrollView.m
//  WBMenuView
//
//  Created by 王博 on 16/1/6.
//  Copyright © 2016年 aoli. All rights reserved.
//

#import "WBMenuScrollView.h"
#import "WBMenuAllItem.h"

@interface WBMenuScrollView ()

@property(nonatomic,strong)UILabel*buttomLable;

@end

@implementation WBMenuScrollView

-(instancetype)init{

    if (self = [super init]) {
        
    }
    return self;
}

-(void)addMenuItems:(NSArray*)items andSize:(CGSize)itemSize{

    self.buttomLable = [[UILabel alloc]initWithFrame:CGRectMake(0, itemSize.height-2, itemSize.width, 2)];
    self.buttomLable.backgroundColor = SystemGreen;
    [self addSubview:self.buttomLable];
    for (int i = 0;i<items.count;i++) {
        UIButton*button = [UIButton buttonWithType:UIButtonTypeCustom];
        button.frame = CGRectMake(i*itemSize.width, 0, itemSize.width, itemSize.height);
        button.titleLabel.font = [UIFont systemFontOfSize:15];
        button.tag = i;
        NSString*title = items[i];
        NSLog(@"%d",i);
        if (i == 0) {
            button.selected = YES;
        }
        [button setTitleColor:[UIColor grayColor] forState:UIControlStateNormal];
        [button setTitleColor:SystemGreen forState:UIControlStateSelected];
        [button setTitle:title forState:UIControlStateNormal];
        [self addSubview:button];
        [button addTarget:self action:@selector(clickAction:) forControlEvents:UIControlEventTouchUpInside];
    }
    self.contentSize = CGSizeMake(itemSize.width*items.count, 30);
    
}

-(void)clickAction:(UIButton*)btn{
    
    for (UIView *subView in self.subviews) {
        if ([subView isKindOfClass:[UIButton class]]) {
            UIButton *button = (UIButton*)subView;
            button.selected = NO;
            if (button.tag == btn.tag) {
                button.selected = YES;
            }
        }
    }
    
    if (self.contentScrollView) {
        
        [UIView animateWithDuration:0.2 animations:^{
        
            
            self.buttomLable.frame = CGRectMake(self.buttomLable.frame.size.width*(btn.tag), self.buttomLable.frame.origin.y, self.buttomLable.frame.size.width, self.buttomLable.frame.size.height);
            
            if (btn.frame.size.width*(btn.tag - 1)>=0&&btn.frame.size.width*(btn.tag - 1)<=self.contentSize.width-(self.frame.size.width - 65)) {
                [self scrollRectToVisible:CGRectMake(btn.frame.size.width*(btn.tag - 1), 0, self.frame.size.width, self.frame.size.height) animated:NO];
                
            }else if(btn.frame.size.width*(btn.tag - 1)<0){
            
            self.contentOffset = CGPointMake(0, 0);
            }else if (btn.frame.size.width*(btn.tag - 1)>self.contentSize.width-(self.frame.size.width )){
                
            [self scrollRectToVisible:CGRectMake(self.contentSize.width - self.frame.size.width, 0, self.frame.size.width, self.frame.size.height) animated:NO];
                
            }
            
            UIScrollView*view = (UIScrollView *)self.contentScrollView;
            [view scrollRectToVisible:CGRectMake([UIScreen mainScreen].bounds.size.width*btn.tag, 0, view.frame.size.width, view.frame.size.height) animated:NO];
        }];
        if (btn.tag>=self.VCList.count) {
            return;
        }
        UIViewController<WBMenuViewDelegate> *vc = self.VCList[btn.tag];
       
        if ([vc respondsToSelector:@selector(refresh)]&&[vc isRefresh]) {
            [vc refresh];
        }
        
    }
}


@end
