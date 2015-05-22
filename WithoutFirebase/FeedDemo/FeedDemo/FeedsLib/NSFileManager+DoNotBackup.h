/********************************************************************************\
 *
 * File Name       NSFileManager+DoNotBackup.h
 * Author          $Author:: IndiaNIC Infotech Ltd  $: Author of last commit
 * Version         $Revision:: 01             $: Revision of last commit
 * Modified        $Date:: 2012-20-09 16:01:19#$: Date of last commit
 *
 * Copyright(c) 2011 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/
#import <Foundation/Foundation.h>

@interface NSFileManager (DoNotBackup)

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)strURL;
-(BOOL)myCreateDirectoryAtPath:(NSString *)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes error:(NSError *__autoreleasing *)error;
-(BOOL)mycreateDirectoryAtURL:(NSURL *)url withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes error:(NSError *__autoreleasing *)error;
-(BOOL)myCreateFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attr;
@end