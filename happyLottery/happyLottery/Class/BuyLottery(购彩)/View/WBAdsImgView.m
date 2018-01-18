//
//  WBAdsImgView.m
//  happyLottery
//
//  Created by 王博 on 2017/12/6.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

#import "WBAdsImgView.h"


@interface WBAdsImgView()<UIScrollViewDelegate>
{
    
    UIScrollView *scrContentView;
    NSTimer *timer;
    NSArray * _imgUrls;
    NSInteger index;
    UIPageControl *pageCtl;
    
}
@end

@implementation WBAdsImgView

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScrImg) userInfo:nil repeats:YES];
        index = 0;
        pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake((KscreenWidth - 80) / 2, self.mj_h - 50, 80, 40)];
    }
    return self;
}

-(void)setImageUrlArray:(NSArray<ADSModel *> *)imgUrls{
    _imgUrls = imgUrls;
    
    pageCtl.numberOfPages = imgUrls.count;
    NSArray *colors = @[[UIColor redColor],[UIColor greenColor],[UIColor redColor],[UIColor greenColor]];
    
    scrContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth,self.mj_h)];
    scrContentView.delegate = self;
    scrContentView.pagingEnabled = YES;
    scrContentView.showsHorizontalScrollIndicator = NO;
    scrContentView.showsVerticalScrollIndicator = NO;
    scrContentView.bounces = NO;
    
    scrContentView.contentSize = CGSizeMake(KscreenWidth * imgUrls.count, scrContentView.mj_h);
    
    [self addSubview:scrContentView];
    
    for (int i = 0; i < imgUrls.count; i ++ ) {
        UIButton *itemImg = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth * i, 0, self.mj_w, scrContentView.mj_h)];
        itemImg.imageView.contentMode = UIViewContentModeScaleToFill;
        [scrContentView addSubview:itemImg];
//        itemImg.backgroundColor = colors[i];
        [itemImg addTarget:self action:@selector(imgItemClick) forControlEvents:UIControlEventTouchUpInside];
        itemImg.adjustsImageWhenHighlighted = NO;
        [itemImg setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ad_home%d.png",i + 1]] forState:0];
        
        [itemImg sd_setImageWithURL:[NSURL URLWithString:imgUrls[i].imgUrl] forState:0];
    }
    [self addSubview:pageCtl];
    
    
   
}

-(void)updataPageCtl{
    pageCtl.currentPage = index;
}

-(void)autoScrImg{
   
    CGFloat aniTime;
    index ++ ;
    if (index == _imgUrls.count) {
        aniTime = 0.1;
    }else{
        aniTime = 0.5;
    }
    index = index % _imgUrls.count;
    
    [UIView animateWithDuration:aniTime animations:^{
        [self updataPageCtl];
        scrContentView.contentOffset = CGPointMake(KscreenWidth * index, scrContentView.contentOffset.y);
    }];
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView{
    
    index =(NSInteger)scrContentView.contentOffset.x / KscreenWidth;
    [self updataPageCtl];
}

-(void)imgItemClick{
    
    [self.delegate adsImgViewClick:index];
}


@end
