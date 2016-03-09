//
//  PreviewViewService.m
//  ImagePickerSheet
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "PreviewViewService.h"
#import "PreviewCollectionViewCell.h"
#import <Photos/Photos.h>

@interface PreviewViewService()

@property (strong, nonatomic) PHFetchResult* fetchResult;
@property (strong, nonatomic) NSMutableSet* selectedIndexes;

@end

@implementation PreviewViewService

- (instancetype)init{
    self = [super init];
    if (self) {
        [self fetchMediaAssets];
        _selectedIndexes = [NSMutableSet new];
    }
    return self;
}

-(void)selectedPhotoWithIndexPath:(NSIndexPath *)indexPath{

    if ([self photoByIndexPathSelected:indexPath]) {
        [self.selectedIndexes removeObject:indexPath];
    } else {
        [self.selectedIndexes addObject:indexPath];
    }
}

- (BOOL)photoByIndexPathSelected:(NSIndexPath *)indexPath{
    return [self.selectedIndexes containsObject:indexPath];
}

#pragma mark - assets fetch

- (void)fetchMediaAssets{
    PHFetchOptions* fetchOptions = [PHFetchOptions new];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    self.fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* cellIdentifier = NSStringFromClass([PreviewCollectionViewCell class]);
    PreviewCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PHAsset* asset = [self.fetchResult objectAtIndex:indexPath.row];
    [self imageForAsset:asset withCompletion:^(UIImage *image) {
        [cell configureWithItem:image];
    }];
    
    BOOL imageChecked = [self photoByIndexPathSelected:indexPath];
    [cell setChecked:imageChecked];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.fetchResult.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

#pragma mark - help

- (void)imageForAsset:(PHAsset*)asset withCompletion:(void (^)(UIImage* image))completionHandler{
    PHImageRequestOptions *options = [[PHImageRequestOptions alloc] init];
    options.resizeMode = PHImageRequestOptionsResizeModeExact;
    options.networkAccessAllowed = NO;
    
    NSInteger retinaMultiplier = [UIScreen mainScreen].scale;
    CGSize retinaSquare = CGSizeMake(100.f * retinaMultiplier, 100.f * retinaMultiplier);

    [[PHImageManager defaultManager] requestImageForAsset:asset
                                               targetSize:retinaSquare
                                              contentMode:PHImageContentModeAspectFill
                                                  options:options
                                            resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completionHandler ? completionHandler(result) : nil;
    }];
}


@end
