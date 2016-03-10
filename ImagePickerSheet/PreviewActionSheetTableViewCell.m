//
//  PreviewActionSheetTableViewCell.m
//  ImagePickerController
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "PreviewActionSheetTableViewCell.h"
#import "PreviewView.h"

@implementation PreviewActionSheetTableViewCell

- (void)awakeFromNib {
}


- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

-(void)configureWithItem:(id)item{
    PreviewView* previewView = (PreviewView*)item;
    CGFloat inset = 8.f;
    previewView.frame = CGRectMake(0, inset, self.frame.size.width, 120.f);
    [self addSubview:previewView];
}

@end
