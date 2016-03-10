//
//  ActionsSheetCell.m
//  ImagePickerController
//
//  Created by Nikita Demidov on 02/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "ActionsSheetCell.h"
#import "Action.h"
#import "UITableViewCell+RoundedCorners.h"

@implementation ActionsSheetCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];
}

- (void)configureWithItem:(id)item{
    Action* action = (Action*)item;
    self.title.text = action.title;
}

@end
