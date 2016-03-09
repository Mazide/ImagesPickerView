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
    [self.selectedIndexes addObject:indexPath];
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
    
    BOOL imageChecked = [self.selectedIndexes containsObject:indexPath];
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
    
    [[PHImageManager defaultManager] requestImageForAsset:asset targetSize:CGSizeMake(100, 100) contentMode:PHImageContentModeDefault options:nil resultHandler:^(UIImage * _Nullable result, NSDictionary * _Nullable info) {
        completionHandler ? completionHandler(result) : nil;
    }];
}


@end
