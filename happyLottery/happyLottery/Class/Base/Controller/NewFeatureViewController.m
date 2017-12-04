//
//  NewFeatureViewController.m
//  happyLottery
//
//  Created by 王博 on 2017/12/4.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "NewFeatureViewController.h"

@interface NewFeatureViewController ()<UIScrollViewDelegate>
{
    
    UIScrollView *newFeatureView;
    UIPageControl *pageCtr;
}
@end

@implementation NewFeatureViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    NSArray<UIColor*> * colors = @[[UIColor redColor],[UIColor greenColor],[UIColor yellowColor]];
    newFeatureView = [[UIScrollView alloc]initWithFrame:[UIScreen mainScreen].bounds];
    newFeatureView.contentSize = CGSizeMake(self.view.mj_w * 3, self.view.mj_h);
    newFeatureView.delegate  =self;
    pageCtr = [[UIPageControl alloc]initWithFrame:CGRectMake((self.view.mj_w - 80) / 2, self.view.mj_h - 55, 80, 20)];
    pageCtr.numberOfPages  =3;
    pageCtr.currentPage = 0;
    for (int i = 0; i < 3; i ++ ) {
        UIImageView * imgItem = [[UIImageView alloc]initWithFrame:CGRectMake(self.view.mj_w * i , 0, self.view.mj_w, self.view.mj_h)];
        [newFeatureView addSubview:imgItem];
        imgItem.userInteractionEnabled = NO;
        imgItem.backgroundColor = colors[i];
        if (i == 2) {
            UIButton * btnExperience = [UIButton buttonWithType:UIButtonTypeCustom];
            [btnExperience setTitle:@"立即体验" forState:0];
            [btnExperience addTarget:self action:@selector(actionExperience) forControlEvents:UIControlEventTouchUpInside];
            btnExperience.frame = CGRectMake( (imgItem.mj_w * 2)+(imgItem.mj_w - 80) / 2, imgItem.mj_h - 100, 80, 40);
            [newFeatureView addSubview:btnExperience];
            btnExperience.backgroundColor = [UIColor redColor];
        }
        
    }
    
    newFeatureView.pagingEnabled = YES;
    [self.view addSubview:newFeatureView];
    [self.view addSubview:pageCtr];
}

-(void)actionExperience{
    
    [self.delegate newFeatureSetRootVC];
}

#pragma UIScrollViewDelegate
-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    pageCtr.currentPage = (NSInteger)scrollView.contentOffset.x / self.view.mj_w;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    
}


@end
