//
//  ConfigureTableViewCellProtocol.h
//  ImagePickerController
//
//  Created by Nikita Demidov on 03/03/16.
//  Copyright © 2016 Nikita Demidov. All rights reserved.
//

#import <Foundation/Foundation.h>

@protocol ConfigureTableViewCellProtocol <NSObject>

- (void)configureWithItem:(id)item;

@end
