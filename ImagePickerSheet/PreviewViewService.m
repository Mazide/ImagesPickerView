//
//  PreviewViewService.m
//  ImagePickerSheet
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "PreviewViewService.h"
#import "PreviewCollectionViewCell.h"
#import "AssetsHelper.h"

@interface PreviewViewService()

@property (strong, nonatomic) NSArray* assets;
@property (strong, nonatomic) NSMutableSet* selectedIndexes;
@property (strong, nonatomic) NSMutableSet* selectedAssets;

@property (strong, nonatomic) AssetsHelper* assetsHelper;

@end

@implementation PreviewViewService

- (instancetype)init{
    self = [super init];
    if (self) {
        _assetsHelper = [AssetsHelper new];
        _selectedIndexes = [NSMutableSet new];
        _selectedAssets = [NSMutableSet new];
    }
    return self;
}

-(void)selectedPhotoWithIndexPath:(NSIndexPath *)indexPath{

    PHAsset* asset = [self.assetsHelper.fetchResult objectAtIndex:indexPath.row];
    if ([self photoByIndexPathSelected:indexPath]) {
        [self.selectedIndexes removeObject:indexPath];
        [self.selectedAssets removeObject:asset];
    } else {
        [self.selectedIndexes addObject:indexPath];
        [self.selectedAssets addObject:asset];
    }
}

- (BOOL)photoByIndexPathSelected:(NSIndexPath *)indexPath{
    return [self.selectedIndexes containsObject:indexPath];
}

- (NSArray *)assets{
    return [_selectedAssets allObjects];
}

#pragma mark - UICollectionViewDataSource

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* cellIdentifier = NSStringFromClass([PreviewCollectionViewCell class]);
    PreviewCollectionViewCell* cell = [collectionView dequeueReusableCellWithReuseIdentifier:cellIdentifier forIndexPath:indexPath];
    
    PHAsset* asset = [self.assetsHelper.fetchResult objectAtIndex:indexPath.row];
    [self.assetsHelper imageForAsset:asset withCompletion:^(UIImage *image) {
        [cell configureWithItem:image];
    }];
    
    BOOL imageChecked = [self photoByIndexPathSelected:indexPath];
    [cell setChecked:imageChecked];
    
    return cell;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return self.assetsHelper.fetchResult.count;
}

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}


@end
