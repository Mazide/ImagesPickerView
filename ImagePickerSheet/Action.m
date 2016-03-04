//
//  Action.m
//  ImagePickerController
//
//  Created by Nikita Demidov on 02/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import "Action.h"

@implementation Action

-(instancetype)initWithTitle:(NSString *)title handler:(void (^)(Action *))handler{
    self = [super init];
    if (self) {
        _title = [title copy];
        _handler = [handler copy];
    }
    return self;
}

@end
