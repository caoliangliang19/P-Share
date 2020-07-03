//
//  PhotoTool.m
//  P-SHARE
//
//  Created by fay on 16/9/23.
//  Copyright © 2016年 fay. All rights reserved.
//

#import "PhotoTool.h"
@interface PhotoTool()<UIImagePickerControllerDelegate,UINavigationControllerDelegate>
{
    UIImagePickerController *_picker;
    BOOL                    _isCamera;
    UIViewController        *_fromVC;
}

@end
@implementation PhotoTool

+ (instancetype)createToolWithType:(BOOL)isCamera WithViewController:(UIViewController *)vc
{
    return [[self alloc] initWithType:isCamera WithViewController:vc];
}
- (id)initWithType:(BOOL)isCamera WithViewController:(UIViewController *)vc
{
    if (self == [super init]) {
        _fromVC = vc;
        _isCamera = isCamera;
    }
    return self;
}
- (void)setImagePickView
{
    _picker = [[UIImagePickerController alloc] init];
    if (_isCamera) {
        if (![UIImagePickerController isSourceTypeAvailable:UIImagePickerControllerSourceTypeCamera]) {
            
        }else {
            _picker.sourceType = UIImagePickerControllerSourceTypeCamera;
            
        }
    }else
    {
        _picker.sourceType = UIImagePickerControllerSourceTypePhotoLibrary;
        
    }
    
    [_fromVC presentViewController:_picker animated:YES completion:^{
        _picker.delegate = self;

    }];
}

-(UIImage*)imageWithImage:(UIImage*)image scaledToSize:(CGSize)newSize
{
    // Create a graphics image context
    UIGraphicsBeginImageContext(newSize);
    
    [image drawInRect:CGRectMake(0,0,newSize.width,newSize.height)];
    
    // Get the new image from the context
    UIImage* newImage = UIGraphicsGetImageFromCurrentImageContext();
    
    // End the context
    UIGraphicsEndImageContext();
    
    // Return the new image.
    return newImage;
}
- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    
    if ([info objectForKey:UIImagePickerControllerOriginalImage]) {
        UIImage *image = nil;
        image = [info objectForKey:UIImagePickerControllerOriginalImage];
        //图片剪切
        CGSize imagesize = image.size;
        imagesize.height =400;
        imagesize.width =400;
        //对图片大小进行压缩--
        image = [self imageWithImage:image scaledToSize:imagesize];
        
        NSData *imageData = UIImageJPEGRepresentation(image, 0.2);
        [self updataUserInfoWithPost:imageData];
        
        [picker dismissViewControllerAnimated:YES completion:nil];
        
    }
}
- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker{
    
    [picker dismissViewControllerAnimated:YES completion:nil];
}
#pragma mark -- 获取图片数据
- (void)updataUserInfoWithPost:(NSData *)imageData
{
    
    MyLog(@"%@",imageData);
    
}


@end
