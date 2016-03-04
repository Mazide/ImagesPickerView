//
//  ActionsTableViewService.m
//  ImagePickerController
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "ActionsTableViewService.h"
#import "ActionsSheetCell.h"
#import "PreviewActionSheetTableViewCell.h"
#import "UITableViewCell+RoundedCorners.h"
#import "Action.h"

@interface ActionsTableViewService()

@property (strong, nonatomic) NSArray* actions;
@property (strong, nonatomic) NSArray* cancelActions;
@property (nonatomic) BOOL needPreview;

@end

@implementation ActionsTableViewService

-(instancetype)initWithActions:(NSArray *)actions cancelActions:(NSArray *)cancelActions needPreview:(BOOL)needPreview{
    self = [super init];
    if (self) {
        _actions = actions;
        _cancelActions = cancelActions;
        _needPreview = needPreview;
    }
    return self;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowsCount = 0;
    NSInteger previewRowCoount = self.needPreview ? 1 : 0;
    switch (section) {
        case 0:
            rowsCount = self.actions.count + previewRowCoount;
            break;
        case 1:
            rowsCount = self.cancelActions.count;
            break;
        default:
            break;
    }
    return rowsCount;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    NSString* cellIdentifier = [self cellIdentifierForIndexPath:indexPath];
    UITableViewCell<ConfigureTableViewCellProtocol>* cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    if (!cell)
        cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    id item = [self itemForIndexPath:indexPath];
    [cell configureWithItem:item];
    return cell;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSString*)cellIdentifierForIndexPath:(NSIndexPath*)indexPath{
    NSString* cellIdentifier = nil;
    if (indexPath.row == 0 && indexPath.section == 0 && self.needPreview) {
        cellIdentifier = NSStringFromClass([PreviewActionSheetTableViewCell class]);
    } else {
        cellIdentifier = NSStringFromClass([ActionsSheetCell class]);
    }
    return cellIdentifier;
}

- (id)itemForIndexPath:(NSIndexPath*)indexPath{
    id item = nil;
    NSInteger previewRowCount = self.needPreview ? 1 : 0;
    switch (indexPath.section) {
        case 0:{
            item = (self.needPreview && indexPath.row == 0) ? nil : self.actions[indexPath.row - previewRowCount];
        }
            break;
        case 1:
            item = self.cancelActions[indexPath.row];
            break;
        default:
            break;
    }
    return item;
}

#pragma mark - ActionSheetTableViewDelegate

- (void)didSelectItemWithIndexPath:(NSIndexPath *)indexPath{
    Action* action = [self itemForIndexPath:indexPath];
    if (!action)
        return;
    
    action.handler ? action.handler(action) : nil;
}

- (BOOL)showPreview{
    return self.needPreview;
}

@end
