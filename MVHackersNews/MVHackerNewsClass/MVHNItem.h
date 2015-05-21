//
//  MVHNItem.h
//  MVHackersNews
//
//  Created by indianic on 21/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <Firebase/Firebase.h>
#define kUrlBaseItem @"https://hacker-news.firebaseio.com/v0/item/"

@protocol HNItemDelegate <NSObject>

@end
@protocol HNItemRefreshDelegate <NSObject>
-(void)refreshItemDidUpdated:(id)item;
@end


@interface MVHNItem : NSObject{
    Firebase *firebase;
    FirebaseHandle handle;
}
@property(nonatomic,assign)BOOL isUpdated;
@property(nonatomic,strong)NSString*itemId;
@property(nonatomic,strong)id <HNItemDelegate> delegate;
@property(nonatomic,strong)NSMutableArray  *images;
@property(nonatomic,strong)NSString *by,*title,*text,*type,*url;
@property(nonatomic,assign)long score,time;
@property(nonatomic,strong)id <HNItemRefreshDelegate> refreshDelegate;

-(void)fetchData;
-(void)fetchDataWithFirebase:(Firebase*)fireBaseRef;
-(void)getImagesForPage;
@end
