//
//  TransitionDelegate.m
//  ImagePickerSheet
//
//  Created by Nikita Demidov on 09.03.16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "TransitionDelegate.h"
#import "TransitionAnimationController.h"

@implementation TransitionDelegate

#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    TransitionAnimationController* transitionAnimationController = [[TransitionAnimationController alloc] initWithPresentingVC:presenting presenting:YES];
    return transitionAnimationController;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    TransitionAnimationController* transitionAnimationController = [[TransitionAnimationController alloc] initWithPresentingVC:dismissed presenting:NO];
    return transitionAnimationController;
}

@end
