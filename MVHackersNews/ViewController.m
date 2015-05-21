//
//  ViewController.m
//  MVHackersNews
//
//  Created by indianic on 21/05/15.
//  Copyright (c) 2015 MV. All rights reserved.
//

#import "ViewController.h"
#import "MVHackerNewsClass.h"
#import "RefreshImageView.h"

@interface ViewController ()<HNClassDelegate>
{
    NSMutableArray *mutDatasource;
}
@property (weak, nonatomic) IBOutlet UITableView *tblView;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [MVHackerNewsClass sharedInstance].delegate =  self;
    [[MVHackerNewsClass sharedInstance]getHNTopStories];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(void)HNListUpdated{
    mutDatasource =  [MVHackerNewsClass sharedInstance].datasource;
    [_tblView reloadData];
}

#pragma mark -----------------------
#pragma mark TableVew Datasource Methods

-(NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return mutDatasource.count;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *aCell = [tableView dequeueReusableCellWithIdentifier:@"cell"];
    RefreshImageView *imgView = (RefreshImageView*)[aCell viewWithTag:100];
    MVHNItem *oldItem = imgView.refreshingData;
    oldItem.refreshDelegate = nil;
    
    MVHNStory *newItem = [mutDatasource objectAtIndex:indexPath.row];
    [newItem fetchData];
    newItem.refreshDelegate = imgView;
    

    
    return aCell;
}

@end
