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

- (IBAction)create:(id)sender {
    //申请授权访问通讯录，并创建联系人
    [self reqAuthContact:1];
}

- (IBAction)open:(id)sender {
    NSLog(@"弹出通讯录");
    
    //申请授权访问通讯录
    [self reqAuthContact:0];

}
//弹出通讯录列表
- (void) precentContactVC {
    ViewController * vc = [[ViewController alloc] init];
    UINavigationController *navi = [[UINavigationController alloc] initWithRootViewController:vc];
    [self presentViewController:navi animated:YES completion:nil];
}
//创建联系人
- (void) createContact {
    
    for (int i=0; i<[self contactString].count; i++) {
        
        // 1. 创建联系人实例
        CNMutableContact *contact = [[CNMutableContact alloc] init];
        //头像
        //contact.imageData = UIImagePNGRepresentation([UIImage imageNamed:imageName]);
        //姓名
        //contact.familyName = @"王";
        contact.givenName = [self contactString][i];//@"隔壁";
        //邮箱
        //CNLabeledValue *homeEmail = [CNLabeledValue labeledValueWithLabel:CNLabelHome value:email[0]];
        //CNLabeledValue *workEmail =[CNLabeledValue labeledValueWithLabel:CNLabelWork value:email[1]];
        //CNLabeledValue *otherEmail =[CNLabeledValue labeledValueWithLabel:CNLabelOther value:email[2]];
        //contact.emailAddresses = @[homeEmail,workEmail,otherEmail];
        //邮箱键值
        //家庭CNLabelHome   0
        //工作CNLabelWork   1
        //其他CNLabelOther  2
     
        //电话
        CNLabeledValue *iPhoneNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:@"010"]];
        CNLabeledValue *mobileNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:@"139"]];
        CNLabeledValue *mainNumber = [CNLabeledValue labeledValueWithLabel:CNLabelPhoneNumberiPhone value:[CNPhoneNumber phoneNumberWithStringValue:@"138"]];
        contact.phoneNumbers = @[iPhoneNumber,mobileNumber,mainNumber];
        
        //电话键值
        //CNLabelPhoneNumberiPhone  0
        //CNLabelPhoneNumberMobile  1
        //CNLabelPhoneNumberMain    2
        //CNLabelPhoneNumberHomeFax
        //CNLabelPhoneNumberWorkFax
        //CNLabelPhoneNumberOtherFax
        //CNLabelPhoneNumberPager
        
        /*
        //地址 可设键值 home:[0]
        CNMutablePostalAddress * homeAdress = [[CNMutablePostalAddress alloc]init];
        homeAdress.street = address[0][2];
        homeAdress.city = address[0][1];
        homeAdress.state = address[0][0]; //国家
        homeAdress.postalCode = address[0][3];
        contact.postalAddresses = @[[CNLabeledValue labeledValueWithLabel:CNLabelHome value:homeAdress]];
     
        //生日
        NSDateComponents * birthday = [[NSDateComponents  alloc]init];
        birthday.day = (long int)birthdayArray[2];
        birthday.month = (long)birthdayArray[1];
        birthday.year = (long)birthdayArray[0];
        contact.birthday=birthday;
         */
        
        // 2. 创建联系人请求
        CNSaveRequest * saveRequest = [[CNSaveRequest alloc]init];
        // 2.1 添加联系人
        [saveRequest addContact:contact toContainerWithIdentifier:nil];
        /*
        //更新一个联系人
        - (void)updateContact:(CNMutableContact *)contact;
        //删除一个联系人
        - (void)deleteContact:(CNMutableContact *)contact;
        //添加一组联系人
        - (void)addGroup:(CNMutableGroup *)group toContainerWithIdentifier:(nullable NSString *)identifier;
        //更新一组联系人
        - (void)updateGroup:(CNMutableGroup *)group;
        //删除一组联系人
        - (void)deleteGroup:(CNMutableGroup *)group;
        //向组中添加子组
        - (void)addSubgroup:(CNGroup *)subgroup toGroup:(CNGroup *)group NS_AVAILABLE(10_11, NA);
        //在组中删除子组
        - (void)removeSubgroup:(CNGroup *)subgroup fromGroup:(CNGroup *)group NS_AVAILABLE(10_11, NA);
        //向组中添加成员
        - (void)addMember:(CNContact *)contact toGroup:(CNGroup *)group;
        //向组中移除成员
        - (void)removeMember:(CNContact *)contact fromGroup:(CNGroup *)group;
        */
        
        // 2.保存
        CNContactStore * store = [[CNContactStore alloc]init];
        if([store executeSaveRequest:saveRequest error:nil]) {
            NSLog(@"添加成功");
        }
    }
}
//申请授权访问通讯录,0查询通讯录，1创建通讯录
- (void) reqAuthContact:(int )from {
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
                            if (from == 0) {
                                //查询通讯录列表
                                [self precentContactVC];
                            }else if(from == 1){
                                //创建联系人
                                [self createContact];
                            }
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
                NSLog(@"已授权");
                if (from == 0) {
                    //查询通讯录列表
                    [self precentContactVC];
                }else if(from == 1){
                    //创建联系人
                    [self createContact];
                }
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

- (NSArray *) contactString {
    NSMutableArray * array = [[NSMutableArray alloc] init];
    //add test data
    [array addObject:@"Steve Jobs"];
    [array addObject:@"Einstein"];
    [array addObject:@"John von Neumann"];
    [array addObject:@"Tim Cook"];
    [array addObject:@"汪淼"];
    [array addObject:@"史强"];
    [array addObject:@"丁仪"];
    [array addObject:@"常伟思"];
    [array addObject:@"杨冬"];
    [array addObject:@"魏成"];
    [array addObject:@"沙瑞山"];
    [array addObject:@"徐冰冰"];
    [array addObject:@"斯坦顿"];
    [array addObject:@"林云"];
    [array addObject:@"李瑶"];
    [array addObject:@"豆豆"];
    [array addObject:@"楠楠"];
    [array addObject:@"洋洋"];
    [array addObject:@"咪咪"];
    [array addObject:@"叶文洁"];
    [array addObject:@"杨卫宁"];
    [array addObject:@"雷志成"];
    [array addObject:@"叶文雪"];
    [array addObject:@"叶哲泰"];
    [array addObject:@"邵琳"];
    [array addObject:@"白沐霖"];
    [array addObject:@"程丽华"];
    [array addObject:@"红卫兵1"];
    [array addObject:@"红卫兵2"];
    [array addObject:@"红卫兵3"];
    [array addObject:@"红卫兵4"];
    [array addObject:@"阮雯"];
    [array addObject:@"马钢"];
    [array addObject:@"齐猎头"];
    [array addObject:@"大凤"];
    [array addObject:@"伊文斯"];
    [array addObject:@"潘寒"];
    [array addObject:@"申玉菲"];
    [array addObject:@"拉菲尔"];
    [array addObject:@"核弹女孩"];
    [array addObject:@"元首"];
    [array addObject:@"1379号监听员"];
    [array addObject:@"科学执政官"];
    [array addObject:@"军事执政官"];
    [array addObject:@"农业执政官"];
    [array addObject:@"工业执政官"];
    [array addObject:@"文教执政官"];
    [array addObject:@"罗辑"];
    [array addObject:@"庄颜"];
    [array addObject:@"弗雷德里克·泰勒"];
    [array addObject:@"曼努尔·雷迪亚兹"];
    [array addObject:@"比尔·希恩斯"];
    [array addObject:@"冯·诺依曼"];
    [array addObject:@"墨子"];
    [array addObject:@"山杉惠子"];
    [array addObject:@"萨伊"];
    [array addObject:@"伽尔宁"];
    [array addObject:@"坎特"];
    [array addObject:@"张翔"];
    [array addObject:@"井上宏一"];
    [array addObject:@"加尔诺夫"];
    [array addObject:@"本·乔纳森"];
    [array addObject:@"章北海"];
    [array addObject:@"吴岳"];
    [array addObject:@"斐兹罗将军"];
    [array addObject:@"雷德尔"];
    [array addObject:@"琼斯"];
    [array addObject:@"威尔逊"];
    [array addObject:@"凯瑟琳"];
    [array addObject:@"林格"];
    [array addObject:@"哈里斯"];
    [array addObject:@"艾伦"];
    [array addObject:@"麦克"];
    [array addObject:@"威廉·科兹莫"];
    [array addObject:@"褚岩"];
    [array addObject:@"东方延绪"];
    [array addObject:@"列文"];
    [array addObject:@"井上明"];
    [array addObject:@"蓝西"];
    [array addObject:@"赵鑫"];
    [array addObject:@"李维"];
    [array addObject:@"西子"];
    [array addObject:@"斯科特"];
    [array addObject:@"塞巴斯蒂安·史耐德"];
    [array addObject:@"鲍里斯·洛文斯基"];
    [array addObject:@"卡尔·乔伊娜"];
    [array addObject:@"白蓉"];
    [array addObject:@"张援朝"];
    [array addObject:@"张为明"];
    [array addObject:@"晓虹"];
    [array addObject:@"张延"];
    [array addObject:@"杨晋文"];
    [array addObject:@"苗福全"];
    [array addObject:@"史晓明"];
    [array addObject:@"熊文"];
    [array addObject:@"郭正明"];
    [array addObject:@"肯博士"];
    [array addObject:@"罗宾逊将军"];
    [array addObject:@"程心"];
    [array addObject:@"狄奥伦娜"];
    [array addObject:@"康斯坦丁十一世"];
    [array addObject:@"法扎兰"];
    [array addObject:@"云天明"];
    [array addObject:@"老李"];
    [array addObject:@"张医生"];
    [array addObject:@"胡文"];
    [array addObject:@"何博士"];
    [array addObject:@"托马斯·维德"];
    [array addObject:@"米哈伊尔·瓦季姆"];
    [array addObject:@"于维民"];
    [array addObject:@"柯曼琳"];
    [array addObject:@"乔依娜"];
    [array addObject:@"毕云峰"];
    [array addObject:@"曹彬"];
    [array addObject:@"安东诺夫"];
    [array addObject:@"A·J·霍普金斯"];
    [array addObject:@"艾AA"];
    [array addObject:@"智子"];
    [array addObject:@"关一帆"];
    [array addObject:@"约瑟夫·莫沃维奇"];
    [array addObject:@"韦斯特"];
    [array addObject:@"戴文"];
    [array addObject:@"伊万"];
    [array addObject:@"薇拉"];
    [array addObject:@"艾克"];
    [array addObject:@"刘晓明"];
    [array addObject:@"詹姆斯·亨特"];
    [array addObject:@"秋原玲子"];
    [array addObject:@"朴义君"];
    [array addObject:@"卓文"];
    [array addObject:@"弗雷斯"];
    [array addObject:@"深水王子"];
    [array addObject:@"露珠公主"];
    [array addObject:@"针眼画师"];
    [array addObject:@"空灵画师"];
    [array addObject:@"长帆"];
    [array addObject:@"巴勒莫"];
    [array addObject:@"杰森"];
    [array addObject:@"威纳尔"];
    [array addObject:@"阿历克塞·瓦西里"];
    [array addObject:@"歌者"];
    [array addObject:@"高way"];
    [array addObject:@"布莱尔"];
    [array addObject:@"白Ice"];
    return array;
}

@end
