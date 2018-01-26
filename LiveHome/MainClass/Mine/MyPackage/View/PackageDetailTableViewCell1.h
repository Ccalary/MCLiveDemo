//
//  PackageDetailTableViewCell1.h
//  LiveHome
//
//  Created by chh on 2017/11/17.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <UIKit/UIKit.h>
#import "PackageDetailModel.h"
typedef void(^cell1Block)(NSInteger tag);

@interface PackageDetailTableViewCell1 : UITableViewCell
@property (nonatomic, strong) NSArray *dataArray;
@property (nonatomic, copy) cell1Block block;
@end
