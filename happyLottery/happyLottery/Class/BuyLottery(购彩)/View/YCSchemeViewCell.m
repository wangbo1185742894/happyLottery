//
//  YCSchemeViewCell.m
//  happyLottery
//
//  Created by 王博 on 2018/1/22.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "YCSchemeViewCell.h"

@implementation YCSchemeViewCell

-(instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    
    
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        self = [[[NSBundle mainBundle] loadNibNamed:@"YCSchemeViewCell" owner: nil options:nil] lastObject];
    }
    return self;
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

}

-(void)loadData:(NSDictionary *)infoDic{
    if (progressView == nil) {
        progressView = [[WBLoopProgressView alloc]initWithFrame:CGRectMake(20,40, 150, 150)];
        progressView.color1 = [UIColor whiteColor];
        
        progressView.color2 = SystemLightGray;
        
        
        [self addSubview:progressView];
    }
 
    self.labAVGShouyi.text = [NSString stringWithFormat:@"%.0f%%",[infoDic[@"earnings"] doubleValue] * 100] ;
    progressView.progress =[infoDic[@"hitRate"] doubleValue];
}

@end
