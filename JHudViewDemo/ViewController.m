//
//  ViewController.m
//  JHudViewDemo
//
//  Created by 晋先森 on 16/7/11.
//  Copyright © 2016年 晋先森. All rights reserved.
//

#import "ViewController.h"
#import "DetailViewController.h"

@interface ViewController () <UITableViewDelegate,UITableViewDataSource>

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (nonatomic) NSArray  *datas;


@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.datas = @[@"loadingCircleAnimation",
                   @"loadingCircleJoinAnimation",
                   @"loadingDotAnimation",
                   @"loadingCustomAnimations",
                   @"loadingGifAnimations",
                   @"loadingFailure",
                   @"loadingFailure2",
                   @"classMethod",
                   ];
    
    [self.tableView reloadData];
}

#pragma mark  --  <UITableViewDelegate,UITableViewDataSource>

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _datas.count;
}


-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString * cellID = @"JHUD";
    UITableViewCell * cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = _datas[indexPath.row];

    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:NO];

    DetailViewController * detailVC = [DetailViewController new];
    detailVC.selName = _datas[indexPath.row];
    [self.navigationController pushViewController:detailVC animated:YES];
}



- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
