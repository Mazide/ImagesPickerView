//
//  AssetsHelper.h
//  ImagePickerSheet
//
//  Created by Nikita Demidov on 09.03.16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Photos/Photos.h>

@interface AssetsHelper : NSObject

- (void)imageForAsset:(PHAsset*)asset withCompletion:(void (^)(UIImage* image))completionHandler;

@property (strong, nonatomic) PHFetchResult* fetchResult;

@end
