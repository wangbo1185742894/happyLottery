//
//  WBMenuAllItem.h
//  appmall
//
//  Created by 阿兹尔 on 2018/4/25.
//  Copyright © 2018年 com.tcsw.tkzy. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol WBMenuAllItemDelegate<NSObject>
-(void)wbMenuAllItemSelect:(NSInteger )index;
@end
@interface WBMenuAllItem : UIView
@property (weak,nonatomic)id <WBMenuAllItemDelegate >delegate;
-(void)refreshSelectItem:(NSArray *)selectItem;
@end
