//
//  ViewController.m
//  ImagePickerSheet
//
//  Created by Nikita Demidov on 04.03.16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "ViewController.h"
#import "ImagePickerViewController.h"

@interface ViewController ()

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
    [self presentViewController:picker animated:YES completion:nil];
}

@end
