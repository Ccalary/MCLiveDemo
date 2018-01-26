//
//  VotingResultsModel.h
//  LiveHome
//
//  Created by nie on 2017/12/26.
//  Copyright © 2017年 chh. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface VotingResultsModel : NSObject

@property(nonatomic, copy) NSString *content;
@property(nonatomic, assign) int count;
@property(nonatomic, assign) int resultsId;
@property(nonatomic, copy) NSString *image;
@property(nonatomic, assign) BOOL vote;

@end
