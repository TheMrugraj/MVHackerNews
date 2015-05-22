//
//  HackersNewsManager.m
//  FeedDemo
//
//  Created by indianic on 22/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "HackersNewsManager.h"

static HackersNewsManager *sharedInstance = nil;

@implementation HackersNewsManager

+(id)sharedInstance{
    if(!sharedInstance){
        sharedInstance = [[HackersNewsManager alloc]init];
    }
    return sharedInstance;
}

#pragma mark - Fetching Methods
//To Just fetch Ids
-(void)fetchItemIdsCompletion:(HNCompletionHandler)completion withType:(MVHNIdFetchType)type{
    MVHNIdFetcher *idFetcher = [[MVHNIdFetcher alloc]init];
    [idFetcher fetchIdsWithType:type completion:completion];
}
//To fetch Details
-(void)fetchItemDetailsForItems:(NSArray *)arrayItemIds completion:(HNCompletionHandler)completion{

}
-(void)fetchItemDetailsFrom:(NSInteger)start count:(NSInteger)count completion:(HNCompletionHandler)completion{

}
-(void)fetchItemDetailsForItemObjects:(NSArray*)arrayItemObjects completion:(HNCompletionHandler)completion{
    for (HNFeedItem *item in arrayItemObjects) {
        if([item isKindOfClass:[HNFeedItem class]]){
            [item fetchDetailWithCompletion:^(id object) {
                
            }];
        }
    }
}

@end
