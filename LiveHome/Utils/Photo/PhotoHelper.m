//
//  PhotoHelper.m
//  LiveHome
//
//  Created by chh on 2017/10/31.
//  Copyright © 2017年 chh. All rights reserved.
//

#import "PhotoHelper.h"
#import <LCActionSheet/LCActionSheet.h>
#import "TZImagePickerController.h"
#import "UIImage+fixOrientation.h"

@interface PhotoHelper()<UIImagePickerControllerDelegate, UINavigationControllerDelegate>

@property (nonatomic, weak) UIViewController *controller;
@end

@implementation PhotoHelper

+ (PhotoHelper *)sharedInstance {
    static PhotoHelper * _sharedInstance = nil;
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        _sharedInstance = [[PhotoHelper alloc] init];
    });
    
    return _sharedInstance;
}

- (void)addPhotoWithController:(UIViewController *)controller
{
    self.controller = controller;
    LCActionSheet *sheet = [[LCActionSheet alloc] initWithTitle:nil cancelButtonTitle:@"取消" clicked:^(LCActionSheet * _Nonnull actionSheet, NSInteger buttonIndex) {
        switch (buttonIndex) {
            case 1://拍照
                [self responseDelegate];
                [self openCamera];
                break;
            case 2://上传照片
                [self responseDelegate];
                [self openAlbum];
                break;
            default:
                break;
        }
    } otherButtonTitles:@"拍照",@"上传照片", nil];
    [sheet show];
}

- (void)responseDelegate{
    if ([self.delegate respondsToSelector:@selector(clickAddPhotoBtn)]){
        [self.delegate clickAddPhotoBtn];
    }
}

/** 相册 */
- (void)openAlbum{
    TZImagePickerController *imagePickerVc = [[TZImagePickerController alloc] initWithMaxImagesCount:1 delegate:nil];
    ///是否 在相册中显示拍照按钮
    imagePickerVc.allowTakePicture = NO;
    ///是否可以选择显示原图
    imagePickerVc.allowPickingOriginalPhoto = NO;
    ///是否 在相册中可以选择视频
    imagePickerVc.allowPickingVideo = NO;
    
    // 你可以通过block或者代理，来得到用户选择的照片.
    __weak typeof(self) weakSelf = self;
    [imagePickerVc setDidFinishPickingPhotosHandle:^(NSArray<UIImage *> *photos, NSArray *assets, BOOL isBool) {
        __strong typeof(weakSelf)strongSelf = weakSelf;
        //图片压缩
        NSData *data = UIImageJPEGRepresentation(photos.firstObject, 0.3);
        UIImage *resultImage = [[UIImage imageWithData:data] fixOrientation];
        if (strongSelf.block){
            strongSelf.block(resultImage);
        }
    }];
    [self.controller presentViewController:imagePickerVc animated:YES completion:nil];
}

/** 相机 */
- (void)openCamera
{
    UIImagePickerControllerSourceType sourceType = UIImagePickerControllerSourceTypeCamera;
    
    if ([UIImagePickerController isSourceTypeAvailable: UIImagePickerControllerSourceTypeCamera]){
        UIImagePickerController *picker = [[UIImagePickerController alloc] init];
        picker.delegate = self;
        //设置拍照后的图片可被编辑
        picker.allowsEditing = YES;
        picker.sourceType = sourceType;
        [self.controller presentViewController:picker animated:YES completion:nil];
    }else{
        [LCProgressHUD showInfoMsg:@"该设备不支持拍照"];
    }
}

#pragma mark - UIImagePickerControllerDelegate
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary<NSString *,id> *)info
{
    [picker dismissViewControllerAnimated:YES completion:nil];
    UIImage *image = info[UIImagePickerControllerOriginalImage];
    //图片压缩
    NSData *data = UIImageJPEGRepresentation(image, 0.3);
    UIImage *resultImage = [[UIImage imageWithData:data] fixOrientation];
    if (self.block){
        self.block(resultImage);
    }
}

@end
