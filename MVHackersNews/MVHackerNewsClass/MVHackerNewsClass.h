//
//  MVHackerNewsClass.h
//  MVHackersNews
//
//  Created by indianic on 21/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#import "MVHNStory.h"

@protocol HNClassDelegate <NSObject>
-(void)HNListUpdated;
@end

@interface MVHackerNewsClass : NSObject{
    Firebase *firebaseObj;

}
@property(nonatomic,strong)NSMutableArray *datasource;
@property(nonatomic,strong)id <HNClassDelegate> delegate;
+(instancetype)sharedInstance;
-(void)getHNTopStories;
@end
