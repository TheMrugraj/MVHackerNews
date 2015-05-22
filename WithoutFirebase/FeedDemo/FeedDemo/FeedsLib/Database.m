//
//  Database.m
//  SheCritiques
//
//  Created by IND411 on 25/04/11.
//  Copyright 2011 __MyCompanyName__. All rights reserved.
//

#import "Database.h"
#import "NSFileManager+DoNotBackup.h"
static Database *sharedInstance = nil;

@implementation Database
@synthesize m_MutArrFavortiesData;

+(id)sharedInstance{
    if(!sharedInstance){
        sharedInstance = [[Database alloc]init];
    }
    return sharedInstance;
}

-(NSString *) GetDataBasePath
{
  	NSArray *path=NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES);
	NSString *documentdirectory=[path objectAtIndex:0];
   
	return [documentdirectory stringByAppendingPathComponent:kDBName];
}
-(void)Insert :(NSString *)query
{
	NSString *path=[self GetDataBasePath];
	
	sqlite3_stmt *statment=nil;
	NSString *q=[NSString stringWithFormat:@"%@",query];
	char CharQuery[q.length];
	sprintf(CharQuery,"%s",[q UTF8String]);
	

	if(sqlite3_open([path UTF8String],&sqlitedata)==SQLITE_OK)
	{
		if(sqlite3_prepare_v2(sqlitedata,[query UTF8String], -1, &statment,NULL)==SQLITE_OK)
		{
			sqlite3_step(statment);
		}
		else 
		{
            UIAlertView *alert=[[UIAlertView alloc]initWithTitle:kAppName message:@"ERROR IN INSERTION" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		sqlite3_finalize(statment);
	}
	else
	{
		UIAlertView *alert =[[UIAlertView alloc]initWithTitle:kAppName message:@"ERROR  IN CONNECTION" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	sqlite3_close(sqlitedata);
    
}

-(void)InsertSpecialChars :(NSString *)query WithParameter:(NSString*)param
{
	NSString *path=[self GetDataBasePath];
	
	sqlite3_stmt *statment=nil;
	NSString *q=[NSString stringWithFormat:@"%@",query];
	char CharQuery[q.length];
	sprintf(CharQuery,"%s",[q UTF8String]);
	
    
	if(sqlite3_open([path UTF8String],&sqlitedata)==SQLITE_OK)
	{
		if(sqlite3_prepare_v2(sqlitedata,[query UTF8String], -1, &statment,NULL)==SQLITE_OK)
		{
            sqlite3_bind_text(statment, 1, [param UTF8String], -1, SQLITE_TRANSIENT);
			sqlite3_step(statment);
		}
		else
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:kAppName message:@"ERROR IN INSERTION" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		sqlite3_finalize(statment);
	}
	else
	{
		UIAlertView *alert =[[UIAlertView alloc]initWithTitle:kAppName message:@"ERROR  IN CONNECTION" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
	sqlite3_close(sqlitedata);
    
}

-(NSMutableArray *) selectAllRecords:(NSString *)sql{
    
    sqlite3_stmt *statement = nil ;
    NSString *path = [self GetDataBasePath];
    
    NSMutableArray *alldata;
    alldata = [[NSMutableArray alloc] init];
    
    if(sqlite3_open([path UTF8String],&sqlitedata) == SQLITE_OK )
    {
        NSString *query = sql;
        
        if((sqlite3_prepare_v2(sqlitedata,[query UTF8String],-1, &statement, NULL)) == SQLITE_OK)
        {
            while(sqlite3_step(statement) == SQLITE_ROW)
            {    
                
                NSMutableDictionary *currentRow = [[NSMutableDictionary alloc] init];
                
                int count = sqlite3_column_count(statement);
                
                for (int i=0; i < count; i++) {
                    
                    char *name = (char*) sqlite3_column_name(statement, i);
                    char *data = (char*) sqlite3_column_text(statement, i);
                    
                    NSString *columnData;   
                    NSString *columnName = [NSString stringWithCString:name encoding:NSUTF8StringEncoding];
                    
                    if (data!=nil) {
                        columnData = [NSString stringWithCString:data encoding:NSUTF8StringEncoding];
                    }else {
                        columnData=@" ";
                    }
                    columnData =[(NSString *)columnData stringByReplacingOccurrencesOfString:@"%" withString:@"#perctage#"];
                    columnData=[columnData stringByReplacingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
                    columnData =[(NSString *)columnData stringByReplacingOccurrencesOfString:@"#perctage#" withString:@"%"];
                    [currentRow setObject:columnData forKey:columnName];
                }
                
                [alldata addObject:currentRow];
                [currentRow release];
            }
        }
        else{
            NSLog(@"error In fatching from Database %s",sqlite3_errmsg(sqlitedata));
        }
        sqlite3_finalize(statement); 
    }
    else{
        NSLog(@"error In opening Database %s",sqlite3_errmsg(sqlitedata));
    }
    sqlite3_close(sqlitedata);
    
    return [alldata retain];
    
}

-(void)Update:(NSString*)query
{
    sqlite3_stmt *stmt = nil;
    NSString *db = [self GetDataBasePath];
    
    if(stmt == nil)
    {
        if(sqlite3_open([db UTF8String], &sqlitedata) != SQLITE_OK)
        {
            sqlite3_close(sqlitedata);
            UIAlertView *alert =[[UIAlertView alloc]initWithTitle:kAppName message:@"ERROR  IN CONNECTION" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
            [alert show];
            [alert release];
        }
        else
        {
            if((sqlite3_prepare_v2(sqlitedata, [query UTF8String], -1, &stmt, NULL)) != SQLITE_OK)
            {
                UIAlertView *alert=[[UIAlertView alloc]initWithTitle:kAppName message:@"ERROR IN UPDATE" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
                [alert show];
                [alert release];
                 sqlite3_close(sqlitedata);
                //NSAssert1(0, @"Error while creating add statement. '%s'", sqlite3_errmsg(sqlitedata));
            }
            else
            {
                sqlite3_step(stmt);
                sqlite3_finalize(stmt);
                sqlite3_close(sqlitedata);
                
            }
        }
    }
}
-(void)DeleteRecord:(NSString *)query
{
	sqlite3_stmt *statment=nil;
	NSString *q=[NSString stringWithFormat:@"%@",query];
	char CharQuery[q.length];
	sprintf(CharQuery,"%s",[q UTF8String]);
	NSString *path=[self GetDataBasePath];
	
	if(sqlite3_open([path UTF8String],&sqlitedata)==SQLITE_OK)
	{
		if(sqlite3_prepare_v2(sqlitedata, CharQuery, -1, &statment,NULL)==SQLITE_OK)
		{
			sqlite3_step(statment);
		}
		else 
		{
			UIAlertView *alert=[[UIAlertView alloc]initWithTitle:kAppName message:@"ERROR IN DELETAION" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
			[alert show];
			[alert release];
		}
		sqlite3_finalize(statment);
	}
	else 
	{
		UIAlertView  *alert=[[UIAlertView alloc]initWithTitle:kAppName message:@"ERROR IN CONNECTION" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil];
		[alert show];
		[alert release];
	}
    
	sqlite3_close(sqlitedata);
}

-(void)dealloc
{
	[super dealloc];
}

- (void)createEditableCopyOfDatabaseIfNeeded{
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
