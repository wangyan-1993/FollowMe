//
//  UserInfoViewController.m
//  FollowMe
//
//  Created by SCJY on 16/3/22.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "UserInfoViewController.h"
#import "VPImageCropperViewController.h"
#import <AssetsLibrary/AssetsLibrary.h>
#import <MobileCoreServices/MobileCoreServices.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "UsernameViewController.h"
#import "UserPhoneViewController.h"
#import "UserEmailViewController.h"
#import "UserSignatureViewController.h"
#import "UserTableViewCell.h"
#import <BmobSDK/BmobUser.h>
#import <BmobSDK/BmobQuery.h>
#import <BmobSDK/BmobObject.h>
#define ORIGINAL_MAX_WIDTH 640.0f


@interface UserInfoViewController ()<UITableViewDataSource, UITableViewDelegate, UIImagePickerControllerDelegate, UIActionSheetDelegate, VPImageCropperDelegate, UINavigationControllerDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSArray *allArray;
@property (nonatomic, strong) UIImageView *portraitImageView;
@property(nonatomic, strong) NSMutableArray *array;
@property(nonatomic, copy) NSString *birthday;
@end

@implementation UserInfoViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"个人信息";
    [self showBackBtn];
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.allArray = @[@"头像",@"用户名",@"手机号码",@"邮箱",@"地区",@"性别",@"生日",@"个性签名"];
    WLZLog(@"%@", self.username);

    [self.view addSubview:self.tableView];
    [self loadPortrait];
    [[NSNotificationCenter defaultCenter]addObserver:self selector:@selector(change:) name:@"change" object:nil];
    [self changeArray];
    self.navigationController.navigationBar.hidden = NO;

}
- (void)changeArray{
    BmobQuery *query = [BmobQuery queryWithClassName:@"info"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        for (BmobObject *obj in array) {
            if ([[BmobUser getCurrentUser].username isEqualToString:[obj objectForKey:@"user"]])
            {
                if ([obj objectForKey:@"name"]) {
                    [self.array replaceObjectAtIndex:1 withObject:[obj objectForKey:@"name"]];
                }

                
                if ([obj objectForKey:@"city"]) {
                    [self.array replaceObjectAtIndex:4 withObject:[obj objectForKey:@"city"]];
                }
                if ([obj objectForKey:@"gender"]) {
                    [self.array replaceObjectAtIndex:5 withObject:[obj objectForKey:@"gender"]];
                }
                if ([obj objectForKey:@"year"]) {
                    [self.array replaceObjectAtIndex:6 withObject:[obj objectForKey:@"year"]];
                }
                 [self.tableView reloadData];
            }
        }
    }];
    
    if ([BmobUser getCurrentUser].mobilePhoneNumber) {
        WLZLog(@"%@", [BmobUser getCurrentUser].mobilePhoneNumber);
        [self.array replaceObjectAtIndex:2 withObject:[BmobUser getCurrentUser].mobilePhoneNumber];
    }
    
    if ([BmobUser getCurrentUser].email) {
        [self.array replaceObjectAtIndex:3 withObject:[BmobUser getCurrentUser].email];
    }
    [self.tableView reloadData];

}
- (void)change:(NSNotification *)notification{
    if ([notification userInfo][@"name"] != nil) {
        [self.array replaceObjectAtIndex:1 withObject:[notification userInfo][@"name"]];

    }
    if ([notification userInfo][@"personal"] != nil) {
        [self.array replaceObjectAtIndex:7 withObject:[notification userInfo][@"personal"]];
    }
    [self.tableView reloadData];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter]removeObserver:self];
}

- (void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"info"];
[query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
    for (BmobObject *obj in array) {
        if ([[BmobUser getCurrentUser].username isEqualToString:[obj objectForKey:@"user"]])
        {
            [obj setObject:self.array[1] forKey:@"name"];
            [obj setObject:self.array[4] forKey:@"city"];
            [obj setObject:self.array[6] forKey:@"year"];
            [obj setObject:self.array[7] forKey:@"signature"];
            [obj setObject:self.array[5] forKey:@"gender"];
            [obj updateInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                WLZLog(@"%@", error);
            }];
        }
    }
}];
    
}
- (void)loadPortrait {
    __weak __typeof(self) weakSelf = self;
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^ {
        NSURL *portraitUrl = [NSURL URLWithString:self.urlImage];
      //  __block UIImage *protraitImg = [UIImage imageWithData:[NSData dataWithContentsOfURL:portraitUrl]];
        dispatch_sync(dispatch_get_main_queue(), ^{
            __strong __typeof(weakSelf) strongSelf = weakSelf;
            [strongSelf.portraitImageView sd_setImageWithURL:portraitUrl placeholderImage:[UIImage imageNamed:@"123456"]];
        });
    });
}
#pragma mark------UITableViewDataSource

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"cell";
    UserTableViewCell *cell = [self.tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UserTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
    }
    if (indexPath.row == 0) {
        [cell addSubview:self.portraitImageView];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.label1.text = self.allArray[indexPath.row];
    cell.label.text = self.array[indexPath.row];
       return cell;
}

#pragma mark------UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    UIStoryboard *main = [UIStoryboard storyboardWithName:@"Mine" bundle:nil];
    if (indexPath.row == 0) {
        [self pickImage];
    }
    if (indexPath.row == 1) {
        UsernameViewController *username = [main instantiateViewControllerWithIdentifier:@"username"];
        [self.navigationController pushViewController:username animated:YES];
    }
    if (indexPath.row == 2) {
        UserPhoneViewController *userphone = [main instantiateViewControllerWithIdentifier:@"userphone"];
        [self.navigationController pushViewController:userphone animated:YES];
    }
    if (indexPath.row == 3) {
        UserEmailViewController *useremail = [main instantiateViewControllerWithIdentifier:@"useremail"];
        [self.navigationController pushViewController:useremail animated:YES];
    }
    if (indexPath.row == 4) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"所在地区" message:@"建议格式:北京" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入所在地";
            
        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            WLZLog(@"%@", alert.textFields[0].text);
            [self.array replaceObjectAtIndex:4 withObject:alert.textFields[0].text];
            
            [self.tableView reloadData];
            
        }];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];

    }
    if (indexPath.row == 5) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:nil message:nil preferredStyle:UIAlertControllerStyleActionSheet];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"男" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.array replaceObjectAtIndex:5 withObject:@"男"];
            [self.tableView reloadData];

        }];
        [alert addAction:action2];
        UIAlertAction *action3 = [UIAlertAction actionWithTitle:@"女" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            [self.array replaceObjectAtIndex:5 withObject:@"女"];
            [self.tableView reloadData];

        }];
        [alert addAction:action3];
        [self presentViewController:alert animated:YES completion:nil];


    }
    
    if (indexPath.row == 6) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"个人生日" message:@"建议格式:xxxx.xx.xx" preferredStyle:UIAlertControllerStyleAlert];
        UIAlertAction *action1 = [UIAlertAction actionWithTitle:@"取消" style:UIAlertActionStyleCancel handler:nil];
        [alert addAction:action1];
        [alert addTextFieldWithConfigurationHandler:^(UITextField * _Nonnull textField) {
            textField.placeholder = @"请输入年龄";
            //self.birthday = textField.text;
            WLZLog(@"%@", self.birthday);

        }];
        UIAlertAction *action2 = [UIAlertAction actionWithTitle:@"确定" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
            
            WLZLog(@"%@", alert.textFields[0].text);
            [self.array replaceObjectAtIndex:6 withObject:alert.textFields[0].text];
            
            [self.tableView reloadData];
            
        }];
        [alert addAction:action2];
        [self presentViewController:alert animated:YES completion:nil];

    }
    
    if (indexPath.row == 7) {
        UserSignatureViewController *signature = [[UserSignatureViewController alloc]init];
        [self.navigationController pushViewController:signature animated:YES];
    }
    
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        return 100;
    }
    return 50;
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 15, kWidth, kHeight)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
    }
    return _tableView;
}
- (NSArray *)allArray{
    if (_allArray == nil) {
        self.allArray = [NSArray new];
    }
    return _allArray;
}

- (NSMutableArray *)array{
    if (_array == nil) {
        
        BmobQuery *query = [BmobQuery queryWithClassName:@"info"];
        [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
            for (BmobObject *obj in array) {
                if ([[BmobUser getCurrentUser].username isEqualToString:[obj objectForKey:@"user"]]) {
                    WLZLog(@"%@", [obj objectForKey:@"name"]);
                    self.username = [obj objectForKey:@"name"];
                }
            }
        }];
        WLZLog(@"%@", self.username);
       self.array = [NSMutableArray arrayWithArray:@[@"",@"未设置",@"未设置",@"未设置",@"未设置",@"未设置",@"未设置",@"未设置"]];
    }
    return _array;
}


#pragma mark---------------选取照片的方法
- (void)pickImage{
    [self editPortrait];

}

- (void)editPortrait {
    UIActionSheet *choiceSheet = [[UIActionSheet alloc] initWithTitle:nil
                                                             delegate:self
                                                    cancelButtonTitle:@"取消"
                                               destructiveButtonTitle:nil
                                                    otherButtonTitles:@"拍照", @"从相册中选取", nil];
    [choiceSheet showInView:self.view];
}

#pragma mark VPImageCropperDelegate
- (void)imageCropper:(VPImageCropperViewController *)cropperViewController didFinished:(UIImage *)editedImage {
    self.portraitImageView.image = editedImage;
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
        // TO DO
    }];
}

- (void)imageCropperDidCancel:(VPImageCropperViewController *)cropperViewController {
    [cropperViewController dismissViewControllerAnimated:YES completion:^{
    }];
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
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    [picker dismissViewControllerAnimated:YES completion:^() {
        UIImage *portraitImg = [info objectForKey:@"UIImagePickerControllerOriginalImage"];
        WLZLog(@"%@", portraitImg);
   

        portraitImg = [self imageByScalingToMaxSize:portraitImg];
        // present the cropper view controller
        VPImageCropperViewController *imgCropperVC = [[VPImageCropperViewController alloc] initWithImage:portraitImg cropFrame:CGRectMake(0, 100.0f, self.view.frame.size.width, self.view.frame.size.width) limitScaleRatio:3.0];
        imgCropperVC.delegate = self;
        [self presentViewController:imgCropperVC animated:YES completion:^{
            // TO DO
        }];
    }];
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    [picker dismissViewControllerAnimated:YES completion:^(){
    }];
}

#pragma mark image scale utility
- (UIImage *)imageByScalingToMaxSize:(UIImage *)sourceImage {
    if (sourceImage.size.width < ORIGINAL_MAX_WIDTH) return sourceImage;
    CGFloat btWidth = 0.0f;
    CGFloat btHeight = 0.0f;
    if (sourceImage.size.width > sourceImage.size.height) {
        btHeight = ORIGINAL_MAX_WIDTH;
        btWidth = sourceImage.size.width * (ORIGINAL_MAX_WIDTH / sourceImage.size.height);
    } else {
        btWidth = ORIGINAL_MAX_WIDTH;
        btHeight = sourceImage.size.height * (ORIGINAL_MAX_WIDTH / sourceImage.size.width);
    }
    CGSize targetSize = CGSizeMake(btWidth, btHeight);
    return [self imageByScalingAndCroppingForSourceImage:sourceImage targetSize:targetSize];
}

- (UIImage *)imageByScalingAndCroppingForSourceImage:(UIImage *)sourceImage targetSize:(CGSize)targetSize {
    UIImage *newImage = nil;
    CGSize imageSize = sourceImage.size;
    CGFloat width = imageSize.width;
    CGFloat height = imageSize.height;
    CGFloat targetWidth = targetSize.width;
    CGFloat targetHeight = targetSize.height;
    CGFloat scaleFactor = 0.0;
    CGFloat scaledWidth = targetWidth;
    CGFloat scaledHeight = targetHeight;
    CGPoint thumbnailPoint = CGPointMake(0.0,0.0);
    if (CGSizeEqualToSize(imageSize, targetSize) == NO)
    {
        CGFloat widthFactor = targetWidth / width;
        CGFloat heightFactor = targetHeight / height;
        
        if (widthFactor > heightFactor)
            scaleFactor = widthFactor; // scale to fit height
        else
            scaleFactor = heightFactor; // scale to fit width
        scaledWidth  = width * scaleFactor;
        scaledHeight = height * scaleFactor;
        
        // center the image
        if (widthFactor > heightFactor)
        {
            thumbnailPoint.y = (targetHeight - scaledHeight) * 0.5;
        }
        else
            if (widthFactor < heightFactor)
            {
                thumbnailPoint.x = (targetWidth - scaledWidth) * 0.5;
            }
    }
    UIGraphicsBeginImageContext(targetSize); // this will crop
    CGRect thumbnailRect = CGRectZero;
    thumbnailRect.origin = thumbnailPoint;
    thumbnailRect.size.width  = scaledWidth;
    thumbnailRect.size.height = scaledHeight;
    
    [sourceImage drawInRect:thumbnailRect];
    
    newImage = UIGraphicsGetImageFromCurrentImageContext();
    if(newImage == nil) NSLog(@"could not scale image");
    
    //pop the context to get back to the default
    UIGraphicsEndImageContext();
    return newImage;
}

#pragma mark - UINavigationControllerDelegate
- (void)navigationController:(UINavigationController *)navigationController willShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
}

- (void)navigationController:(UINavigationController *)navigationController didShowViewController:(UIViewController *)viewController animated:(BOOL)animated {
    
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

#pragma mark portraitImageView getter
- (UIImageView *)portraitImageView {
    if (!_portraitImageView) {
        _portraitImageView = [[UIImageView alloc] initWithFrame:CGRectMake(100, 10, 80, 80)];
        [_portraitImageView.layer setCornerRadius:(_portraitImageView.frame.size.height/2)];
        _portraitImageView.clipsToBounds = YES;
//        [_portraitImageView.layer setMasksToBounds:YES];
//        [_portraitImageView setContentMode:UIViewContentModeScaleAspectFill];
//        [_portraitImageView setClipsToBounds:YES];
//       // _portraitImageView.layer.shadowColor = [UIColor blackColor].CGColor;
//        _portraitImageView.layer.shadowOffset = CGSizeMake(4, 4);
//        _portraitImageView.layer.shadowOpacity = 0.5;
//        _portraitImageView.layer.shadowRadius = 2.0;
//      //  _portraitImageView.layer.borderColor = [[UIColor blackColor] CGColor];
//        _portraitImageView.layer.borderWidth = 2.0f;
//        _portraitImageView.userInteractionEnabled = YES;
//       // _portraitImageView.backgroundColor = [UIColor blackColor];
        UITapGestureRecognizer *portraitTap = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(editPortrait)];
        [_portraitImageView addGestureRecognizer:portraitTap];
    }
    return _portraitImageView;
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
