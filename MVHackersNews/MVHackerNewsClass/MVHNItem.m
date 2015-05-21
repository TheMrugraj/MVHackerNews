//
//  MVHNItem.m
//  MVHackersNews
//
//  Created by indianic on 21/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "MVHNItem.h"
#import "Database.h"
#import "NSString+Validation.h"
#import "TFHpple.h"
@implementation MVHNItem

-(void)fetchData{
    
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NO), ^{
        
        if(!_isUpdated){
            if(!firebase){
                firebase = [[[Firebase alloc]initWithUrl:kUrlBaseItem] childByAppendingPath:_itemId];
            }
            
            handle = [firebase observeEventType:FEventTypeValue withBlock:^(FDataSnapshot *snapshot) {

                Database *aDatabaseObj = [[Database alloc]init];
                NSDictionary *aDictValue = snapshot.value;
                [self parseItemInfo:aDictValue];
                NSString *aStrQuery = [NSString stringWithFormat:@"update tblFeedItem set by='%@',score=%ld,timestamp=%ld,title='%@',type='%@',text='%@',url='%@' where itemId=%@",[_by sqlParam],_score,_time,[_title sqlParam],_type,[_text sqlParam],_url,_itemId];
                [aDatabaseObj Update:aStrQuery];
                [firebase removeObserverWithHandle:handle];
                [self getImagesForPage];
                _isUpdated = YES;
            }];
        
        }else{
            [self getImagesForPage];
        }
    });
    
    
}


-(void)getImagesForPage{
    
    if(_images && _images.count>0){
        return;
    }
    NSURL *url = [NSURL URLWithString:_url];
    NSData *data = [NSData dataWithContentsOfURL:url];
    if(data && data.length>0){
        TFHpple *hppleParser = [[TFHpple alloc]initWithHTMLData:data];
        NSString *images = @"//img"; // grabbs all image tags
        NSArray *node = [hppleParser searchWithXPathQuery:images];
        
        NSMutableArray *aMutArrayImages = [NSMutableArray array];
        
        for (int i=0; i<node.count; i++) {
            TFHppleElement *aElement = [node objectAtIndex:i];
            NSDictionary *aArNodes = aElement.attributes;
            NSString *aStrSourcce = aArNodes[@"src"]?aArNodes[@"src"]:(aArNodes[@"data-baseurl"]?aArNodes[@"data-baseurl"]:aArNodes[@"data-url"]);
            
            if(!aStrSourcce){
                continue;
            }
            if([aStrSourcce rangeOfString:@"http"].location==NSNotFound){
                NSString *aBaseURL = [NSString stringWithFormat:@"%@://%@", [url scheme], [url host]];
                aStrSourcce = [aBaseURL stringByAppendingPathComponent:aStrSourcce];
            }
            [aMutArrayImages addObject:aStrSourcce];
        }
        hppleParser = nil;
        data = nil;
        node = nil;
        _images =  aMutArrayImages;
        
        if([_refreshDelegate respondsToSelector:@selector(refreshItemDidUpdated:)]){
            [_refreshDelegate refreshItemDidUpdated:self];
        }
    }
    
}

-(void)fetchDataWithFirebase:(Firebase *)fireBaseRef{
    firebase =  [fireBaseRef childByAppendingPath:_itemId];
    [self fetchData];
}
-(void)parseItemInfo:(NSDictionary*)info{
    _score  = [info[@"score"] longValue];
    _time   = [info[@"time"] longValue];
    _by     = info[@"by"];
    _title  = info[@"title"];
    _text   = info[@"text"];
    _type   = info[@"type"];
    _url    = info[@"url"];
}
@end
