//
//  PersonnalCenterViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
#import "PersonnalCenterViewController.h"
#import "MyNickSetViewController.h"
#import "RSKImageCropper.h"
#import "PaySetViewController.h"
#import "SetPayPWDViewController.h"
#import "ChangePayPWDViewController.h"
#import "FirstBankCardSetViewController.h"
#import "BankCardSettingViewController.h"
#import "LoadData.h"
#import "ChangeLoginPWDViewController.h"
#import "JPUSHService.h"
#import "QYSDK.h"
@interface PersonnalCenterViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,MemberManagerDelegate>{
     NSString *headUrl;
     NSString *titleStr;
}
@property (weak, nonatomic) IBOutlet UIWebView *web123;
@property (weak, nonatomic) IBOutlet UIImageView *labMemberIcon;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UIView *contentView;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *top;
@property (weak, nonatomic) IBOutlet UIButton *myImageBtn;
@property (weak, nonatomic) IBOutlet UIImageView *myImage;
@property (weak, nonatomic) IBOutlet UIButton *memberBtn;
@property (weak, nonatomic) IBOutlet UILabel *memberLab;
@property (weak, nonatomic) IBOutlet UIButton *myNickBtn;
@property (weak, nonatomic) IBOutlet UILabel *myNickLab;
@property (weak, nonatomic) IBOutlet UIButton *myCardBtn;
@property (weak, nonatomic) IBOutlet UILabel *myCardLab;
@property (weak, nonatomic) IBOutlet UIButton *paySetBtn;
@property (weak, nonatomic) IBOutlet UIButton *updateLoginPWDBtn;
@property (weak, nonatomic) IBOutlet UIButton *updatePayPWDBtn;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottom;
@property (weak, nonatomic) IBOutlet UILabel *telephone;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *bottomCons;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *imageBottom;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *heightCons;

@property(nonatomic,strong)LoadData *loadDataTool;
@end

@implementation PersonnalCenterViewController

-(void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    [self loadUserInfo];
    
    
     if (self.curUser.bankBinding == 0) {
        titleStr = @"银行卡设置";
        self.myCardLab.hidden = NO;
    } else {
        //titleStr = @"银行卡添加";
        self.myCardLab.hidden = YES;
    }
    self.telephone.hidden = NO;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
     self.automaticallyAdjustsScrollViewInsets = NO;
    self.viewControllerNo = @"";
    if ([self isIphoneX]) {
        
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    if ([self isIphone5s]) {
        
        self.bottomCons.constant = 18;
        self.imageBottom.constant = 10;

    }else {
        
        self.bottomCons.constant = 86;
        self.imageBottom.constant = 28;
        

    }
    
    self.memberMan.delegate = self;
    self.myImage.layer.cornerRadius = self.myImage.mj_h/2;
    self.myImage.layer.masksToBounds = YES;
    self.labMemberIcon.layer.cornerRadius = 5;
    self.labMemberIcon.layer.masksToBounds = YES;
}

-(void)loadUserInfo{
   
    NSString *userName;
    if (self.curUser.nickname.length == 0) {
        userName = self.curUser.mobile;
    }else{
        userName = self.curUser.nickname;
    }
    self.myNickLab.text =userName;
    self.telephone.text = self.curUser.mobile;
    self.memberLab.text = self.curUser.cardCode;
    //[_userImage sd_setImageWithURL:[NSURL URLWithString:self.curUser.headUrl]];
    
    if ([self.curUser.headUrl isEqualToString:@""] || self.curUser.headUrl == nil) {
        self.myImage.image = [UIImage imageNamed:@"user_mine.png"];
    }else{
        [self.myImage sd_setImageWithURL:[NSURL URLWithString:self.curUser.headUrl]];

    }
}



- (IBAction)updateImage:(id)sender {
    UIActionSheet *choseSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中获取",nil];
    [choseSheet showInView:self.view];
}

- (IBAction)setMember:(id)sender {
}
- (IBAction)setNick:(id)sender {
    MyNickSetViewController * nickVC = [[MyNickSetViewController alloc]init];
   // self.hidesBottomBarWhenPushed = YES;
    [self.navigationController pushViewController:nickVC animated:YES];
}
- (IBAction)addCard:(id)sender {
     if (self.curUser.bankBinding == 0) {
        FirstBankCardSetViewController *fvc = [[FirstBankCardSetViewController alloc]init];
        fvc.titleStr=titleStr;
        [self.navigationController pushViewController:fvc animated:YES];
    
    } else {
        BankCardSettingViewController *bvc = [[BankCardSettingViewController alloc]init];
       
        [self.navigationController pushViewController:bvc animated:YES];
         
      
    }
    
}

- (IBAction)cardPaySet:(id)sender {
    PaySetViewController *pvc = [[PaySetViewController alloc]init];
    [self.navigationController pushViewController:pvc animated:YES];
}

- (IBAction)changePayPWD:(id)sender {
    if(self.curUser.paypwdSetting == NO) {
        SetPayPWDViewController *spvc = [[SetPayPWDViewController alloc]init];
        spvc.titleStr = @"设置支付密码";
        [self.navigationController pushViewController:spvc animated:YES];
    } else {
        ChangePayPWDViewController *cpvc = [[ChangePayPWDViewController alloc]init];
        [self.navigationController pushViewController:cpvc animated:YES];
    }
}
- (IBAction)changeLoginPWD:(id)sender {
    ChangeLoginPWDViewController *spvc = [[ChangeLoginPWDViewController alloc]init];
    [self.navigationController pushViewController:spvc animated:YES];
}





#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
         NSUInteger sourceType = 0;
    // 判断是否支持相机
    if([UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        switch (buttonIndex) {
            case 2:
                // 取消
                return;
            case 0:
                // 相机
                sourceType =  UIImagePickerControllerSourceTypeCamera;
                break;
                
            case 1:
                // 相册
                sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
                break;
        }
    }
    else {
        if (buttonIndex == 2) {
            
            return;
        } else {
            sourceType = UIImagePickerControllerSourceTypeSavedPhotosAlbum;
        }
    }
    
    // 跳转到相机或相册页面
    UIImagePickerController *imagePickerController = [[UIImagePickerController alloc] init];
    
    imagePickerController.delegate = self;
    
    imagePickerController.allowsEditing = YES;
    
    imagePickerController.sourceType = sourceType;
    
    [self presentViewController:imagePickerController animated:YES completion:^{}];
    
}

#pragma mark camera utility
- (BOOL) isCameraAvailable{
    return [UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isRearCameraAvailable{
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceRear];
}

- (BOOL) isFrontCameraAvailable {
    return [UIImagePickerController isCameraDeviceAvailable:UIImagePickerControllerCameraDeviceFront];
}

- (BOOL) doesCameraSupportTakingPhotos {
    return [self cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypeCamera];
}

- (BOOL) isPhotoLibraryAvailable{
    return [UIImagePickerController isSourceTypeAvailable:
            UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickVideosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeMovie sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}
- (BOOL) canUserPickPhotosFromPhotoLibrary{
    return [self
            cameraSupportsMedia:(__bridge NSString *)kUTTypeImage sourceType:UIImagePickerControllerSourceTypePhotoLibrary];
}

- (BOOL) cameraSupportsMedia:(NSString *)paramMediaType sourceType:(UIImagePickerControllerSourceType)paramSourceType{
    __block BOOL result = NO;
    if ([paramMediaType length] == 0) {
        return NO;
    }
    NSArray *availableMediaTypes = [UIImagePickerController availableMediaTypesForSourceType:paramSourceType];
    [availableMediaTypes enumerateObjectsUsingBlock: ^(id obj, NSUInteger idx, BOOL *stop) {
        NSString *mediaType = (NSString *)obj;
        if ([mediaType isEqualToString:paramMediaType]){
            result = YES;
            *stop= YES;
        }
    }];
    return result;
}

#pragma 相册选择



- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingImage:(UIImage *)image editingInfo:(NSDictionary *)editingInfo NS_DEPRECATED_IOS(2_0, 3_0)
{
    //
    
    //上传，等待回传设置
    //[self updateFaceRequest:image];
    

////    UIImage * chosenImage = editingInfo[UIImagePickerControllerEditedImage];
//    UIImageView * picImageView = (UIImageView *)[self.view viewWithTag:500];
//    picImageView.image = image;
//    // chosenImage = [self imageWithImageSimple:chosenImage scaledToSize:CGSizeMake(60, 60)];
//
//    NSData * imageData = UIImageJPEGRepresentation(image, 0.9);
//     NSDictionary* uploadFaceDic=@{@"memberAvatar":@[imageData]};
//    //    [self saveImage:chosenImage withName:@"avatar.png"];
//    //    NSURL * filePath = [NSURL fileURLWithPath:[self documentFolderPath]];
//    //将图片上传到服务器
//    //    --------------------------------------------------------
//    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:nil];
//    //[manager.requestSerializer setValue:@"application/json" forHTTPHeaderField:@"Accept"];
//    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
//   //manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/json", nil];
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/xml; charset=utf-8"];
//    NSString * urlString = [NSString stringWithFormat:@"%@/app/head/url?",BASE_URL];
//    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
//    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:1];
//    //[dict setObject:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
//    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //通过post请求上传用户头像图片,name和fileName传的参数需要跟后台协商,看后台要传的参数名
//        [formData appendPartWithFileData:imageData name:@"photo" fileName:@"img.jpg" mimeType:@"image/jpg"];
//
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//        //解析后台返回的结果,如果不做一下处理,打印结果可能是一些二进制流数据
//        NSError *error;
//        NSDictionary * imageDict = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingMutableContainers error:&error];
//        //上传成功后更新数据
//        //  self.personModel.adperurl = imageDict[@"adperurl"];
//        NSLog(@"上传图片成功0---%@",imageDict);
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//        NSLog(@"上传图片-- 失败  -%@",error);
//    }];
//    [picker dismissViewControllerAnimated:YES completion:^{
//        
//    }];
   
//    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
//    imageCropVC.delegate = self;
//    [self.navigationController pushViewController:imageCropVC animated:YES];
//
//    [picker dismissViewControllerAnimated:YES completion:nil];

    
    
}

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info
{
            NSLog(@"info: %@", info);
    [picker dismissViewControllerAnimated:YES completion:^{}];
    
    UIImage *image = [info objectForKey:UIImagePickerControllerEditedImage];
    
    //01.21 应该在提交成功后再保存到沙盒，下次进来直接去沙盒路径取
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    //读取路径进行上传
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    NSDictionary *dic = @{@"image":fullPath}; //重点再次 fullPath 为路径
    [self UploadImage:dic];
//    isFullScreen = NO;
//    self.headImgV.tag = 100;
//    [self.headImgV setImage:savedImage];//图片赋值显示
    
 
//        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
//        imageCropVC.delegate = self;
//        [self.navigationController pushViewController:imageCropVC animated:YES];
    //进到次方法时 调 UploadImage 方法上传服务端
   
      //  [picker dismissViewControllerAnimated:YES completion:nil];
}

//头像上传
-(void)UploadImage:(NSDictionary *)dic
{
    
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    
    //网址
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain; charset=utf-8"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/json", nil];
    NSString * imgpath = [NSString stringWithFormat:@"%@",dic[@"image"]];
    UIImage *image = [UIImage imageWithContentsOfFile:imgpath];
    UIImage *newImage=[self image:image scaleToSize:CGSizeMake(SCREEN_WIDTH, SCREEN_WIDTH)];
    [newImage drawInRect:CGRectMake(0, 0, 60, 60)];
    NSData *data = UIImageJPEGRepresentation(newImage,1.0);
   // NSDictionary *parameters =@{@"photo":data};
    
    
    NSString *urlString =[NSString stringWithFormat:@"%@/app/head/url",[GlobalInstance instance].homeUrl];
    
//    urlString=[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData>  _Nonnull formData) {
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:data name:@"photo" fileName:fileName mimeType:@"image/jpg"];
        
    }  progress:nil success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        
        
        NSString *resultStr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *itemInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([itemInfo[@"code"] isEqualToString:@"0000"]) {
             headUrl = itemInfo[@"result"];  //图片url
            NSLog(@"headUrl: %@", headUrl);
            [self updateHeadImageClient];
        }
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        
        NSLog(@"Error: %@", error);
    }];
    
//    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
//        //01.21 测试
//
//
//
//        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
//        formatter.dateFormat = @"yyyyMMddHHmmss";
//        NSString *str = [formatter stringFromDate:[NSDate date]];
//        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
//        [formData appendPartWithFileData:data name:@"photo" fileName:fileName mimeType:@"image/jpg"];
//
//    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
//
//
//        NSString *resultStr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
//        NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
//        NSDictionary *itemInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//
//
//        if ([itemInfo[@"code"] isEqualToString:@"0000"]) {
//            headUrl = itemInfo[@"result"];  //图片url
//            NSLog(@"headUrl: %@", headUrl);
//            [self updateHeadImageClient];
//        }
//
//    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
//
//        NSLog(@"Error: %@", error);
//    }];
    

    
}


/**
 *将图片缩放到指定的CGSize大小
 * UIImage image 原始的图片
 * CGSize size 要缩放到的大小
 */
-(UIImage*)image:(UIImage *)image scaleToSize:(CGSize)size{
    
    // 得到图片上下文，指定绘制范围
    UIGraphicsBeginImageContext(size);
    
    // 将图片按照指定大小绘制
    [image drawInRect:CGRectMake(0, 0, size.width, size.height)];
    
    // 从当前图片上下文中导出图片
    UIImage* scaledImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // 当前图片上下文出栈
    UIGraphicsEndImageContext();
    
    // 返回新的改变大小后的图片
    return scaledImage;
}



-(void)updateHeadImageClient{
    NSDictionary *Info;
    @try {
        NSString *cardCode =self.curUser.cardCode;
        Info = @{@"cardCode":cardCode,
                 @"headUrl":headUrl
                 };
       
    } @catch (NSException *exception) {
        return;
    }
      [self.memberMan updateImage:Info];
 
}

-(void)updateImage:(BOOL)success errorMsg:(NSString *)msg{
    
    if ([msg isEqualToString:@"执行成功"]) {
        // NSLog(@"%@",bankInfo);
        [self showPromptText: @"修改会员头像成功" hideAfterDelay: 1.7];
        [self.myImage sd_setImageWithURL:[NSURL URLWithString:headUrl]];
    }else{
        [self showPromptText: msg hideAfterDelay: 1.7];
    }
}

#pragma mark - 保存图片至沙盒（应该是提交后再保存到沙盒,下次直接去沙盒取）
- (void) saveImage:(UIImage *)currentImage withName:(NSString *)imageName
{
    
    NSData *imageData = UIImageJPEGRepresentation(currentImage, 0.5);
    // 获取沙盒目录
    
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:imageName];
    // 将图片写入文件
    
    [imageData writeToFile:fullPath atomically:NO];
}



#pragma mark - RSKImageCropViewControllerDelegate

- (void)imageCropViewControllerDidCancelCrop:(RSKImageCropViewController *)controller
{
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)imageCropViewController:(RSKImageCropViewController *)controller didCropImage:(UIImage *)croppedImage usingCropRect:(CGRect)cropRect
{
    //[self.addPhotoButton setImage:croppedImage forState:UIControlStateNormal];
    //上传，等待回传设置
    //[self updateFaceRequest:croppedImage];
    
    [self.navigationController popViewControllerAnimated:YES];
    
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //NSLog(@"222222");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)updateLoginStatus{
    
    if ([self.fmdb open]) {
        NSString *mobile =self.curUser.mobile;
        NSString * isLogin =@"0";
        //update t_student set score = age where name = ‘jack’ ;
        [self.fmdb executeUpdate:@"update  t_user_info set isLogin = ? where mobile = ?",isLogin, mobile];
        [self.fmdb close];
    }
}

- (IBAction)outLogin:(id)sender {
  
    self.curUser.isLogin = NO;
    [[QYSDK sharedSDK]logout:^{
        
    }];
    [self updateLoginStatus];
    [JPUSHService setTags:nil alias:@"" callbackSelector:@selector(tagsAliasCallback:tags:alias:) object:self];
    [self.navigationController popViewControllerAnimated:YES];
}

- (void)tagsAliasCallback:(int)iResCode tags:(NSSet*)tags alias:(NSString*)alias {
    NSLog(@"rescode: %d, \ntags: %@, \nalias: %@\n", iResCode, tags , alias);
}
@end
