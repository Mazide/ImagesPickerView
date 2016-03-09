//
//  PreviewViewService.h
//  ImagePickerSheet
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PreviewServiceDelegate <NSObject>



@end

@interface PreviewViewService : NSObject <UICollectionViewDataSource>

- (void)selectedPhotoWithIndexPath:(NSIndexPath*)indexPath;
- (BOOL)photoByIndexPathSelected:(NSIndexPath*)indexPath;

@end
