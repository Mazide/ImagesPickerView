//
//  AssetsHelper.m
//  ImagePickerSheet
//
//  Created by Nikita Demidov on 09.03.16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "AssetsHelper.h"

@implementation AssetsHelper

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

#pragma mark - assets fetch

- (PHFetchResult*)fetchResult{
    
    if (_fetchResult) 
        return _fetchResult;
    
    PHFetchOptions* fetchOptions = [PHFetchOptions new];
    fetchOptions.sortDescriptors = @[[NSSortDescriptor sortDescriptorWithKey:@"creationDate" ascending:NO]];
    _fetchResult = [PHAsset fetchAssetsWithOptions:fetchOptions];
    return _fetchResult;
}

@end
