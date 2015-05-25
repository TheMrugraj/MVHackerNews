//
//  HNFeedItem.h
//  FeedDemo
//
//  Created by indianic on 22/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "FeedItem.h"
typedef void(^HNCompletionHandler)(id object);
@interface HNFeedItem : FeedItem{
    HNCompletionHandler gblCompletion;
}

@property(nonatomic,strong)NSString *itemHNId;

-(instancetype)initWithId:(NSString*)strHNItemId;
-(void)fetchDetailWithCompletion:(HNCompletionHandler)completion;
@end
