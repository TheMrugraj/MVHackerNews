//
//  MVHackerNewsClass.m
//  MVHackersNews
//
//  Created by indianic on 21/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "MVHackerNewsClass.h"
#import "Database.h"
#import "NSFileManager+DoNotBackup.h"

#define kURLBase @"https://hacker-news.firebaseio.com/v0/topstories"//@"https://hacker-news.firebaseio.com/v0/"

static MVHackerNewsClass *sharedInstance = nil;

@implementation MVHackerNewsClass

+(id)sharedInstance{
    if(!sharedInstance){
        sharedInstance = [[MVHackerNewsClass alloc]init];
    }
    [sharedInstance createEditableCopyOfDatabaseIfNeeded];
    return sharedInstance;
}

-(void)getHNTopStories{
    _datasource = [NSMutableArray array];
    
    firebaseObj = [[Firebase alloc]initWithUrl:kURLBase];

    [firebaseObj observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {
        [self parseTopStories:snapshot.value];
    }];
}

-(void)parseTopStories:(NSDictionary*)info{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NO), ^{
        NSArray *aArray = info;
        for (NSNumber *numId in aArray) {
            Database *databaseObj = [[Database alloc]init];
            [databaseObj Insert:[NSString stringWithFormat:@"insert into tblFeedItem (itemId) values(%ld)",[numId integerValue]]];
            MVHNStory *story = [[MVHNStory alloc]initWithId:[numId stringValue] delegate:nil];
            [_datasource addObject:story];
            
        }
        dispatch_sync(dispatch_get_main_queue(), ^{
            if([_delegate respondsToSelector:@selector(HNListUpdated)]){
                [_delegate HNListUpdated];
            }
        });
        
    });
}


- (void)createEditableCopyOfDatabaseIfNeeded {
    // First, test for existence.
    BOOL success;
    NSFileManager *fileManager = [NSFileManager defaultManager];
    NSError *error;
    
    NSArray *paths = NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
    
    NSString *documentsDirectory = [paths objectAtIndex:0];
    NSString *writableDBPath = [documentsDirectory stringByAppendingPathComponent:kDBName];
    success = [fileManager fileExistsAtPath:writableDBPath];
    NSLog(@"%@",writableDBPath);
    if (success)
        return;
    // The writable database does not exist, so copy the default to the appropriate location.
    NSString *defaultDBPath = [[[NSBundle mainBundle] resourcePath] stringByAppendingPathComponent:kDBName];
    success = [fileManager copyItemAtPath:defaultDBPath toPath:writableDBPath error:&error];
    
    [[NSFileManager defaultManager]addSkipBackupAttributeToItemAtURL:writableDBPath];
    if (!success) {
        NSAssert1(0, @"Failed to create writable database file with message '%@'.", [error localizedDescription]);
    }
    
}
@end
