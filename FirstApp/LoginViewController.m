///
///  LoginViewController.m
///  FirstApp
///
///  Created by 若尘 on 2025/1/12.
///

#import "LoginViewController.h"
#import <Masonry.h>
#import "SignHelper.h"
#import "NetworkService.h"
#import "UserSession.h"

@interface LoginViewController ()

/// 用户名
@property (nonatomic, strong) UITextField *accountTextField;
/// 密码
@property (nonatomic, strong) UITextField *passwordTextField;
/// 登录按钮
@property (nonatomic, strong) UIButton *loginButton;
/// 注册按钮
@property (nonatomic, strong) UIButton *registerButton;

@end

@implementation LoginViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
    
    [self initSubviews];

}

/// 初始化子组件
- (void)initSubviews {
    /// subView 加载
    [self.view addSubview:self.accountTextField];
    [self.view addSubview:self.passwordTextField];
    [self.view addSubview:self.loginButton];
    [self.view addSubview:self.registerButton];
    
    /// 账号布局
    [self.accountTextField mas_makeConstraints:^(MASConstraintMaker *make) {
   
        /// x
        make.left.equalTo(@20);
        /// y
        make.top.equalTo(@80);
        /// 有边距
        make.right.equalTo(@-20);
        /// 高
        make.height.equalTo(@40);
    }];
    
    /// 密码布局
    [self.passwordTextField mas_makeConstraints:^(MASConstraintMaker *make) {
        /// x, y, 高度同账号
        make.left.right.height.equalTo(self.accountTextField);
        /// 下边距与帐号偏移20
        make.top.equalTo(self.accountTextField.mas_bottom).offset(20);
    }];
    
    /// 登录按钮布局
    [self.loginButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountTextField);
        make.top.equalTo(self.passwordTextField.mas_bottom).offset(20);
    }];
    
    /// 注册按钮布局
    [self.registerButton mas_makeConstraints:^(MASConstraintMaker *make) {
        make.left.right.height.equalTo(self.accountTextField);
        make.top.equalTo(self.loginButton.mas_bottom).offset(20);
    }];
}

/// 登录按钮点击事件
/// - Parameter sender: sender description
- (void)loginButtonDidClick:(UIButton *)sender {
    NSString *username = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    
    NSString *urlStr = @"http://127.0.0.1:6000/login";
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate now] timeIntervalSince1970]];
    
    NSMutableDictionary *params = [@{@"timestamp": timestamp, @"username": username, @"password": password} mutableCopy];
    NSString *sign = [SignHelper generateSignWithParams:params timestamp:timestamp];
    params[@"sign"] = sign;
    
    [NetworkService postWithUrl:[NSURL URLWithString:urlStr] params:params callback:^(NSData *data, NSURLResponse *response, NSError * error) {
        NSLog(@"error: %@", error);
        if (error) {
            NSLog(@"登录失败: %@", error);
            return;
        }
        
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"resp: %@", resp);
        NSString *msg = resp[@"msg"];
        NSString *code = resp[@"code"];
        NSDictionary *dictionary = resp[@"data"];

        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            if ([code isEqualToString:@"1"]) {
                /// 保存登录信息
                [[UserSession shareInstance] saveUserInfo:dictionary];
                /// 登录成功关闭当前页面
                [self dismissViewControllerAnimated:YES completion:nil];
            } else {
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
                UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                    [alertController dismissViewControllerAnimated:YES completion:nil];
                }];
                [alertController addAction:alertAction];
                /// alert 添加到屏幕上
                [self presentViewController:alertController animated:YES completion:nil];
            }
        });
    
    }];
}

/// 注册按钮点击事件
/// - Parameter sender: sender description
- (void)registerButtonDidClick:(UIButton *)sender {
    NSString *username = self.accountTextField.text;
    NSString *password = self.passwordTextField.text;
    
    /// 注册接口
    NSString *urlStr = @"http://127.0.0.1:6000/register";
    /// 获取时间戳
    NSString *timestamp = [NSString stringWithFormat:@"%f",[[NSDate now] timeIntervalSince1970]];
    /// 请求参数
    NSMutableDictionary *params = [@{@"timestamp": timestamp, @"username": username, @"password": password} 
                                   mutableCopy];
    /// 加密参数
    NSString *sign = [SignHelper generateSignWithParams:params timestamp:timestamp];
    params[@"sign"] = sign;
    
    /// post 请求
    [NetworkService postWithUrl:[NSURL URLWithString:urlStr] params:params callback:^(NSData *data, NSURLResponse *response, NSError * error) {
        NSLog(@"error: %@", error);
        if (error) {
            NSLog(@"注册失败: %@", error);
            return;
        }
        
        NSDictionary *resp = [NSJSONSerialization JSONObjectWithData:data options:0 error:nil];
        NSLog(@"resp: %@", resp);
        NSString *msg = resp[@"msg"];
        
        /// 放入主线程中执行
        dispatch_async(dispatch_get_main_queue(), ^{
//            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"提示" message:msg delegate:nil cancelButtonTitle:nil otherButtonTitles:@"确定", nil];
//            [alert show];
            UIAlertController *alertController = [UIAlertController alertControllerWithTitle:nil message:msg preferredStyle:UIAlertControllerStyleAlert];
            UIAlertAction *alertAction = [UIAlertAction actionWithTitle:@"知道了" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
                /// 点击后关闭当前页面
                [alertController dismissViewControllerAnimated:YES completion:nil];
            }];
            [alertController addAction:alertAction];
            [self presentViewController:alertController animated:YES completion:nil];
            
        });
    }];
}

/// view 点击结束后调用
/// - Parameters:
///   - touches: touches description
///   - event: event description
- (void)touchesEnded:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event {
    [super touchesEnded:touches withEvent:event];
    [self dismissViewControllerAnimated:YES completion:nil];
}

/// 账号 get 方法
- (UITextField *)accountTextField {
    if (_accountTextField == nil) {
        _accountTextField = [[UITextField alloc] init];
        _accountTextField.textColor = [UIColor blackColor];
        _accountTextField.placeholder = @"请输入账号";
        // 边框颜色
        _accountTextField.layer.borderColor = [UIColor blackColor].CGColor;
        _accountTextField.layer.borderWidth = 0.5;
    }
    return _accountTextField;
}

/// 密码 get 方法
- (UITextField *)passwordTextField {
    if (_passwordTextField == nil) {
        _passwordTextField = [[UITextField alloc] init];
        /// 密码加密显示
        _passwordTextField.secureTextEntry = YES;
        _passwordTextField.textColor = [UIColor blackColor];
        _passwordTextField.placeholder = @"请输入密码";
        _passwordTextField.layer.borderColor = [UIColor blackColor].CGColor;
        _passwordTextField.layer.borderWidth = 0.5;
    }
    return _passwordTextField;
}

/// 登录按钮 get 方法
- (UIButton *)loginButton {
    if (_loginButton == nil) {
        _loginButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_loginButton setTitle:@"登录" forState:UIControlStateNormal];
        [_loginButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        /// 登录按钮点击事件
        [_loginButton addTarget:self action:@selector(loginButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _loginButton;
}

/// 注册按钮 get 方法
- (UIButton *)registerButton {
    if (_registerButton == nil) {
        _registerButton = [UIButton buttonWithType:UIButtonTypeCustom];
        [_registerButton setTitle:@"注册" forState:UIControlStateNormal];
        [_registerButton setTitleColor:[UIColor blueColor] forState:UIControlStateNormal];
        /// 注册按钮点击事件
        [_registerButton addTarget:self action:@selector(registerButtonDidClick:) forControlEvents:UIControlEventTouchUpInside];
    }
    return _registerButton;
}
@end
