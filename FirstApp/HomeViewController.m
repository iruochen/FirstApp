//
//  HomeViewController.m
//  FirstApp
//
//  Created by 若尘 on 2025/1/12.
//

#import "HomeViewController.h"
#import "NetworkService.h"
#import "SignHelper.h"
#import <Masonry.h>

@interface HomeViewController ()<UITableViewDataSource>

@property (nonatomic, strong) UITableView *tableView;

/// 商品列表
@property (nonatomic, strong) NSMutableArray *goodsList;
@end

@implementation HomeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.goodsList = [NSMutableArray array];
    
    /// 背景色
    self.view.backgroundColor = [UIColor whiteColor];
    
    /// 添加 tableView
    [self.view addSubview:self.tableView];
    /// 布局
    [self.tableView mas_makeConstraints:^(MASConstraintMaker *make) {
        make.edges.equalTo(self.view);
    }];
}

/// 页面将要加载时调用
- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self requestData];
}

/// 请求数据
- (void)requestData {
    NSString *timestamp = [NSString stringWithFormat:@"%f", [[NSDate now] timeIntervalSince1970]];
    NSString *sign = [SignHelper generateSignWithParams:@{@"timestamp": timestamp} timestamp:timestamp];
    
    NSString *urlStr = [NSString stringWithFormat:@"http://127.0.0.1:6000/products?sign=%@&timestamp=%@", sign, timestamp];
    NSURL *url = [NSURL URLWithString:urlStr];
    [NetworkService getWithUrl:url callback:^(NSData *data, NSURLResponse *response, NSError *error) {
        if (error) {
            NSLog(@"首页请求失败: %@", error);
            return;
        }
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"resp: %@", resp);
        NSString *code = resp[@"code"];
        if (![code isEqualToString:@"1"]) {
            return;
        }
        NSArray *goods = resp[@"data"];
        NSLog(@"goods = %@", goods);
        [self.goodsList addObjectsFromArray:goods];
        /// 异步回调的数据要放到主线程中执行
        dispatch_async(dispatch_get_main_queue(), ^{
            /// 请求完后进行 reloadData 才会显示数据
            [self.tableView reloadData];
        });
    }];
}

/// table 数据行数
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.goodsList.count;
}

/// 每行数据
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    NSDictionary *product = self.goodsList[indexPath.row];
    cell.textLabel.text = product[@"name"];
    return cell;
    
}

/// get 函数
- (UITableView *)tableView {
    if (_tableView == nil) {
        _tableView = [[UITableView alloc] initWithFrame:CGRectZero style:UITableViewStyleGrouped];
        /// dataSource 委托
        _tableView.dataSource = self;
        /// 行高
        _tableView.rowHeight = 120;
        /// cell 复用词
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

@end
