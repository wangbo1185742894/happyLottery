//
//  MineRecommendViewCell.h
//  appmall
//
//  Created by 壮壮 on 15/04/2018.
//  Copyright © 2018 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol RecommendViewCellDelegate<NSObject>

-(void)recommendViewCellClick:(NSDictionary *)selectDic;

@end

@interface MineRecommendViewCell : UITableViewCell

@property (weak, nonatomic) IBOutlet UILabel *labTitle;

@property (nonatomic,strong) NSArray *listUseRedPacketArray;

@property(weak,nonatomic)id <RecommendViewCellDelegate>delegate;

@property (nonatomic,assign) BOOL login;
@property (nonatomic,assign) long rednum;

- (void)reloadDate:(NSArray *)groupArray;


@end
