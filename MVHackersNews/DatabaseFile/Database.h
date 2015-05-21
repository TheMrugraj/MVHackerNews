//
//  Database.h
//  SheCritiques
//
//  Created by IND411 on 25/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <sqlite3.h>
#import <UIKit/UIKit.h>
#define kDBName @"HNFeeds.db"
#define kAppName @"HackersNews"

@interface Database : NSObject {

	sqlite3 *sqlitedata;
	NSMutableArray *m_MutArrFavortiesData;
}
@property (nonatomic,retain)NSMutableArray *m_MutArrFavortiesData;

-(NSString *)GetDataBasePath;
-(void)Insert:(NSString *)query;
-(void)InsertSpecialChars :(NSString *)query WithParameter:(NSString*)param;
-(NSMutableArray *)selectAllRecords:(NSString *)query;
-(void)Update:(NSString*)query;
-(void)DeleteRecord:(NSString *)query;

@end
