//
//  HNFeedItem.m
//  FeedDemo
//
//  Created by indianic on 22/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "HNFeedItem.h"
#import "AFNetworking.h"
#import "Database.h"
#import "NSString+Validation.h"
@implementation HNFeedItem

#define kURLItemDetail @"https://hacker-news.firebaseio.com/v0/item/%@.json"

-(instancetype)initWithId:(NSString*)strHNItemId{
    self = [super init];
    _itemHNId =  [strHNItemId rangeOfString:@"HN"].location==NSNotFound?[NSString stringWithFormat:@"HN-%@",strHNItemId]:strHNItemId;
    super.type = kFeedTypeHN;
    return self;
}

-(NSString*)itemHNUrl{
    return [NSString stringWithFormat:kURLItemDetail,[_itemHNId stringByReplacingOccurrencesOfString:@"HN-" withString:@""]];
}

-(void)fetchDetailWithCompletion:(HNCompletionHandler)completion{
    
    if(!_itemHNId || ![_itemHNId isKindOfClass:[NSString class]]){
        NSLog(@"NO ITEM ID Found");
        return;
    }
    
    gblCompletion =  completion;

    AFHTTPRequestOperationManager *manager = [AFHTTPRequestOperationManager manager];
    [manager GET:[self itemHNUrl] parameters:nil success:^(AFHTTPRequestOperation *operation, id responseObject) {
        [self dumpDataIntoDB:responseObject];
        if(gblCompletion){
            gblCompletion(self);
        }
    } failure:^(AFHTTPRequestOperation *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        if(gblCompletion){
            gblCompletion(error);
        }
    }];
    
}

-(void)dumpDataIntoDB:(NSDictionary*)dict{
    
    FMDatabase *db = [FMDatabase databaseWithPath:[[Database sharedInstance] GetDataBasePath]];
    if(![db open]){
        db = nil;
        return;
    }
    //UPDATE players SET user_name='steven', age=32 WHERE user_name='steven';
    NSString *strQuery = [NSString stringWithFormat:@"UPDATE tblFeedItem SET url='%@', title='%@', text='%@',timestamp_post=%ld,has_detail=1 where feedId='%@'",[dict[@"url"] sqlParam],[dict[@"title"] sqlParam],[dict[@"text"] sqlParam],[dict[@"time"] integerValue],_itemHNId];
    BOOL success = [db executeQuery:strQuery];
    if(!success){
        NSLog(@"Error");
    }
    [db close];
    
}
@end
