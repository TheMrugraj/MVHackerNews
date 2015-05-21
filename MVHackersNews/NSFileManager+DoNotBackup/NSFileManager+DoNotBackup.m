/********************************************************************************\
 *
 * File Name       NSFileManager+DoNotBackup.m
 * Author          $Author:: IndiaNIC Infotech Ltd  $: Author of last commit
 * Version         $Revision:: 01             $: Revision of last commit
 * Modified        $Date:: 2012-20-09 16:01:19#$: Date of last commit
 *
 * Copyright(c) 2011 IndiaNIC.com. All rights reserved.
 *
 \********************************************************************************/


#import "NSFileManager+DoNotBackup.h"
#include <sys/xattr.h>

@implementation NSFileManager (DoNotBackup)

- (BOOL)addSkipBackupAttributeToItemAtURL:(NSString *)strURL
{
    NSURL *URL =[NSURL URLWithString:strURL];
    const char* filePath = [[URL path] fileSystemRepresentation];
    const char* attrName = "com.apple.MobileBackup";
    if (&NSURLIsExcludedFromBackupKey == nil) {
        // iOS 5.0.1 and lower
        u_int8_t attrValue = 1;
        int result = setxattr(filePath, attrName, &attrValue, sizeof(attrValue), 0, 0);
        return result == 0;
    }
    else {
        // First try and remove the extended attribute if it is present
        long result = getxattr(filePath, attrName, NULL, sizeof(u_int8_t), 0, 0);
        if (result != -1) {
            // The attribute exists, we need to remove it
            int removeResult = removexattr(filePath, attrName, 0);
            if (removeResult == 0) {
                NSLog(@"Removed extended attribute on file %@", URL);
            }
        }
        
        // Set the new key
        NSError *error = nil;
        [URL setResourceValue:[NSNumber numberWithBool:YES] forKey:NSURLIsExcludedFromBackupKey error:&error];
        return error == nil;
    }
}
-(BOOL)myCreateDirectoryAtPath:(NSString *)path withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes error:(NSError *__autoreleasing *)error{
    BOOL result =  [self createDirectoryAtPath:path withIntermediateDirectories:createIntermediates attributes:attributes error:error];
    [self addSkipBackupAttributeToItemAtURL:path];
    return result;
}
-(BOOL)mycreateDirectoryAtURL:(NSURL *)url withIntermediateDirectories:(BOOL)createIntermediates attributes:(NSDictionary *)attributes error:(NSError *__autoreleasing *)error{
    BOOL result =  [self createDirectoryAtURL:url withIntermediateDirectories:createIntermediates attributes:attributes error:error];
    [self addSkipBackupAttributeToItemAtURL:url.path];
    return result;
}
-(BOOL)myCreateFileAtPath:(NSString *)path contents:(NSData *)data attributes:(NSDictionary *)attr{
    BOOL result =  [self createFileAtPath:path contents:data attributes:attr];
    [self addSkipBackupAttributeToItemAtURL:path];
    return result;
}


@end