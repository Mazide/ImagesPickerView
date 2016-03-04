//
//  TransitionAnimationController.m
//  ImagePickerController
//
//  Created by Nikita Demidov on 02/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "TransitionAnimationController.h"

static const CGFloat transitionDuration = 0.3;

@interface TransitionAnimationController()

@property (strong, nonatomic) UIViewController* presentingVC;
@property (nonatomic) BOOL presenting;

@end

@implementation TransitionAnimationController

-(instancetype)initWithPresentingVC:(UIViewController *)presentingVC presenting:(BOOL)presenting{
    self = [super init];
    if (self) {
        _presentingVC = presentingVC;
        _presenting = presenting;
    }
    return self;
}

- (void)animationPresentationWithContext:(id <UIViewControllerContextTransitioning>)transitionContext{

    UIViewController *toViewController = [transitionContext viewControllerForKey:UITransitionContextToViewControllerKey];
    CGRect finalFrame = [transitionContext finalFrameForViewController:toViewController];
    
    UIView *containerView = [transitionContext containerView];
    
    [containerView addSubview:toViewController.view];
    toViewController.view.alpha = 0.f;

    [UIView animateWithDuration:transitionDuration animations:^{
        
        toViewController.view.alpha = 1.f;
    } completion:^(BOOL finished) {
        
        toViewController.view.frame = finalFrame;
        [transitionContext completeTransition:YES];
    }];
}

- (void)animationDismissal:(id <UIViewControllerContextTransitioning>)transitionContext{
    [UIView animateWithDuration:[self transitionDuration:transitionContext] delay:0.f options:UIViewAnimationOptionCurveLinear animations:^{
        self.presentingVC.view.alpha = 0.f;
    } completion:^(BOOL finished) {
        [transitionContext completeTransition:finished];        
    }];
}

#pragma mark - UIViewControllerAnimatedTransitioning

- (NSTimeInterval)transitionDuration:(nullable id <UIViewControllerContextTransitioning>)transitionContext{
    return transitionDuration;
}

- (void)animateTransition:(id <UIViewControllerContextTransitioning>)transitionContext{
    self.presenting ? [self animationPresentationWithContext:transitionContext] : [self animationDismissal:transitionContext];
}

@end
