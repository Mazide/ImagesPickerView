//
//  ActionsTableViewService.h
//  ImagePickerController
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "ActionSheetTableView.h"
#import "PreviewView.h"
#import "Action.h"

@class ActionsTableViewService;

@interface ActionsTableViewService : NSObject <UITableViewDataSource, ActionSheetTableViewDelegate>

- (instancetype)initWithActions:(NSArray*)actions cancelActions:(NSArray*)cancelActions previewView:(PreviewView*)previewVeiw;

- (void)replaceAction:(Action*)action byAction:(Action*)newAction;

@end
