//
//  TabTopAdsViewCell.m
//  appmall
//
//  Created by 王博 on 2018/4/23.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import "HomeTabTopAdsViewCell.h"
#import "WBAdsImgView.h"

@interface HomeTabTopAdsViewCell()<WBAdsImgViewDelegate>{
    WBAdsImgView *adsView;
}
@end

@implementation HomeTabTopAdsViewCell

-(id)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        if (adsView == nil) {
            
            adsView = [[WBAdsImgView alloc]initWithFrame:CGRectMake(0,5,KscreenWidth, 102-4)];
            adsView.contentMode = UIViewContentModeScaleAspectFit;
            adsView.delegate = self;
            [self addSubview:adsView];
        }
        [adsView setImageUrlArray:nil placeImageName:@"genadnbanner"];
    }
    return self;
}

- (void)stopTimer {
    [adsView stopTimer];
}

- (void)openTimer {
    [adsView openTimer];
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)loadData:(NSArray *)model{
    [adsView setImageUrlArray:model placeImageName:@"genadnbanner"];
}

-(void)adsImgViewClick:(ADSModel *)itemIndex navigation:(UINavigationController *)navgC{
    [self.delegate itemClickInTop:itemIndex];
}

@end
