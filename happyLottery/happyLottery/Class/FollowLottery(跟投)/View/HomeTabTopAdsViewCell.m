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
            adsView = [[WBAdsImgView alloc]initWithFrame:CGRectMake(0,0, KscreenWidth, 80)];
            adsView.delegate = self;
            [self addSubview:adsView];
        }
        [adsView setImageUrlArray:nil];
    }
    return self;
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    
}
-(void)loadData:(id *)model{
    
}
-(void)adsImgViewClick:(id*)itemIndex{
    
}

@end
