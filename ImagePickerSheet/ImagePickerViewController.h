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

- (void)imagePickerController:(ImagePickerViewController *)picker didFinishPickingImages:(NSArray *)images;
- (void)imagePickerControllerDidCancel:(ImagePickerViewController *)picker;

@end

@interface ImagePickerViewController : UIViewController

@property (weak, nonatomic) id<ImagePickerViewControllerDelegate> delegate;

@end
