//
//  ViewController.m
//  ImagePickerSheet
//
//  Created by Nikita Demidov on 04.03.16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "ViewController.h"
#import "ImagePickerViewController.h"

@interface ViewController () <ImagePickerViewControllerDelegate, UIDocumentMenuDelegate>

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (IBAction)showPicker:(id)sender{
    ImagePickerViewController* picker = [[ImagePickerViewController alloc] init];
    picker.delegate = self;
    [self presentViewController:picker animated:YES completion:nil];
}

#pragma mark - ImagePickerViewControllerDelegate

- (void)imagePickerController:(ImagePickerViewController *)picker didFinishPickingAssets:(NSArray *)assets{
    
}

- (void)imagePickerController:(ImagePickerViewController *)picker needOpenUIImagePickerVC:(UIImagePickerController*)imagePicker{
    [self presentViewController:imagePicker animated:YES completion:nil];
}

- (void)imagePickerController:(ImagePickerViewController *)picker needOpenDocumentMenuVC:(UIDocumentMenuViewController *)documentMenuVC{
    documentMenuVC.delegate = self;
    [self presentViewController:documentMenuVC animated:YES completion:nil];
}

#pragma mark - UIDocumentMenuDelegate

- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker{
    [self presentViewController:documentPicker animated:YES completion:nil];
}

@end
