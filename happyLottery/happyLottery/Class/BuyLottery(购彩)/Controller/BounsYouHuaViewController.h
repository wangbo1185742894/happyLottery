//
//  BounsYouHuaViewController.h
//  happyLottery
//
//  Created by 阿兹尔 on 2018/7/27.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseViewController.h"
#import "JCZQTranscation.h"
@class BounsModelItem;

@interface BounsYouHuaViewController : BaseViewController
@property(nonatomic,assign)SchemeType fromSchemeType;
@property(nonatomic,strong)JCZQTranscation *transcation;
@property(nonatomic,strong)NSMutableArray <BounsModelItem *> * zhuArray;

@end

@interface BounsModelBet:NSObject
@property(nonatomic,strong)NSString * lineId;
@property(nonatomic,strong)NSString * homeName;
@property(nonatomic,strong)NSString * playType;
@property(nonatomic,strong)NSString * sp;
@property(nonatomic,strong)NSString * clash;
@property(nonatomic,strong)NSString * matchKey;



@end

@interface BounsModelItem:NSObject
@property(nonatomic,strong)NSMutableArray <BounsModelBet *>*selectItemList;

@property(nonatomic,strong)NSString * multiple;
@property(nonatomic,assign)CGFloat  bouns;
-(CGFloat)getSp;
- (NSDictionary *)lottDataScheme;
@end


