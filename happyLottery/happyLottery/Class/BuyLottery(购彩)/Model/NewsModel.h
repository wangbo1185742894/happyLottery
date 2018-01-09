//
//  NewsModel.h
//  happyLottery
//
//  Created by 王博 on 2018/1/9.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "BaseModel.h"

@interface NewsModel : BaseModel

@property(nonatomic,copy)NSString * linkUrl;
@property(nonatomic,copy)NSString * visitNum;
@property(nonatomic,copy)NSString * title;
@property(nonatomic,copy)NSString * newsTime;
@property(nonatomic,copy)NSString * titleImgUrl;

@end
