//
//  ImagePickerViewController.m
//  ImagePickerController
//
//  Created by Nikita Demidov on 02/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "ImagePickerViewController.h"
#import "TransitionAnimationController.h"
#import "Action.h"
#import "ActionsTableViewService.h"
#import "ActionSheetTableView.h"
#import "TransitionAnimationController.h"

@interface ImagePickerViewController () <UIViewControllerTransitioningDelegate>

@property (weak, nonatomic) ActionSheetTableView* actionsSheetTableView;
@property (strong, nonatomic) ActionsTableViewService* actionsTableViewService;

@end

@implementation ImagePickerViewController{
    BOOL showed;
}

- (void)viewDidLoad {
    [super viewDidLoad];

//    self.transitioningDelegate = self;
    [self configureActionSheetTableView];
    showed = NO;
}

- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self showActionSheet:!showed completion:nil];
    showed = !showed;
}

- (void)configureActionSheetTableView{
    
    ActionSheetTableView* actionsSheetTableView = [[ActionSheetTableView alloc] initWithFrame:self.view.frame];
    self.actionsSheetTableView = actionsSheetTableView;
    [self.view addSubview:self.actionsSheetTableView];
    
    NSArray* actions = [self actions];
    NSArray* cancelAction = [self cancelActions];
    self.actionsTableViewService = [[ActionsTableViewService alloc] initWithActions:actions cancelActions:cancelAction needPreview:YES];
    self.actionsSheetTableView.dataSource = self.actionsTableViewService;
    self.actionsSheetTableView.actionSheetDelegate = self.actionsTableViewService;
    
    [self.actionsSheetTableView reloadData];
    
    [self resizeTableViewToContent:self.actionsSheetTableView];
}

- (void)resizeTableViewToContent:(UITableView*)tableView{
    CGRect frame = tableView.frame;
    frame.size.height = tableView.contentSize.height;
    frame.origin.y = self.view.frame.size.height;
    tableView.frame = frame;
}

- (NSArray*)actions{

    Action* allAlbumsAction = [Action new];
    allAlbumsAction.title = @"All albums";
    allAlbumsAction.handler = ^(Action* action){
        [self presentImagePickerViewControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
    };
    
    Action* takeAPictureAction = [Action new];
    takeAPictureAction.title = @"Take a picture";
    takeAPictureAction.handler = ^(Action* action){
        [self presentImagePickerViewControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
    };

    Action* otherAppsAction = [Action new];
    otherAppsAction.title = @"Other apps";
    otherAppsAction.handler = ^(Action* action){
        [self openImportDocumentPicker];
    };
    return @[allAlbumsAction, takeAPictureAction, otherAppsAction];
}

- (NSArray*)cancelActions{
    Action* cancelAction = [Action new];
    cancelAction.title = @"Cancel";
    cancelAction.handler = ^(Action* action){
        [self showActionSheet:NO completion:nil];
//        [self dismissViewControllerAnimated:YES completion:nil];
    };

    return @[cancelAction];
}

#pragma mark - animation 

- (void)showActionSheet:(BOOL)show completion:(void (^)())completionBlock{

    NSTimeInterval animationDuration = show ? 0.3f : 0.2f;
    
    CGFloat showedY = self.view.frame.size.height - self.actionsSheetTableView.frame.size.height;
    CGFloat hiddenY = self.view.frame.size.height;
    CGFloat destionationY = show ? showedY : hiddenY;
    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect frame = self.actionsSheetTableView.frame;
        frame.origin.y = destionationY;
        self.actionsSheetTableView.frame = frame;
    } completion:^(BOOL finished) {
        completionBlock ? completionBlock() : nil;
    }];
}


#pragma mark - UIViewControllerTransitioningDelegate

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source{
    TransitionAnimationController* transitionAnimationController = [[TransitionAnimationController alloc] initWithPresentingVC:presenting presenting:YES];
    return transitionAnimationController;
}

- (nullable id <UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed{
    TransitionAnimationController* transitionAnimationController = [[TransitionAnimationController alloc] initWithPresentingVC:dismissed presenting:NO];
    return transitionAnimationController;
}

#pragma mark - presenting

- (void)presentImagePickerViewControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController* pickerViewController = [UIImagePickerController new];
    pickerViewController.sourceType = UIImagePickerControllerSourceTypeCamera;
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

- (void)openImportDocumentPicker{

}

@end
