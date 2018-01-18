//
//  ShareViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/3.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ShareViewController.h"
#import "ConversionCodeViewController.h"

@interface ShareViewController ()<MemberManagerDelegate>{
    
    NSString *codeurl;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UIButton *coedBtn;

@end

@implementation ShareViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"分享";
    if ([self isIphoneX]) {
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    NSString *code=self.curUser.shareCode;
    if (code.length>0) {
        self.codeLab.text=code;
    }
    self.memberMan.delegate = self;
   // [self getQRCodeClient];
    codeurl = @"tfi.11max.com/Tbz/DownLoad";
    [self initCode];
}

- (IBAction)shareBtnClick:(id)sender {
}
- (IBAction)codeBtnClick:(id)sender {
    ConversionCodeViewController *w = [[ConversionCodeViewController alloc]init];
    w.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:w animated:YES];
}

-(void)initCode{
    
    // 1. 实例化二维码滤镜
    CIFilter *filter = [CIFilter filterWithName:@"CIQRCodeGenerator"];
    // 2. 恢复滤镜的默认属性
    [filter setDefaults];
    
    // 3. 将字符串转换成NSData
    NSString *urlStr = codeurl;//测试二维码地址,次二维码不能支付,需要配合服务器来二维码的地址(跟后台人员配合)
    NSData *data = [urlStr dataUsingEncoding:NSUTF8StringEncoding];
    // 4. 通过KVO设置滤镜inputMessage数据
    [filter setValue:data forKey:@"inputMessage"];
    
    // 5. 获得滤镜输出的图像
    CIImage *outputImage = [filter outputImage];
    
    // 6. 将CIImage转换成UIImage，并放大显示 (此时获取到的二维码比较模糊,所以需要用下面的createNonInterpolatedUIImageFormCIImage方法重绘二维码)
    //    UIImage *codeImage = [UIImage imageWithCIImage:outputImage scale:1.0 orientation:UIImageOrientationUp];
    
    UIImageView *wechatImageView = [[UIImageView alloc] initWithFrame:CGRectMake(40, 30, SCREEN_WIDTH - 80, SCREEN_WIDTH - 80)];
     self.codeImage.image = [self createNonInterpolatedUIImageFormCIImage:outputImage withSize:200];//重绘二维码,使其显示清晰
}

/**
 * 根据CIImage生成指定大小的UIImage
 *
 * @param image CIImage
 * @param size 图片宽度
 */
- (UIImage *)createNonInterpolatedUIImageFormCIImage:(CIImage *)image withSize:(CGFloat) size
{
    CGRect extent = CGRectIntegral(image.extent);
    CGFloat scale = MIN(size/CGRectGetWidth(extent), size/CGRectGetHeight(extent));
    // 1.创建bitmap;
    size_t width = CGRectGetWidth(extent) * scale;
    size_t height = CGRectGetHeight(extent) * scale;
    CGColorSpaceRef cs = CGColorSpaceCreateDeviceGray();
    CGContextRef bitmapRef = CGBitmapContextCreate(nil, width, height, 8, 0, cs, (CGBitmapInfo)kCGImageAlphaNone);
    CIContext *context = [CIContext contextWithOptions:nil];
    CGImageRef bitmapImage = [context createCGImage:image fromRect:extent];
    CGContextSetInterpolationQuality(bitmapRef, kCGInterpolationNone);
    CGContextScaleCTM(bitmapRef, scale, scale);
    CGContextDrawImage(bitmapRef, extent, bitmapImage);
    // 2.保存bitmap到图片
    CGImageRef scaledImage = CGBitmapContextCreateImage(bitmapRef);
    CGContextRelease(bitmapRef);
    CGImageRelease(bitmapImage);
    return [UIImage imageWithCGImage:scaledImage];
}

-(void)getQRCodeClient{
    NSDictionary *Info;
    @try {

        Info = @{@"clientType":@"IOS",
                 @"channelCode":@"TBZ"
                 };
        
    } @catch (NSException *exception) {
        Info = nil;
    } @finally {
        [self.memberMan getQRCode:Info];
    }
    
}

-(void)getQRCodeStateSms:(NSString *)Info IsSuccess:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
          NSLog(@"Info%@",Info);
        //  [self showPromptText: @"getQRCodeStateSms成功" hideAfterDelay: 1.7];
        
        codeurl = [Info substringWithRange:NSMakeRange(1,Info.length-2)];
        [self initCode];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
