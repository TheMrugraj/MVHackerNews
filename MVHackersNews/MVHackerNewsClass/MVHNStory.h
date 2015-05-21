//
//  MVHNStory.h
//  MVHackersNews
//
//  Created by indianic on 21/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "MVHNItem.h"

@interface MVHNStory : MVHNItem
-(instancetype)initWithId:(NSString*)itemId delegate:(id<HNItemDelegate>)delegate;

@end
