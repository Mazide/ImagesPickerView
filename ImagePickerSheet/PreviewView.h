//
//  PreviewView.h
//  ImagePickerController
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol PreviewViewDelegate <NSObject>

- (void)didSelectAssets:(NSArray*)assets;

@end

@interface PreviewView : UIView

@property (weak, nonatomic) id<PreviewViewDelegate> delegate;

@end
