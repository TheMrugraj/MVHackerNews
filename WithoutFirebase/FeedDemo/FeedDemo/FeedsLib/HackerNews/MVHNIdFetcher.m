//
//  MVHNIdFetcher.m
//  FeedDemo
//
//  Created by indianic on 22/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "MVHNIdFetcher.h"
#import "AFNetworking.h"
#import "Database.h"
#import "FMDB.h"
#import "HNFeedItem.h"
@implementation MVHNIdFetcher

#define kURLTopStories @"https://hacker-news.firebaseio.com/v0/topstories.json"
#define kURLNewStories @"https://hacker-news.firebaseio.com/v0/newstories.json"

-(void)fetchIdsWithType:(MVHNIdFetchType)type completion:(HNCompletionHandler)completion{
    gblCompletionHandler = completion;
    NSString *aStrUrlToUse = type==kMVHNIdsTop?kURLTopStories:kURLNewStories;
    
    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:aStrUrlToUse parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        if([responseObject isKindOfClass:[NSArray class]]){
            [self insertIdsIntoDB:responseObject];
        }else if(gblCompletionHandler){
            gblCompletionHandler(responseObject);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        gblCompletionHandler(error);
    }];
    
}

-(void)insertIdsIntoDB:(NSArray*)arrayOfId{
    
//    -- Try to update any existing row
//    UPDATE players SET user_name='steven', age=32 WHERE user_name='steven';
//    
//    -- Make sure it exists
//    INSERT OR IGNORE INTO players (user_name, age) VALUES ('steven', 32);

    FMDatabase *databaseObj = [FMDatabase databaseWithPath:[[Database sharedInstance] GetDataBasePath]];
    
    NSMutableArray *aArrayMultipleQuery = [NSMutableArray array];
    NSMutableArray *aArrayItems = [NSMutableArray array];
    
    for (NSNumber *number in arrayOfId) {
        NSString *aStrItemId = [NSString stringWithFormat:@"HN-%ld",number.integerValue];
        NSString *aStrQuery = [NSString stringWithFormat:@"INSERT OR IGNORE INTO tblFeedItem (feedId) VALUES ('%@')",aStrItemId];
        [aArrayMultipleQuery addObject:aStrQuery];
        HNFeedItem *feedItem = [[HNFeedItem alloc]initWithId:aStrItemId];
        [aArrayItems addObject:feedItem];
        aStrItemId = nil;
    }
    
    NSString *aStrCombinedQuery = [aArrayMultipleQuery componentsJoinedByString:@";\n"];
    [aArrayMultipleQuery removeAllObjects];
    aArrayMultipleQuery = nil;
    
    if(![databaseObj open]){
        NSLog(@"DB not Opened..");
        return;
    }

    BOOL success = [databaseObj executeStatements:aStrCombinedQuery];
    NSLog(success?@"Batch Updated":@"Failed to update Batch");
    [databaseObj close];
    
    if(gblCompletionHandler){
        gblCompletionHandler(aArrayItems);
    }
}
@end
