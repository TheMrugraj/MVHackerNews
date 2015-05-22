//
//  FeedItem.h
//  FeedDemo
//
//  Created by indianic on 22/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import <Foundation/Foundation.h>

typedef enum : NSUInteger {
    kFeedTypeHN
} FeedItemType;

@interface FeedItem : NSObject
@property(nonatomic,strong)NSString *title;
@property(nonatomic,strong)NSString *url;
@property(nonatomic,strong)NSString *imageUrl;
@property(nonatomic,assign)FeedItemType type;
@property(nonatomic,assign)NSTimeInterval timestamp;
@property(nonatomic,strong)NSString *hasDetail;
@property(nonatomic,strong)NSString *text;
@end
