//
//  FeedsListVC.m
//  FeedDemo
//
//  Created by indianic on 22/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "FeedsListVC.h"
#import "HackersNewsManager.h"
#import "FeedListCell.h"
@interface FeedsListVC ()
{
    NSMutableArray *mutArrDatasource;
}


@end

@implementation FeedsListVC

- (void)viewDidLoad {
    [super viewDidLoad];
    
    [[HackersNewsManager sharedInstance] fetchItemIdsCompletion:^(id object) {
        
            [[HackersNewsManager sharedInstance]fetchItemDetailsForItemObjects:object completion:^(id object) {
                
                    if([object isKindOfClass:[NSArray class]]){
                        mutArrDatasource = object;
                        [_tblView reloadData];
                    }
                
            }];
    
    } withType:kMVHNIdsNew];
    // Do any additional setup after loading the view.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

#pragma mark -----------------------
#pragma mark TableVew Datasource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mutArrDatasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    FeedListCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    FeedItem *feedItem = [mutArrDatasource objectAtIndex:indexPath.row];
    aCell.textLabel.text =feedItem.title;
    return aCell;
}


- (IBAction)segmentDidChanged:(UISegmentedControl *)sender {
    [[HackersNewsManager sharedInstance] fetchItemIdsCompletion:^(id object) {
        if([object isKindOfClass:[NSArray class]]){
            mutArrDatasource = object;
            [_tblView reloadData];
        }
        [[HackersNewsManager sharedInstance]fetchItemDetailsForItemObjects:object completion:^(id object) {
            
            if([object isKindOfClass:[NSArray class]]){
                mutArrDatasource = object;
                [_tblView reloadData];
            }
        }];
    } withType:sender.selectedSegmentIndex];
}
@end
