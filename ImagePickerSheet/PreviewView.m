//
//  PreviewView.m
//  ImagePickerController
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "PreviewView.h"
#import "PreviewCollectionViewCell.h"
#import "PreviewViewService.h"

@interface PreviewView() <UICollectionViewDelegate>

@property (weak, nonatomic) IBOutlet UICollectionView* collectionView;
@property (weak, nonatomic) IBOutlet UIView* mainView;

@property (strong, nonatomic) PreviewViewService* previewViewService;

@end

@implementation PreviewView

- (instancetype)initWithCoder:(NSCoder *)aDecoder{
    self = [super initWithCoder:aDecoder];
    if (self) {
        [[NSBundle mainBundle] loadNibNamed:NSStringFromClass([self class]) owner:self options:nil];
        [self setup];
    }
    return self;
}

#pragma mark - Setup

- (void)setup {
    [self addSubview:self.mainView];
    [self stretchToSuperView:self.mainView];
    
    [self configureCollectionView];
}

- (void)configureCollectionView{
    self.previewViewService = [PreviewViewService new];
    self.collectionView.dataSource = self.previewViewService;
    self.collectionView.delegate = self;
    [self.collectionView reloadData];
}

#pragma mark - UICollectionViewDelegate

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
    PreviewCollectionViewCell* previewCell = (PreviewCollectionViewCell*)[collectionView cellForItemAtIndexPath:indexPath];
    [previewCell setChecked:YES];
    [self.previewViewService selectedPhotoWithIndexPath:indexPath];
    
    [self.collectionView scrollToItemAtIndexPath:indexPath atScrollPosition:UICollectionViewScrollPositionCenteredHorizontally animated:YES];
}

#pragma mark - update constraints

- (void)stretchToSuperView:(UIView*) view {
    
    if (!self.mainView) return;
    
    view.translatesAutoresizingMaskIntoConstraints = NO;
    NSDictionary *bindings = NSDictionaryOfVariableBindings(view);
    NSString *formatTemplate = @"%@:|[view]|";
    for (NSString * axis in @[@"H",@"V"]) {
        NSString * format = [NSString stringWithFormat:formatTemplate,axis];
        NSArray * constraints = [NSLayoutConstraint constraintsWithVisualFormat:format options:0 metrics:nil views:bindings];
        [view.superview addConstraints:constraints];
    }
}


@end