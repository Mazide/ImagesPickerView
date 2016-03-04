//
//  ActionsSheetCell.h
//  ImagePickerController
//
//  Created by Nikita Demidov on 02/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ConfigureTableViewCellProtocol.h"

@interface ActionsSheetCell : UITableViewCell <ConfigureTableViewCellProtocol>

@property (weak, nonatomic) IBOutlet UILabel* title;

@end
