//
//  MainViewController.m
//  ContactListDemo
//
//  Created by 周栋梁 on 2021/12/4.
//

#import "MainViewController.h"
#import "ViewController.h"

@interface MainViewController ()

@end

@implementation MainViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

- (IBAction)open:(id)sender {
    NSLog(@"弹出");
    
    //申请授权访问通讯录
    [self reqAuthContact];

}
//弹出通讯录列表
- (void) precentContactVC {
    ViewController * vc = [[ViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}

//申请授权访问通讯录
- (void) reqAuthContact {
    //申请授权访问通讯录
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    CNContactStore * store = [[CNContactStore alloc] init];
    switch (status) {
        case CNAuthorizationStatusNotDetermined://用户还没决定授权
            {
                [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted,NSError * _Nullable error){
                    
                    if (granted) {
                        NSLog(@"授权成功");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            //弹出通讯录列表
                            [self precentContactVC];
                        });
                    }else{
                        NSLog(@"授权失败");
                        dispatch_async(dispatch_get_main_queue(), ^{
                            [self alertReTry];
                        });
                    }
                }];
            }
            break;
        case CNAuthorizationStatusRestricted://当前手机用户,无权授权
            {
                //给用户提示:您没被授权开放通讯录权限,请联系机主
                [self alertOK:@"您没被授权开放通讯录权限,请联系机主."];
            }
            break;
        case CNAuthorizationStatusDenied://明确拒绝了访问通讯录
            {
                NSLog(@"明确拒绝了访问通讯录");
                //提示去授权
                [self alertReTry];
            }
            break;
        case CNAuthorizationStatusAuthorized://已经同意方案通讯录
            {
                NSLog(@"授权成功2");
                //弹出通讯录列表
                [self precentContactVC];
            }
            break;
        default:
            break;
    }
}

//给用户提示:授权失败,这将无法继续  取消,再次一次
- (void) alertReTry {

    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"授权失败,这将无法继续,请重新去授权."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    // 具体操作
    UIAlertAction *reTry = [UIAlertAction actionWithTitle:@"去授权"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *_Nonnull action) {
        //去授权
        NSURL *url = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
        NSDictionary *options = @{UIApplicationOpenURLOptionUniversalLinksOnly:@NO};
        [[UIApplication sharedApplication] openURL:url options:options completionHandler:nil];
        
        //反正App都要重启，有没有这句无所谓
        [self dismissViewControllerAnimated:YES completion:nil];//关闭当前窗口
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:^(UIAlertAction *_Nonnull action) {
        //提示用户无法继续了
        [self alertOK:@"取消授权将无法继续操作."];
    }];

    [alert addAction:reTry];
    [alert addAction:cancel];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}
//确认对话框
- (void) alertOK:(NSString *)msg {

    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:msg
                                                            preferredStyle:UIAlertControllerStyleAlert];
    UIAlertAction *ok = [UIAlertAction actionWithTitle:@"知道了"
                                                     style:UIAlertActionStyleDefault
                                                   handler:^(UIAlertAction *_Nonnull action) {
        //确定后的操作
        [self dismissViewControllerAnimated:YES completion:nil];//关闭当前窗口
        
    }];

    [alert addAction:ok];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

@end
