//
//  FeedsListVC.h
//  FeedDemo
//
//  Created by indianic on 22/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface FeedsListVC : UIViewController
@property (weak, nonatomic) IBOutlet UISegmentedControl *segmentControl;
@property(weak,nonatomic)IBOutlet UITableView *tblView;
- (IBAction)segmentDidChanged:(UISegmentedControl *)sender;
@end
