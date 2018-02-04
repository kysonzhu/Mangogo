//
//  ViewController.m
//  Mongo
//
//  Created by zhujinhui on 16/10/18.
//  Copyright © 2016年 kyson. All rights reserved.
//

#import "ViewController.h"
#import "MGTaskPool.h"
#import "UserCenterNetworkServiceMediator.h"
#import "NetAccessDemoViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView   *tableView;
@property (nonatomic, strong) NSArray       *arrayData;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = UIColor.whiteColor;
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    [self.view addSubview:self.tableView];
    [MGTaskPool registerNetworkMediatorWithName:NSStringFromClass(UserCenterNetworkServiceMediator.class)];
    [[MGTaskPool shareInstance] addDelegate:self];
    [[MGTaskPool shareInstance] doServiceWithName:SERVICENAME_KYSON_INDEX params:nil];
}



-(void)taskpool:(MGTaskPool *) pool serviceFinished:(id )service response:(MGServiceResponse *) response {
    
}



- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayData.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *cellIdentifier = @"cellIdentifier";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellIdentifier];
    
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:cellIdentifier];
    }
    cell.textLabel.text = self.arrayData[indexPath.row];
    return cell;
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    NetAccessDemoViewController *vc = [[NetAccessDemoViewController alloc] init];
    [self.navigationController pushViewController:vc animated:YES];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(UITableView *)tableView{
    if (!_tableView) {
        _tableView = [[UITableView alloc] initWithFrame: CGRectMake(0, 0, [UIScreen mainScreen].bounds.size.width, [UIScreen mainScreen].bounds.size.height)];
    }
    return _tableView;
}


-(NSArray *)arrayData{
    if (!_arrayData) {
        _arrayData = @[@"NetAccessDemoViewController"];
    }
    return _arrayData;
}

@end

