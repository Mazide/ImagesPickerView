//
//  ImagePickerViewController.h
//  ImagePickerController
//
//  Created by Nikita Demidov on 02/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <UIKit/UIKit.h>

@class ImagePickerViewController;

@protocol ImagePickerViewControllerDelegate <NSObject>

@optional
- (void)imagePickerController:(ImagePickerViewController *)picker didFinishPickingAssets:(NSArray *)assets;
- (void)imagePickerController:(ImagePickerViewController *)picker needOpenUIImagePickerVC:(UIImagePickerController*)picker;
- (void)imagePickerController:(ImagePickerViewController *)picker needOpenDocumentMenuVC:(UIDocumentMenuViewController*)documentMenuVC;
- (void)imagePickerControllerDidCancel:(ImagePickerViewController *)picker;

@end

@interface ImagePickerViewController : UIViewController

@property (weak, nonatomic) id<ImagePickerViewControllerDelegate> delegate;

@end
