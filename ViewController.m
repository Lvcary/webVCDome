//
//  ViewController.m
//  webVCDome
//
//  Created by 刘康蕤 on 16/1/25.
//  Copyright © 2016年 Lvcary. All rights reserved.
//

#import "ViewController.h"
#import "webViewController.h"
@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>

@property (nonatomic, strong) UITableView * tableView;
@property (nonatomic, strong) NSMutableArray * dataSource;
@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.view.backgroundColor = [UIColor orangeColor];
    self.navigationItem.title = @"webVcDome";
    
    self.tableView = ({
        UITableView *table = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, CGRectGetWidth(self.view.frame), CGRectGetHeight(self.view.frame)) style:UITableViewStylePlain];
        table.delegate = self;
        table.dataSource = self;
        table.tableFooterView = [UIView new];
        table;
    });
    
    self.dataSource = [[NSMutableArray alloc] initWithObjects:@"webVcForShare",@"webVcForCare",@"webVcCustom", nil];
    
    [self.view addSubview:self.tableView];
}

#pragma mark     ----tableviewDelegate----
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return _dataSource.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *indefiter = @"cell";
    
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:indefiter];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:indefiter];
    }
    cell.textLabel.text = [self.dataSource objectAtIndex:indexPath.row];
    return cell;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    
    webViewController *webvc = [[webViewController alloc] init];
    webvc.webUrlStr = @"https://www.baidu.com";
    switch (indexPath.row) {
        case 0:
            webvc.itemType = webRightItemShare;
            break;
        case 1:
            webvc.itemType = webrightItemCare;
            break;
        case 2:
            webvc.itemType = webRightItemCustom;
            break;
            
        default:
            break;
    }
    
//    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 80, 25)];
//    view.backgroundColor = [UIColor orangeColor];
//    self.navigationItem.backBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:nil];
    [self.navigationController pushViewController:webvc animated:YES];
    
}


@end
