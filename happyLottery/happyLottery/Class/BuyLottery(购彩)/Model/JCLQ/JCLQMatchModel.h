//
//  JCLQMatchModel.h
//  Lottery
//
//  Created by 王博 on 16/8/17.
//  Copyright © 2016年 AMP. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface JCLQMatchModel : NSObject

@property (nonatomic , strong) NSString *guestFullName;
@property (nonatomic , strong) NSString *guestName;
@property (nonatomic , strong) NSString *handicap;
@property (nonatomic , strong) NSString *hilo;
@property (nonatomic , strong) NSString *homeFullName;
@property (nonatomic , strong) NSString *homeName;
@property (nonatomic , strong) NSString *hot;
@property (nonatomic , strong) NSString *_id;
@property (nonatomic , strong) NSString *leagueColor;
@property (nonatomic , strong) NSString *leagueFullName;
@property (nonatomic , strong) NSString *leagueName;
@property (nonatomic , strong) NSString *lineId;
@property (nonatomic , strong) NSString *matchDate;
@property (nonatomic , strong) NSString *matchKey;
@property (nonatomic , strong) NSString *openFlag;
@property (nonatomic , strong) NSString *remark;
@property (nonatomic , strong) NSString *startTime;
@property (nonatomic , strong) NSString *status;
@property (nonatomic , strong) NSString *stopBuyTime;
@property (nonatomic , strong) NSString *version;
@property (nonatomic , strong) NSString *wnm;
@property (nonatomic , strong) NSString *modifyTime;

@property BOOL isDanGuan;

@property BOOL isShowHisInfo;

@property(nonatomic,strong)NSMutableArray *SFSelectMatch;
@property(nonatomic,strong)NSMutableArray *RFSFSelectMatch;
@property(nonatomic,strong)NSMutableArray *SFCSelectMatch;
@property(nonatomic,strong)NSMutableArray *DXFSelectMatch;


@property(nonatomic,strong)NSMutableArray *SFOddArray;
@property(nonatomic,strong)NSMutableArray *RFSFOddArray;
@property(nonatomic,strong)NSMutableArray *SFCOddArray;
@property(nonatomic,strong)NSMutableArray *DXFSOddArray;


@property(nonatomic,assign)CGFloat cellHeight;
//用来标记本赛事是否被选过。
@property(nonatomic,assign)BOOL isSelected;

-(id)initWithDic:(NSDictionary *)dic;

-(NSInteger)sumSelectPlayType:(NSArray*)array;

-(NSString *)getTouzhuAppearTitleByTypeNoSp:(NSString *)type;
-(CGFloat)getHeight;
@end
