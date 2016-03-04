//
//  PreviewCollectionViewCell.h
//  ImagePickerController
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigureTableViewCellProtocol.h"

@interface PreviewCollectionViewCell : UICollectionViewCell <ConfigureTableViewCellProtocol>

- (void)setChecked:(BOOL)checked;

@property (weak, nonatomic) IBOutlet UIImageView* previewImageView;
@property (weak, nonatomic) IBOutlet UIImageView* checkImageView;

@end
