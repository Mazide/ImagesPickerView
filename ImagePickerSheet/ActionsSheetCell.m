//
//  ActionsSheetCell.m
//  ImagePickerController
//
//  Created by Nikita Demidov on 02/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "ActionsSheetCell.h"
#import "Action.h"

@implementation ActionsSheetCell

- (void)awakeFromNib {
    
}

- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)configureWithItem:(id)item{
    Action* action = (Action*)item;
    self.title.text = action.title;
}

@end
