//
//  ZHTableViewCell.h
//  Lottery
//
//  Created by 关阿龙 on 15/10/16.
//  Copyright © 2015年 AMP. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "OrderProfile.h"

@interface ZHTableViewCell : UITableViewCell{
    
    __weak IBOutlet UILabel *labLeShanCode;
    __weak IBOutlet UILabel *xuhao;
    __weak IBOutlet UIImageView *tupian;
    __weak IBOutlet UILabel *qihao;
    __weak IBOutlet UILabel *dangqi;
    __weak IBOutlet UILabel *leiji;
    __weak IBOutlet UILabel *zhongjiang;
    __weak IBOutlet UILabel *kaijianghaoma;
    __weak IBOutlet UILabel *jieguo;
}
-(void)orderInfoShow1:(OrderProfile *)order index:(NSString *)index leiji:(NSString *)touru;
@end
