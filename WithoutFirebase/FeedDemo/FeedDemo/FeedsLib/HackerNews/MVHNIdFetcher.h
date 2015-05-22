//
//  MVHNIdFetcher.h
//  FeedDemo
//
//  Created by indianic on 22/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef void(^HNCompletionHandler)(id object);
typedef enum : NSUInteger {
    kMVHNIdsTop,
    kMVHNIdsNew
} MVHNIdFetchType;

@interface MVHNIdFetcher : NSObject{
    HNCompletionHandler gblCompletionHandler;
}

-(void)fetchIdsWithType:(MVHNIdFetchType)type completion:(HNCompletionHandler)completion;
@end
