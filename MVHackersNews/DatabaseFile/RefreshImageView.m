//
//  RefreshImageView.m
//  MVHackersNews
//
//  Created by indianic on 21/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "RefreshImageView.h"

@implementation RefreshImageView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/

-(void)refreshItemDidUpdated:(id)item{
    dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_BACKGROUND, NO), ^{
        
        NSURL *aStrPath = [NSURL URLWithString:[[(MVHNItem*)item images] firstObject]];
        NSData *dataImg =[NSData dataWithContentsOfURL:aStrPath];
        UIImage *img=  [UIImage imageWithData:dataImg];
        dispatch_sync(dispatch_get_main_queue(), ^{
            self.image = img;
        });
        
    });
}
@end
