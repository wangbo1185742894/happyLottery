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
   
    NSInteger index;
    UIPageControl *pageCtl;
    NSInteger count;
    
}
@property(nonatomic,strong)NSArray * imgUrls;
@end

@implementation WBAdsImgView

-(id)initWithFrame:(CGRect)frame{
    if (self == [super initWithFrame:frame]) {
        timer = [NSTimer scheduledTimerWithTimeInterval:3 target:self selector:@selector(autoScrImg) userInfo:nil repeats:YES];
        index = 0;
        _imgUrls = nil;
        pageCtl = [[UIPageControl alloc]initWithFrame:CGRectMake((KscreenWidth - 80) / 2, self.mj_h - 50, 80, 40)];
    }
    return self;
}

- (void)setImageUrlArray:(NSArray<ADSModel *> *)imgUrls placeImageName:(NSString *)imageName{
    if (scrContentView == nil) {
        scrContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth,self.mj_h)];
        scrContentView.delegate = self;
        scrContentView.pagingEnabled = YES;
        scrContentView.showsHorizontalScrollIndicator = NO;
        scrContentView.showsVerticalScrollIndicator = NO;
        scrContentView.bounces = NO;
        [self addSubview:scrContentView];
    }else{
        for (UIView *subView in scrContentView.subviews) {
            [subView removeFromSuperview];
        }
    }
    _imgUrls = imgUrls;
    if (imgUrls == nil||imgUrls.count==0) {//网络状态不好  或者数据未回来  预先加载本地banner图
        scrContentView.contentSize = CGSizeMake(KscreenWidth, scrContentView.mj_h);
        count = 1;
        UIButton *itemImg = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, self.mj_w, scrContentView.mj_h)];
        itemImg.imageView.contentMode = UIViewContentModeScaleToFill;
        [scrContentView addSubview:itemImg];
        itemImg.backgroundColor = RGBCOLOR(299, 221, 0);
        itemImg.adjustsImageWhenHighlighted = NO;
        [itemImg setBackgroundImage:[UIImage imageNamed:imageName] forState:0];
        return;
    }
    
    pageCtl.hidesForSinglePage = NO;
    scrContentView.contentSize = CGSizeMake(KscreenWidth * imgUrls.count, scrContentView.mj_h);
    if (imgUrls.count == 1) {
        pageCtl.hidden = YES;
    }else{
        pageCtl.hidden = NO;
    }
    for (int i = 0; i < imgUrls.count; i ++ ) {
        UIButton *itemImg = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth * i, 0, self.mj_w, scrContentView.mj_h)];
        itemImg.imageView.contentMode = UIViewContentModeScaleToFill;
        [scrContentView addSubview:itemImg];
        
        [itemImg addTarget:self action:@selector(imgItemClick) forControlEvents:UIControlEventTouchUpInside];
        itemImg.adjustsImageWhenHighlighted = NO;
        [itemImg setBackgroundImage:[UIImage imageNamed:imageName] forState:0];
        [itemImg sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrls[i].imgUrl] forState:0];
    }
    pageCtl.numberOfPages = imgUrls.count;
    if (imgUrls .count ==1) {
        pageCtl.hidden = YES;
    }
    [self addSubview:pageCtl];
}

- (void)stopTimer {
    [timer setFireDate:[NSDate distantFuture]];
}

- (void)openTimer {
    [timer setFireDate:[NSDate date]];
}

-(void)setImageUrlArray:(NSArray<ADSModel *> *)imgUrls{
    if (scrContentView == nil) {
        scrContentView = [[UIScrollView alloc]initWithFrame:CGRectMake(0, 0, KscreenWidth,self.mj_h)];
        scrContentView.delegate = self;
        scrContentView.pagingEnabled = YES;
        scrContentView.showsHorizontalScrollIndicator = NO;
        scrContentView.showsVerticalScrollIndicator = NO;
        scrContentView.bounces = NO;
        [self addSubview:scrContentView];
    }else{
        for (UIView *subView in scrContentView.subviews) {
            [subView removeFromSuperview];
        }
    }
    _imgUrls = imgUrls;
    if (imgUrls == nil||imgUrls.count==0) {//网络状态不好  或者数据未回来  预先加载本地banner图
        scrContentView.contentSize = CGSizeMake(KscreenWidth * 3, scrContentView.mj_h);
        count = 3;
        pageCtl.numberOfPages = 3;
        
        for (int i = 0; i < 3; i ++ ) {
            UIButton *itemImg = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth * i, 0, self.mj_w, scrContentView.mj_h)];
            itemImg.imageView.contentMode = UIViewContentModeScaleToFill;
            [scrContentView addSubview:itemImg];
            itemImg.backgroundColor = RGBCOLOR(299, 221, 0);
            itemImg.adjustsImageWhenHighlighted = NO;
            [itemImg setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ad_home%d",i + 1]] forState:0];
        }
        [self addSubview:pageCtl];
        
        return;
    }
    
    

    scrContentView.contentSize = CGSizeMake(KscreenWidth * imgUrls.count, scrContentView.mj_h);
    if (imgUrls.count == 1) {
        pageCtl.hidden = YES;
    }else{
        pageCtl.hidden = NO;
    }
   
    
    for (int i = 0; i < imgUrls.count; i ++ ) {
        UIButton *itemImg = [[UIButton alloc]initWithFrame:CGRectMake(KscreenWidth * i, 0, self.mj_w, scrContentView.mj_h)];
        itemImg.imageView.contentMode = UIViewContentModeScaleToFill;
        [scrContentView addSubview:itemImg];

        [itemImg addTarget:self action:@selector(imgItemClick) forControlEvents:UIControlEventTouchUpInside];
        itemImg.adjustsImageWhenHighlighted = NO;
        [itemImg setBackgroundImage:[UIImage imageNamed:[NSString stringWithFormat:@"ad_home%d.png",i + 1]] forState:0];
        [itemImg sd_setBackgroundImageWithURL:[NSURL URLWithString:imgUrls[i].imgUrl] forState:0];
    }
    pageCtl.numberOfPages = imgUrls.count;
    if (imgUrls .count ==1) {
        pageCtl.hidden = YES;
    }

    [self addSubview:pageCtl];
}

-(void)updataPageCtl{
    pageCtl.currentPage = index;
}

-(void)autoScrImg{
    if (_imgUrls.count != 0) {
        count = _imgUrls.count;
    }
    if (count == 1) {
        return;
    }
    CGFloat aniTime;
    index ++ ;
    if (index == count) {
        aniTime = 0.1;
    }else{
        aniTime = 0.5;
    }

    index = index % count;
    
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
    
    [self.delegate adsImgViewClick:_imgUrls[index] navigation:nil];
}


@end
