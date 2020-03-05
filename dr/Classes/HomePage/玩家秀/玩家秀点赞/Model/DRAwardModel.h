//
//  DRAwardModel.h
//  dr
//
//  Created by 毛文豪 on 2019/1/7.
//  Copyright © 2019 JG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRAwardModel : NSObject

@property (nonatomic, copy) NSString * id;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, assign) BOOL receiveable;

@end

NS_ASSUME_NONNULL_END
