//
//  ActionSheetTableView.h
//  ImagePickerSheet
//
//  Created by Nikita Demidov on 04.03.16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <UIKit/UIKit.h>

@protocol ActionSheetTableViewDelegate<NSObject>

- (BOOL)showPreview;
- (void)didSelectItemWithIndexPath:(NSIndexPath*)indexPath;

@end

@interface ActionSheetTableView : UITableView

@property (weak, nonatomic) id<ActionSheetTableViewDelegate> actionSheetDelegate;

@end
