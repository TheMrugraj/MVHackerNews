//
//  MVHNStory.m
//  MVHackersNews
//
//  Created by indianic on 21/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "MVHNStory.h"

@implementation MVHNStory
-(instancetype)initWithId:(NSString *)itemId delegate:(id<HNItemDelegate>)delegate{
    self =  [super init];
    self.delegate = delegate;
    self.itemId = itemId;
//    [self fetchData];
    return self;
}


@end
