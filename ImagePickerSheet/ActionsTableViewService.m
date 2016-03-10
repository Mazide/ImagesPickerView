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
#import "PreviewView.h"

@interface ActionsTableViewService()

@property (strong, nonatomic) NSArray* actions;
@property (strong, nonatomic) NSArray* cancelActions;

@property (strong, nonatomic) PreviewView* previewView;
@property (strong, nonatomic) NSIndexPath* attachActionIndexPath;

@end

@implementation ActionsTableViewService

-(instancetype)initWithActions:(NSArray *)actions cancelActions:(NSArray *)cancelActions previewView:(id)previewVeiw{
    self = [super init];
    if (self) {
        _actions = actions;
        _cancelActions = cancelActions;
        _previewView = previewVeiw;
    }
    return self;
}

- (void)replaceAction:(id)action byAction:(id)newAction{
    
    NSInteger actionRow = [self.actions indexOfObject:action] - (self.previewView ? 1 : 0);
    self.attachActionIndexPath = [NSIndexPath indexPathForRow:actionRow inSection:0];
  
    NSMutableArray* newActions = [NSMutableArray arrayWithArray:self.actions];
    
    NSInteger actionIndex = [self.actions indexOfObject:action];
    [newActions replaceObjectAtIndex:actionIndex withObject:newAction];
    
    self.actions = (NSArray*)newActions;
}

#pragma mark - UITableViewDelegate

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    NSInteger rowsCount = 0;
    NSInteger previewRowCoount = self.previewView ? 1 : 0;
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
    if (indexPath.row == 0 && indexPath.section == 0 && self.previewView) {
        cellIdentifier = NSStringFromClass([PreviewActionSheetTableViewCell class]);
    } else {
        cellIdentifier = NSStringFromClass([ActionsSheetCell class]);
    }
    return cellIdentifier;
}

- (id)itemForIndexPath:(NSIndexPath*)indexPath{
    id item = nil;
    NSInteger previewRowCount = self.previewView ? 1 : 0;
    switch (indexPath.section) {
        case 0:{
            item = (self.previewView && indexPath.row == 0) ? self.previewView : self.actions[indexPath.row - previewRowCount];
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
    return self.previewView ? YES : NO;
}

@end
