//
//  MineViewController.m
//  FirstApp
//
//  Created by 若尘 on 2025/1/12.
//

#import "MineViewController.h"
#import "LoginViewController.h"
#import "UserSession.h"
#import "AboutMeViewController.h"

@interface MineViewController ()<UITableViewDataSource, UITableViewDelegate>

// 登陆按钮
@property (nonatomic, strong) UIButton *loginButton;
// 用户名
@property (nonatomic, strong) UILabel *nameLabel;
// 头像对象
@property (nonatomic, strong) UIImageView *avatarImageView;
// 存放头部数据
@property (nonatomic, strong) UIView *headerView;
// tableView 对象，存放主数据
@property (nonatomic, strong) UITableView *tableView;
@end

@implementation MineViewController

- (void)viewDidLoad {
    [super viewDidLoad];

    self.view.backgroundColor = [UIColor greenColor];
    // 添加 tableView 容器
    [self.view addSubview:self.tableView];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    [self reloadData];
}

- (void)reloadData {
    /// 判断是否登录
    if ([[UserSession shareInstance] isLogin]) {
        self.nameLabel.text = [UserSession shareInstance].userName;
        self.loginButton.hidden = YES;
    } else {
        self.nameLabel.text = @"暂未登录";
        self.loginButton.hidden = NO;
    }
}

/**
 登陆按钮点击事件
 */
- (void)loginButtonDidClick:(UIButton *)sender {
    LoginViewController *login = [[LoginViewController alloc] init];
    // 设置登陆页面全屏
    login.modalPresentationStyle = UIModalPresentationFullScreen;
    // 弹窗形式弹出登陆页面
    [self presentViewController:login animated:YES completion:nil];
}


/// UITableViewDelegate 需要实现的方法
/// - Parameters:
///   - tableView: tableView 对象
///   - indexPath: 行号
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    switch (indexPath.row) {
        case 0:
            /// 跳转到设置页面
            break;
        case 1: {
            /// 关于我
            AboutMeViewController *aboutMe = [[AboutMeViewController alloc] init];
            NSLog(@"navigationController = %@", self.navigationController);
            /// 页面跳转
            [self.navigationController pushViewController:aboutMe animated:YES];
            break;
        }
        case 2:
            /// 退出
            [[UserSession shareInstance] logout];
            /// 重新加载数据
            [self reloadData];
            break;
        default:
            break;
    }
}

/**
 tableView get 方法
 */
- (UITableView *)tableView {
    if (_tableView == nil) {
        // tableView 大小为屏幕大小
        _tableView = [[UITableView alloc] initWithFrame:[UIScreen mainScreen].bounds style:UITableViewStyleGrouped];
        /// 数据源委托，需要实现 UITableViewDataSource 协议
        /// dataSource 对应numberOfRowsInSection、cellForRowAtIndexPath方法
        _tableView.dataSource = self;
        /// 需要实现 UITableViewDelegate 协议
        /// delegate 对应 didSelectRowAtIndexPath 方法
        _tableView.delegate = self;
        
        /// 指定 tableHeaderView 对象
        _tableView.tableHeaderView = self.headerView;
        
        /// 注册cell，标识符为 UITableViewCell
        [_tableView registerClass:[UITableViewCell class] forCellReuseIdentifier:@"UITableViewCell"];
    }
    return _tableView;
}

/**
 UITableViewDataSource 需要实现的方法
 返回 tableView 行数
 */
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 3;
}

/**
 UITableViewDataSource 需要实现的方法
 返回 table 每一行视图
 */
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    // 获取 cell 对象
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"UITableViewCell"];
    
    NSString *text = @"";
    switch (indexPath.row) {
        case 0:
            text = @"设置";
            break;
        case 1:
            text = @"关于我";
            break;
        case 2:
            text = @"退出登录";
        default:
            break;
    }
    cell.textLabel.text = text;
    return cell;
}

/**
 headerView get 方法
 */
- (UIView *)headerView {
    if (_headerView == nil) {
        _headerView = [[UIView alloc] init];
        CGFloat screenWidth = [UIScreen mainScreen].bounds.size.width;
        // x坐标, y坐标, 宽度, 高度
        _headerView.frame = CGRectMake(0, 0, screenWidth, 100);
        // 添加头像、用户名、登陆按钮组件
        [_headerView addSubview:self.avatarImageView];
        [_headerView addSubview:self.nameLabel];
        [_headerView addSubview:self.loginButton];
    }
    return _headerView;
}

/**
 头像 get 方法
 */
- (UIImageView *)avatarImageView {
    if (_avatarImageView == nil) {
        _avatarImageView = [[UIImageView alloc] init];
        // 坐标大小
        _avatarImageView.frame = CGRectMake(20, 20, 60, 60);
        _avatarImageView.backgroundColor = [UIColor grayColor];
        // 设置圆角
        _avatarImageView.layer.cornerRadius = 30;
    }
    return _avatarImageView;
}

/**
 用户名 get 方法
 */
- (UILabel *)nameLabel {
    if (_nameLabel == nil) {
        _nameLabel = [[UILabel alloc] init];
        _nameLabel.text = @"暂未登录";
        _nameLabel.frame = CGRectMake(120, 20, 100, 40);
        _nameLabel.textColor = [UIColor blackColor];
    }
    return _nameLabel;
}

/**
 登陆按钮 get 方法
 */
- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        _loginButton.frame = CGRectMake(120, 60, 80, 40);
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];

        // 绑定按钮点击事件
        [_loginButton addTarget:self action:@selector(loginButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}
@end
