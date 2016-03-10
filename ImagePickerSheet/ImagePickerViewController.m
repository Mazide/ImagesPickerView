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
#import "TransitionDelegate.h"
#import <Photos/Photos.h>

@interface ImagePickerViewController () <PreviewViewDelegate, UIDocumentMenuDelegate, UIDocumentPickerDelegate>

@property (weak, nonatomic)  ActionSheetTableView* actionsSheetTableView;
@property (strong, nonatomic) ActionsTableViewService* actionsTableViewService;

@property (strong, nonatomic) TransitionDelegate* transitionDelegate;
@property (weak, nonatomic) UIGestureRecognizer* dissmisGesture;

@property (strong, nonatomic) NSArray* actions;
@property (strong, nonatomic) NSArray* cancelActions;
@property (strong, nonatomic) Action* currentFirstAction;

@end

@implementation ImagePickerViewController

- (instancetype)init{
    self = [super init];
    if (self) {
        self.modalPresentationStyle = UIModalPresentationCustom;
        self.transitionDelegate = [TransitionDelegate new];
        self.transitioningDelegate = self.transitionDelegate;
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
}

- (void)viewDidAppear:(BOOL)animated{
    [super viewDidAppear:animated];
    [self requestAuthorizationIfNeededWithCompletion:^(PHAuthorizationStatus status) {
        if (status != PHAuthorizationStatusDenied) {
            [self configureActionSheetTableView];
            [self showActionSheet:YES completion:nil];
        } else {
            [self showPermissionsAlertWithCompletionHandler:^{
                [self dismissViewControllerAnimated:YES completion:nil];
            }];
        }
    }];
}

- (void)showPermissionsAlertWithCompletionHandler:(void (^)())completionHandler{
    UIAlertController* alertVC = [UIAlertController alertControllerWithTitle:@"Error!" message:@"Need permissions" preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction* okAction = [UIAlertAction actionWithTitle:@"Ok" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        completionHandler ? completionHandler() : nil;
    }];
    [alertVC addAction:okAction];
    [self presentViewController:alertVC animated:YES completion:nil];
}

- (void)requestAuthorizationIfNeededWithCompletion:(void (^)(PHAuthorizationStatus))completionHandler{
    
    PHAuthorizationStatus status = [PHPhotoLibrary authorizationStatus];
    if (status == PHAuthorizationStatusNotDetermined) {
        [PHPhotoLibrary requestAuthorization:^(PHAuthorizationStatus status) {
            dispatch_async(dispatch_get_main_queue(), ^{
                completionHandler ? completionHandler(status) : nil;
            });
        }];
    } else {
        completionHandler ? completionHandler(status) : nil;
    }
}

-(void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id<UIViewControllerTransitionCoordinator>)coordinator{
    CGFloat indent = 10.f;

    CGRect frame = self.actionsSheetTableView.frame;
    frame.size.height = self.actionsSheetTableView.contentSize.height;
    frame.size.width = size.width - 2 * indent;
    frame.origin.y = size.height - frame.size.height - indent;
    self.actionsSheetTableView.frame = frame;
    [self.actionsSheetTableView reloadData];
    
    if (self.actionsSheetTableView.frame.size.height > size.height) {
        self.actionsSheetTableView.scrollEnabled = YES;
        [self enableDissmisGesture:NO];
        
        CGRect frame = self.actionsSheetTableView.frame;
        frame.size.height = size.height;
        frame.origin.y = 0;
        self.actionsSheetTableView.frame = frame;
        [self.actionsSheetTableView reloadData];
    } else {
        self.actionsSheetTableView.scrollEnabled = NO;
        [self enableDissmisGesture:YES];
    }
    [self.actionsSheetTableView reloadData];
}

- (void)enableDissmisGesture:(BOOL)enable{
    if (enable) {
        [self.view addGestureRecognizer:self.dissmisGesture];
    } else {
        [self.view removeGestureRecognizer:self.dissmisGesture];
    }
}

- (void)configureActionSheetTableView{
    CGFloat indent = 10.f;
    ActionSheetTableView* actionsSheetTableView = [[ActionSheetTableView alloc] initWithFrame:CGRectMake(indent, 0, self.view.frame.size.width - 2 * indent, self.view.frame.size.height)];
    self.actionsSheetTableView = actionsSheetTableView;
    [self.view addSubview:self.actionsSheetTableView];
    
    NSArray* actions = [self actions];
    NSArray* cancelAction = [self cancelActions];
    
    PreviewView* previewView = [[PreviewView alloc] initWithFrame:CGRectZero];
    previewView.delegate = self;
    
    self.currentFirstAction = actions.firstObject;
    self.actionsTableViewService = [[ActionsTableViewService alloc] initWithActions:actions cancelActions:cancelAction previewView:previewView];
    
    self.actionsSheetTableView.dataSource = self.actionsTableViewService;
    self.actionsSheetTableView.actionSheetDelegate = self.actionsTableViewService;
    
    [self.actionsSheetTableView reloadData];
    [self enableDissmisGesture:YES];
    [self resizeTableViewToContent:self.actionsSheetTableView];
}

- (void)resizeTableViewToContent:(UITableView*)tableView{
    CGRect frame = tableView.frame;
    frame.size.height = tableView.contentSize.height;
    frame.origin.y = self.view.frame.size.height;
    tableView.frame = frame;
}

- (void)close{
    [self showActionSheet:NO completion:^{
        [self dismissViewControllerAnimated:YES completion:nil];
    }];
}

#pragma mark - lazy init

- (NSArray*)actions{

    if (_actions) {
        return _actions;
    }
    
    Action* allAlbumsAction = [Action new];
    allAlbumsAction.title = @"All albums";
    allAlbumsAction.handler = ^(Action* action){
        [self showActionSheet:NO completion:^{
            [self presentImagePickerViewControllerWithSourceType:UIImagePickerControllerSourceTypePhotoLibrary];
        }];
    };
    
    Action* takeAPictureAction = [Action new];
    takeAPictureAction.title = @"Take a picture";
    takeAPictureAction.handler = ^(Action* action){
        [self showActionSheet:NO completion:^{
            [self presentImagePickerViewControllerWithSourceType:UIImagePickerControllerSourceTypeCamera];
        }];
    };

    Action* otherAppsAction = [Action new];
    otherAppsAction.title = @"Other apps";
    otherAppsAction.handler = ^(Action* action){
        [self showActionSheet:NO completion:^{
            [self presentDocumentMenu];
        }];
    };
    _actions = @[allAlbumsAction, takeAPictureAction, otherAppsAction];
    return _actions;
}

- (NSArray*)cancelActions{
    
    if (_cancelActions) {
        return _cancelActions;
    }
    
    Action* cancelAction = [Action new];
    cancelAction.title = @"Cancel";
    cancelAction.handler = ^(Action* action){
        [self showActionSheet:NO completion:^{
            [self dismissViewControllerAnimated:YES completion:^{
                if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerControllerDidCancel:)]) {
                    [self.delegate imagePickerControllerDidCancel:self];
                }
            }];
        }];
    };

    _cancelActions = @[cancelAction];
    return _cancelActions;
}

- (UIGestureRecognizer *)dissmisGesture{
    if (_dissmisGesture) {
        return _dissmisGesture;
    }
    
    UISwipeGestureRecognizer* dissmisGesture = [[UISwipeGestureRecognizer alloc] initWithTarget:self action:@selector(close)];
    dissmisGesture.direction = UISwipeGestureRecognizerDirectionDown;
    _dissmisGesture = dissmisGesture;
    return _dissmisGesture;
}

#pragma mark - PreviewViewDelegate

- (void)didSelectAssets:(NSArray *)assets{
        
    NSString* attachActionTitle = [NSString stringWithFormat:@"Attach %lu files", (unsigned long)assets.count];
    Action* attachFilesAction = [[Action alloc] initWithTitle:attachActionTitle handler:^(Action *action) {
        if (self.delegate && [self.delegate respondsToSelector:@selector(imagePickerController:didFinishPickingAssets:)]) {
            [self.delegate imagePickerController:self didFinishPickingAssets:assets];
        }
        [self showActionSheet:NO completion:^{
            [self dismissViewControllerAnimated:YES completion:nil];
        }];
    }];
    
    [self.actionsTableViewService replaceAction:self.currentFirstAction byAction:attachFilesAction];
    self.currentFirstAction = attachFilesAction;
    
    NSIndexPath* indexPath = [NSIndexPath indexPathForRow:1 inSection:0];
    [self.actionsSheetTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation: UITableViewRowAnimationNone];
}

#pragma mark - animation 

- (void)showActionSheet:(BOOL)show completion:(void (^)())completionBlock{
    
    [self.actionsSheetTableView reloadData];
    
    NSTimeInterval animationDuration = show ? 0.2f : 0.15f;
    
    CGFloat showedY = self.view.frame.size.height - self.actionsSheetTableView.frame.size.height;
    CGFloat hiddenY = self.view.frame.size.height;
    CGFloat destionationY = show ? showedY : hiddenY;
    
    CGSize size = self.view.frame.size;
    if (self.actionsSheetTableView.frame.size.height >= size.height) {
        self.actionsSheetTableView.scrollEnabled = YES;
        [self enableDissmisGesture:NO];
    } else {
        self.actionsSheetTableView.scrollEnabled = NO;
        [self enableDissmisGesture:YES];
    }

    
    [UIView animateWithDuration:animationDuration animations:^{
        CGRect frame = self.actionsSheetTableView.frame;
        frame.origin.y = destionationY;
        self.actionsSheetTableView.frame = frame;
    } completion:^(BOOL finished) {
        if (finished) {
            completionBlock ? completionBlock() : nil;
        }
    }];
}

#pragma mark - presenting

- (void)presentImagePickerViewControllerWithSourceType:(UIImagePickerControllerSourceType)sourceType{
    UIImagePickerController* pickerViewController = [UIImagePickerController new];
    pickerViewController.sourceType = sourceType;
    [self presentViewController:pickerViewController animated:YES completion:nil];
}

- (void)presentDocumentMenu{
    UIDocumentMenuViewController* documentMenuViewController = [[UIDocumentMenuViewController alloc] initWithDocumentTypes:@[@"public.image"] inMode:UIDocumentPickerModeImport];
    documentMenuViewController.delegate = self;
    [self presentViewController:documentMenuViewController animated:YES completion:nil];
}

#pragma mark - UIDocumentMenuDelegate

- (void)documentMenu:(UIDocumentMenuViewController *)documentMenu didPickDocumentPicker:(UIDocumentPickerViewController *)documentPicker{
    documentPicker.delegate = self;
    [self showActionSheet:NO completion:^{
        [self presentViewController:documentPicker animated:YES completion:nil];
    }];
}

- (void)documentMenuWasCancelled:(UIDocumentMenuViewController *)documentMenu{
    [self showActionSheet:YES completion:nil];
}

#pragma mark - UIDocumentPickerDelegate

- (void)documentPicker:(UIDocumentPickerViewController *)controller didPickDocumentAtURL:(NSURL *)url{
    
}

- (void)documentPickerWasCancelled:(UIDocumentPickerViewController *)controller{
    [self showActionSheet:YES completion:nil];
}

@end
