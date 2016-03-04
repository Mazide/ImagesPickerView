//
//  ActionSheetTableView.m
//  ImagePickerSheet
//
//  Created by Nikita Demidov on 04.03.16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "ActionSheetTableView.h"
#import "UITableViewCell+RoundedCorners.h"
#import "ActionsSheetCell.h"
#import "PreviewActionSheetTableViewCell.h"

static const CGFloat actionRowHeight = 60.f;
static const CGFloat previewRowHeight = 120.f;
static const CGFloat sectionsHeaderHeight = 20.f;

static const NSInteger actionsSectionIndex = 0;
static const NSInteger previewRowIndex = 0;

@interface ActionSheetTableView() <UITableViewDelegate>

@end

@implementation ActionSheetTableView

- (instancetype)initWithFrame:(CGRect)frame{
    self = [super initWithFrame:frame];
    if (self) {
        self.delegate = self;
        [self setup];
    }
    return self;
}

- (void)setup{
    self.backgroundColor = [UIColor clearColor];
    self.scrollEnabled = NO;
    
    NSString* actionCellIdentifier = NSStringFromClass([ActionsSheetCell class]);
    [self registerNib:[UINib nibWithNibName:actionCellIdentifier bundle:nil] forCellReuseIdentifier:actionCellIdentifier];
    
    NSString* previewActionSheetIdentifier = NSStringFromClass([PreviewActionSheetTableViewCell class]);
    [self registerNib:[UINib nibWithNibName:previewActionSheetIdentifier bundle:nil] forCellReuseIdentifier:previewActionSheetIdentifier];
}

#pragma mark - UITableViewDelegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
//    Action* action = [self itemForIndexPath:indexPath];
//    action.handler ? action.handler(action) : nil;
    if (self.actionSheetDelegate && [self.actionSheetDelegate respondsToSelector:@selector(didSelectItemWithIndexPath:)]) {
        [self.actionSheetDelegate didSelectItemWithIndexPath:indexPath];
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath{
    [cell roundCornersForTableView:tableView indexPath:indexPath];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    BOOL needShowPreview = NO;
    if (self.actionSheetDelegate && [self.actionSheetDelegate respondsToSelector:@selector(showPreview)])
        needShowPreview = [self.actionSheetDelegate showPreview];
    
    if (indexPath.section == actionsSectionIndex && indexPath.row == previewRowIndex && needShowPreview)
        return previewRowHeight;
    
    return actionRowHeight;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section{
    
    if (section == actionsSectionIndex) {
        return nil;
    }
    
    UIView* footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    UIView* footer = [[UIView alloc] init];
    footer.backgroundColor = [UIColor clearColor];
    return footer;
}

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section{
    
    if (section == actionsSectionIndex)
        return 0;
    
    return sectionsHeaderHeight;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    return sectionsHeaderHeight;
}

@end