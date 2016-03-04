//
//  TransitionAnimationController.h
//  ImagePickerController
//
//  Created by Nikita Demidov on 02/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface TransitionAnimationController : NSObject <UIViewControllerAnimatedTransitioning>

- (instancetype)initWithPresentingVC:(UIViewController*)presentingVC presenting:(BOOL)presenting;

@end
