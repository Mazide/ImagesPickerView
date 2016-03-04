//
//  UITableViewCell+RoundedCorners.h
//  ImagePickerSheet
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UITableViewCell (RoundedCorners)

- (void)roundCornersForTableView:(UITableView*)tableView indexPath:(NSIndexPath*)indexPath;

@end
