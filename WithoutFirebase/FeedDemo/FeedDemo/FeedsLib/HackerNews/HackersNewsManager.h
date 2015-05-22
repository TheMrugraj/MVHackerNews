//
//  HackersNewsManager.h
//  FeedDemo
//
//  Created by indianic on 22/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "FeedItem.h"
#import "HNFeedItem.h"
#import "MVHNIdFetcher.h"
#import "AFNetworking.h"

typedef void(^HNCompletionHandler)(id object);

@interface HackersNewsManager : NSObject

+(id)sharedInstance;
-(void)fetchItemIdsCompletion:(HNCompletionHandler)completion withType:(MVHNIdFetchType)type;
-(void)fetchItemDetailsForItems:(NSArray*)arrayItemIds completion:(HNCompletionHandler)completion;
-(void)fetchItemDetailsFrom:(NSInteger)start count:(NSInteger)count completion:(HNCompletionHandler)completion;
-(void)fetchItemDetailsForItemObjects:(NSArray*)arrayItemObjects completion:(HNCompletionHandler)completion;
@end
