//
//  DRAwardSectionModel.h
//  dr
//
//  Created by dahe on 2020/3/5.
//  Copyright © 2020 JG. All rights reserved.
//

#import <Foundation/Foundation.h>

NS_ASSUME_NONNULL_BEGIN

@interface DRAwardSectionModel : NSObject

@property (nonatomic, copy) NSString *desc;
@property (nonatomic, strong) NSMutableArray *rewardList;
@property (nonatomic, assign) long long startTime;
@property (nonatomic, copy) NSString *title;
@property (nonatomic, strong) NSNumber *type; //1领取周 2月

@end

NS_ASSUME_NONNULL_END
