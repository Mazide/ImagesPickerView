//
//  PreviewCollectionViewCell.m
//  ImagePickerController
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "PreviewCollectionViewCell.h"
#import <QuartzCore/QuartzCore.h>

@implementation PreviewCollectionViewCell

- (void)awakeFromNib {
}

- (void)setChecked:(BOOL)checked{
    self.checkImageView.image = checked ? [UIImage imageNamed:@"check"] : [UIImage imageNamed:@"uncheck"];
}

-(void)configureWithItem:(id)item{
    UIImage* image = (UIImage*)item;
    self.previewImageView.image = image;
}

@end
