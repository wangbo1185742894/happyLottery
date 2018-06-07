//
//  ShareViewController.m
//  happyLottery
//
//  Created by LYJ on 2018/1/3.
//  Copyright © 2018年 onlytechnology. All rights reserved.
//

#import "ShareViewController.h"
#import "ConversionCodeViewController.h"
#import <ShareSDK/ShareSDK+Base.h>
#import <ShareSDKUI/ShareSDK+SSUI.h>
#import <ShareSDK/NSMutableDictionary+SSDKShare.h>
#import <MOBFoundation/MOBFoundation.h>


@interface ShareViewController ()<MemberManagerDelegate>{
    UIButton *menuButton;
    NSString *codeurl;
}
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIImageView *codeImage;
@property (weak, nonatomic) IBOutlet UILabel *codeLab;
@property (weak, nonatomic) IBOutlet UIButton *shareBtn;
@property (weak, nonatomic) IBOutlet UILabel *labCode;
@property (weak, nonatomic) IBOutlet UIImageView *lab2;
@property (weak, nonatomic) IBOutlet UIButton *coedBtn;
@property (weak, nonatomic) IBOutlet UILabel *lab2inf;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *topDisShare;

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
    if ([self.curUser.memberType isEqualToString:@"CIRCLE_MASTER"]) {
     
    }else{
        self.lab2.hidden = YES;
        self.lab2inf.hidden = YES;
        self.labCode.hidden = YES;
        self.topDisShare.constant = 140;
    }
    
    self.memberMan.delegate = self;
   // [self getQRCodeClient];
    codeurl = [self getShareUrl];
    [self initCode];
}

-(NSString *)getShareUrl{
    
    if ([self.curUser.memberType isEqualToString:@"CIRCLE_MASTER"]) {
        return  [NSString stringWithFormat:@"%@%@?shareCode=%@",H5BaseAddress,KcircleRegister,self.curUser.shareCode];
    }else{
        return  [NSString stringWithFormat:@"%@%@?shareCode=%@",H5BaseAddress,KcircleRegisterCopy,self.curUser.shareCode];
    }
}

- (IBAction)shareBtnClick:(id)sender {
    [self initshare];
}

-(void)initshare{
    NSString *code=self.curUser.shareCode;
//    if (code.length>0) { 
//              = [NSString stringWithFormat:@"tfi.11max.com/Tbz/ShareByCode?shareCode=%@",code];
 
//    }CIRCLE_MASTER("圈主"), CIRCLE_PERSON("圈民"), FREEDOM_PERSON("自由人");
    NSString *url = [self getShareUrl];
  
    NSMutableDictionary *shareParams = [NSMutableDictionary dictionary];
    NSArray* imageArray = @[[[NSBundle mainBundle] pathForResource:@"logo120@2x" ofType:@"png"]];
    [shareParams SSDKSetupShareParamsByText:@"千万大奖集聚地，新用户即享188元豪礼。积分商城优惠享不停！"
                                     images:imageArray
                                        url:[NSURL URLWithString:url]
                                      title:@"送您188元新人大礼包！点击领取"
                                       type:SSDKContentTypeWebPage];

    [ShareSDK showShareActionSheet:nil
                             items:@[@(SSDKPlatformSubTypeWechatSession),@(SSDKPlatformSubTypeWechatTimeline)]
                       shareParams:shareParams
               onShareStateChanged:^(SSDKResponseState state, SSDKPlatformType platformType, NSDictionary *userData, SSDKContentEntity *contentEntity, NSError *error, BOOL end) {
                   
                   switch (state) {
                           
                       case SSDKResponseStateBegin:
                       {
                           //设置UI等操作
                           //Instagram、Line等平台捕获不到分享成功或失败的状态，最合适的方式就是对这些平台区别对待
                           if (platformType == SSDKPlatformSubTypeWechatSession)
                           {
                               [self giveShareScoreClient];
                               break;
                           }
                           break;
                       }
                       case SSDKResponseStateSuccess:
                       {
                       
                           
                           UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享成功"
                                                                               message:nil
                                                                              delegate:nil
                                                                     cancelButtonTitle:@"确定"
                                                                     otherButtonTitles:nil];
                           [alertView show];
                           if (platformType == SSDKPlatformSubTypeWechatTimeline)
                           {
                               [self giveShareScoreClient];
                        
                           }
                           break;
                       }
                       case SSDKResponseStateFail:
                       {
                           NSLog(@"%@",error);
                           UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"分享失败"
                                                                           message:[NSString stringWithFormat:@"%@",error]
                                                                          delegate:nil
                                                                 cancelButtonTitle:@"OK"
                                                                 otherButtonTitles:nil, nil];
                           [alert show];
                           break;
                       }
                       case SSDKResponseStateCancel:
                       {
                           if (userData != nil) {
                               UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:@"分享已取消"
                                                                                   message:nil
                                                                                  delegate:nil
                                                                         cancelButtonTitle:@"确定"
                                                                         otherButtonTitles:nil];
                               [alertView show];
                           }
                           break;
                       }
                       default:
                           break;
                   }
               }];
        
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
        return;
    }
        [self.memberMan getQRCode:Info];

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

-(void)giveShareScoreClient{
    NSDictionary *Info;
    @try {
        
        Info = @{@"cardCode":self.curUser.cardCode
                 };
        
    } @catch (NSException *exception) {
        return;
    }
    [self.memberMan giveShareScore:Info];
    
}

-(void)giveShareScore:(BOOL)success errorMsg:(NSString *)msg{
    if ([msg isEqualToString:@"执行成功"]) {
         // [self showPromptText: @"积分赠送成功" hideAfterDelay: 1.7];
        
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
- (IBAction)saveErCodeToLocal:(id)sender {
    [self loadImageFinished:self.codeImage.image];
}
- (void)loadImageFinished:(UIImage *)image
{
    UIImageWriteToSavedPhotosAlbum(image, self, @selector(image:didFinishSavingWithError:contextInfo:), (__bridge void *)self);
}

- (void)image:(UIImage *)image didFinishSavingWithError:(NSError *)error contextInfo:(void *)contextInfo
{
    
    if (error == nil) {
        [self showPromptText:@"保存成功" hideAfterDelay:1.9];
    }else{
        [self showPromptText:@"保存失败" hideAfterDelay:1.9];
    }
}


@end
