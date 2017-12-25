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

@interface PersonnalCenterViewController ()<UINavigationControllerDelegate,UIImagePickerControllerDelegate,UIActionSheetDelegate,RSKImageCropViewControllerDelegate>{
    
     NSString *titleStr;
}
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
    if ([self isIphoneX]) {
        // self.bigView.translatesAutoresizingMaskIntoConstraints = NO;
        self.top.constant = 88;
        self.bottom.constant = 34;
    }
    
   
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
    
}

- (IBAction)updateImage:(id)sender {
    UIActionSheet *choseSheet = [[UIActionSheet alloc] initWithTitle:nil delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照",@"从相册中获取",nil];
    [choseSheet showInView:self.view];
    
//    [self changePhotoImg];
}

- (void)changePhotoImg {
    UIAlertController * sheetController = [UIAlertController alertControllerWithTitle:@"请选择照片"
                                                                              message:nil preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction * Cancel = [UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil];
    
    UIAlertAction * Done = [UIAlertAction actionWithTitle:@"拍照" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        //[self selectImageSourceType:UIImagePickerControllerSourceTypeCamera];
    }];
    
    UIAlertAction * Destructive = [UIAlertAction actionWithTitle:@"从相册选择头像" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
       // [self selectImageSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    }];
    
    [sheetController addAction:Cancel];
    [sheetController addAction:Done];
    [sheetController addAction:Destructive];
    [self presentViewController:sheetController animated:YES completion:nil];
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
     if (self.curUser.paypwdSetting == 0) {
        SetPayPWDViewController *spvc = [[SetPayPWDViewController alloc]init];
        spvc.titleStr = @"设置支付密码";
        [self.navigationController pushViewController:spvc animated:YES];
    } else {
        ChangePayPWDViewController *cpvc = [[ChangePayPWDViewController alloc]init];
        [self.navigationController pushViewController:cpvc animated:YES];
    }
}
- (IBAction)changeLoginPWD:(id)sender {
}

#pragma mark UIActionSheetDelegate
- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        // 拍照
        if ([self isCameraAvailable] && [self doesCameraSupportTakingPhotos]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypeCamera;
            if ([self isFrontCameraAvailable]) {
                controller.cameraDevice = UIImagePickerControllerCameraDeviceFront;
            }
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        else
        {
            NSLog(@"不支持拍照！");
        }
       
        
        
        //        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
        //            [self.view makeToast:@"该设备不支持相机" duration:3 position:@"center"];
        //            return ;
        //        }
        //        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        //        picker.delegate = self;
        //        picker.allowsEditing = YES;
        //        picker.sourceType = UIImagePickerControllerSourceTypeCamera;
        //
        //        [self presentViewController:picker animated:YES completion:nil];
        
    } else if (buttonIndex == 1) {
        // 从相册中选取
        if ([self isPhotoLibraryAvailable]) {
            UIImagePickerController *controller = [[UIImagePickerController alloc] init];
            controller.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
            NSMutableArray *mediaTypes = [[NSMutableArray alloc] init];
            [mediaTypes addObject:(__bridge NSString *)kUTTypeImage];
            controller.mediaTypes = mediaTypes;
            controller.delegate = self;
            [self presentViewController:controller
                               animated:YES
                             completion:^(void){
                                 NSLog(@"Picker View Controller is presented");
                             }];
        }
        
        //        UIImagePickerController* picker = [[UIImagePickerController alloc] init];
        //        picker.delegate = self;
        //        picker.allowsEditing = YES;
        //        picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        //
        //        [self presentViewController:picker animated:YES completion:nil];
    }
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
    RSKImageCropViewController *imageCropVC = [[RSKImageCropViewController alloc] initWithImage:image cropMode:RSKImageCropModeCircle];
    imageCropVC.delegate = self;
    [self.navigationController pushViewController:imageCropVC animated:YES];
    
    [picker dismissViewControllerAnimated:YES completion:nil];
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
    [self updateFaceRequest:croppedImage];
    [self.navigationController popViewControllerAnimated:YES];
}


- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker
{
    //NSLog(@"222222");
    [picker dismissViewControllerAnimated:YES completion:nil];
}


-(void)updateFaceRequest:(UIImage*)faceImg
{
    
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
