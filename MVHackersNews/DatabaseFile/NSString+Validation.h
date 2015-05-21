//
//  NSString+Validation.h
//  PasteboatiOS
//
//  Created by indianic on 29/12/14.
//  Copyright (c) 2014 IndiaNIC. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface NSString (Validation)

-(BOOL)isValidEmail;
-(BOOL)isValidNumber;
-(BOOL)isValidPhoneNumber;
-(BOOL)isValidAlphabaticString;
-(BOOL)isValidPassword;
-(BOOL)isValidSecuredPassword;
-(BOOL)isValidString;
-(NSString*)trim;

-(NSString*)trueString;
-(NSString*)sqlParam;
-(NSString*)decode;
@end
