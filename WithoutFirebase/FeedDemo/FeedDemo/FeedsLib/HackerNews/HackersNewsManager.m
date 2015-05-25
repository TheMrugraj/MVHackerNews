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
    sharedInstance.mutArrHNFeeds = [NSMutableArray array];
    return sharedInstance;
}

#pragma mark - Fetching Methods
//To Just fetch Ids
-(void)fetchItemIdsCompletion:(HNCompletionHandler)completion withType:(MVHNIdFetchType)type{
    gblListCompletionHandler = completion;
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, NO), ^{
        
        if(gblListCompletionHandler){
            if(type==kMVHNIdsNew && _cacheNewFeeds){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    gblListCompletionHandler(_cacheNewFeeds);});
            }else if(type==kMVHNIdsTop && _cacheTopFeeds){
                dispatch_sync(dispatch_get_main_queue(), ^{
                    gblListCompletionHandler(_cacheTopFeeds);});
            }
        }
        
        MVHNIdFetcher *idFetcher = [[MVHNIdFetcher alloc]init];
        [idFetcher fetchIdsWithType:type completion:^(id object){
            if(type==kMVHNIdsNew){
                _cacheNewFeeds =  object;
            }else{
                _cacheTopFeeds =  object;
            }

                gblListCompletionHandler(object);

        }];
    });
    
    
}
//To fetch Details
-(void)fetchItemDetailsForItems:(NSArray *)arrayItemIds completion:(HNCompletionHandler)completion{

}
-(void)fetchItemDetailsFrom:(NSInteger)start count:(NSInteger)count completion:(HNCompletionHandler)completion{

}
-(void)fetchItemDetailsForItemObjects:(NSMutableArray*)arrayItemObjects completion:(HNCompletionHandler)completion{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_LOW, NO), ^{
        gblCompletionHandler =  completion;
        _mutArrHNFeeds = arrayItemObjects;
        totalFeeds =  arrayItemObjects.count;
        counter = 0;
        for (HNFeedItem *item in arrayItemObjects) {
            if([item isKindOfClass:[HNFeedItem class]]){
                [item fetchDetailWithCompletion:^(id object) {
    //                [_mutArrHNFeeds addObject:object];
                    counter++;
                    NSLog(@"%ld/%ld  === %@ ",counter,totalFeeds,object);
                    if(counter==totalFeeds){
                        dispatch_sync(dispatch_get_main_queue(), ^{
                            gblCompletionHandler(_mutArrHNFeeds);
                        });
                    }
                }];
            }
        }
    });
}

@end
