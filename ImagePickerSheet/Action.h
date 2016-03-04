//
//  Action.h
//  ImagePickerController
//
//  Created by Nikita Demidov on 02/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface Action : NSObject

- (instancetype)initWithTitle:(NSString *)title handler:(void (^)(Action *action))handler;

@property (copy, nonatomic) NSString* title;
@property (nonatomic, copy) void (^handler)(Action *action);

@end
