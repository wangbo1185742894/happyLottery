//
//  PersonnalCenterViewController.m
//  happyLottery
//
//  Created by LYJ on 2017/12/18.
//  Copyright © 2017年 onlytechnology. All rights reserved.
//

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


@interface PersonnalCenterViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate,MemberManagerDelegate>{
     NSString *headUrl;
     NSString *titleStr;
}
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
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"个人信息";
    self.viewControllerNo = @"";
    if ([self isIphoneX]) {
        // self.bigView.translatesAutoresizingMaskIntoConstraints = NO;
        self.top.constant = 88;
        self.bottom.constant = 34;
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
    self.myNickLab.text = userName;
    self.memberLab.text = self.curUser.cardCode;
    //[_userImage sd_setImageWithURL:[NSURL URLWithString:self.curUser.headUrl]];
    
    if ([self.curUser.headUrl isEqualToString:@""] || self.curUser.headUrl == nil) {
        self.myImage.image = [UIImage imageNamed:@"usermine.png"];
    }else{
        
        self.myImage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:self.curUser.headUrl]]];
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
    
//
//    NSString * BASE_URL = @"http://192.168.88.244:8086";
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
    
    UIImage *image = [info objectForKey:UIImagePickerControllerOriginalImage];
    
    //01.21 应该在提交成功后再保存到沙盒，下次进来直接去沙盒路径取
    // 保存图片至本地，方法见下文
    [self saveImage:image withName:@"currentImage.png"];
    //读取路径进行上传
    NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
    UIImage *savedImage = [[UIImage alloc] initWithContentsOfFile:fullPath];
    
//    isFullScreen = NO;
//    self.headImgV.tag = 100;
//    [self.headImgV setImage:savedImage];//图片赋值显示
    
 
//        RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
//        imageCropVC.delegate = self;
//        [self.navigationController pushViewController:imageCropVC animated:YES];
    //进到次方法时 调 UploadImage 方法上传服务端
    NSDictionary *dic = @{@"image":fullPath}; //重点再次 fullPath 为路径
    [self UploadImage:dic];
      //  [picker dismissViewControllerAnimated:YES completion:nil];
}

//头像上传
-(void)UploadImage:(NSDictionary *)dic
{
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    manager.requestSerializer = [AFJSONRequestSerializer serializer];//请求
    manager.responseSerializer = [AFHTTPResponseSerializer serializer];//响应
    
    //网址
//    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"text/plain; charset=utf-8"];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/json", nil];
    NSString * imgpath = [NSString stringWithFormat:@"%@",dic[@"image"]];
    UIImage *image = [UIImage imageWithContentsOfFile:imgpath];
    NSData *data = UIImageJPEGRepresentation(image,0.7);
   // NSDictionary *parameters =@{@"photo":data};
    
    
    NSString *urlString =[NSString stringWithFormat:@"%@/app/head/url",ServerAddress];
    
   // urlString=[urlString stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
    [manager POST:urlString parameters:nil constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //01.21 测试
     
        
    
        NSDateFormatter *formatter = [[NSDateFormatter alloc] init];
        formatter.dateFormat = @"yyyyMMddHHmmss";
        NSString *str = [formatter stringFromDate:[NSDate date]];
        NSString *fileName = [NSString stringWithFormat:@"%@.jpg", str];
        [formData appendPartWithFileData:data name:@"photo" fileName:fileName mimeType:@"image/jpg"];
//         NSString *fullPath = [[NSHomeDirectory() stringByAppendingPathComponent:@"Documents"] stringByAppendingPathComponent:@"currentImage.png"];
         //  NSString *theImagePath = [[NSBundle mainBundle] pathForResource:@"currentImage.png" ofType:@"jpg"];
       // [formData appendPartWithFileURL:[NSURL fileURLWithPath:fullPath] name:@"file" error:nil];
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
    
        
        NSString *resultStr = [NSJSONSerialization JSONObjectWithData:responseObject options:NSJSONReadingAllowFragments error:nil];
        NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
        NSDictionary *itemInfo = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
        
        
        if ([itemInfo[@"code"] isEqualToString:@"0000"]) {
            headUrl = itemInfo[@"result"];  //图片url
            [self updateHeadImageClient];
        }
        
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        
        NSLog(@"Error: %@", error);
    }];
    

    
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
        self.myImage.image =[UIImage imageWithData:[NSData dataWithContentsOfURL:[NSURL URLWithString:headUrl]]];
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


-(void)updateFaceRequest:(UIImage*)faceImg
{
    NSString * BASE_URL = @"http://192.168.88.244:8086";
    NSData* imageData = UIImageJPEGRepresentation(faceImg, 0.8);
    NSDictionary* uploadFaceDic=@{@"memberAvatar":@[imageData]};
//    UIImage * chosenImage = info[UIImagePickerControllerEditedImage];
//    UIImageView * picImageView = (UIImageView *)[self.view viewWithTag:500];
//    picImageView.image = chosenImage;
//    chosenImage = [self imageWithImageSimple:chosenImage scaledToSize:CGSizeMake(60, 60)];
   // NSData * imageData = UIImageJPEGRepresentation(chosenImage, 0.9);
    //    [self saveImage:chosenImage withName:@"avatar.png"];
    //    NSURL * filePath = [NSURL fileURLWithPath:[self documentFolderPath]];
    //将图片上传到服务器
    //    --------------------------------------------------------
    AFHTTPRequestOperationManager * manager = [[AFHTTPRequestOperationManager alloc]initWithBaseURL:nil];
    manager.requestSerializer = [AFHTTPRequestSerializer serializer];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObjects:@"application/json",@"text/html",@"text/javascript",@"text/json", nil];
    NSString * urlString = [NSString stringWithFormat:@"%@/app/head/url",BASE_URL];
    NSUserDefaults * userDefaults = [NSUserDefaults standardUserDefaults];
    NSMutableDictionary * dict = [NSMutableDictionary dictionaryWithCapacity:1];
   // [dict setObject:[userDefaults objectForKey:@"user_id"] forKey:@"user_id"];
    [manager POST:urlString parameters:dict constructingBodyWithBlock:^(id<AFMultipartFormData> formData) {
        //通过post请求上传用户头像图片,name和fileName传的参数需要跟后台协商,看后台要传的参数名
        [formData appendPartWithFileData:imageData name:@"img" fileName:@"img.jpg" mimeType:@"image/jpeg"];
        
    } success:^(AFHTTPRequestOperation *operation, id responseObject) {
        //解析后台返回的结果,如果不做一下处理,打印结果可能是一些二进制流数据
        NSError *error;
        NSString *string = [[NSString alloc]initWithData:responseObject encoding:NSUTF8StringEncoding];
        string =[string stringByReplacingOccurrencesOfString:@"\\" withString:@""];
        string=[string substringWithRange:NSMakeRange(1, string.length-2)];
        NSDictionary *itemInfo=[Utility objFromJson:string];
        if ([itemInfo[@"code"] isEqualToString:@"0000"]) {
          //  [self showPromptText:@"修改成功" hideAfterDelay:1.8];
            NSString *iconUrl = itemInfo[@"result"];  //图片url
        }
        //上传成功后更新数据
//        self.personModel.adperurl = imageDict[@"adperurl"];
        NSLog(@"上传图片成功0---%@");
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"上传图片-- 失败  -%@",error);
    }];
  
     // [self.memberMan updateImage:uploadFaceDic];
//    NSString *theRequest;
//    theRequest  = @"http://192.168.88.244:8086";
//    [self.loadDataTool RequestWithString:[NSString stringWithFormat:@"%@/app/head/url?",theRequest] isPost:NO andPara:nil andComplete:^(id data, BOOL isSuccess) {
//        [self hideLoadingView];
//        if (isSuccess) {
//            NSString *resultStr = [NSJSONSerialization JSONObjectWithData:data options:NSJSONReadingAllowFragments error:nil];
//            NSData *jsonData = [resultStr dataUsingEncoding:NSUTF8StringEncoding];
//            NSDictionary  *resultDic = [NSJSONSerialization JSONObjectWithData:jsonData options:NSJSONReadingAllowFragments error:nil];
//            if ([resultDic[@"code"] integerValue] != 0) {
//                return ;
//            }
//            NSArray *resultArr =  resultDic[@"result"];
//
//
//        }else{
//             [self showPromptText: @"服务器连接失败" hideAfterDelay: 1.7];
//        }
//    }];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)actionTel:(id)sender {
    [self actionTelMe];
}


@end
