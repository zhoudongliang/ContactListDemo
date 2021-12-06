//
//  ViewController.m
//  test1
//
//  Created by 周栋梁 on 2021/12/4.
//

#import "ViewController.h"
#import "pinyin.h"
#import "ChineseString.h"
#import "ContactCell.h"
#import <Contacts/Contacts.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择联系人";
    
    UIColor *textColor = [UIColor darkTextColor];
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        textColor = [UIColor lightTextColor];
    }
    
    //左侧按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithBarButtonSystemItem:UIBarButtonSystemItemCancel target:self action:@selector(cancel)];
    
    //右侧按钮
    //右侧两个按钮,全选和确定
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];

    //全选按钮
    UIButton *selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 0, 75, 44)];
    [rightButtonView addSubview:selectAllBtn];
    [selectAllBtn setTitleColor:textColor forState:UIControlStateNormal];
    [selectAllBtn setTitle:@"Select All" forState:UIControlStateNormal];
    [selectAllBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [selectAllBtn addTarget:self action:@selector(selectAllContact) forControlEvents:UIControlEventTouchUpInside];

    //确定按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 75, 44)];
    [rightButtonView addSubview:okBtn];
    [okBtn setTitleColor:textColor forState:UIControlStateNormal];
    [okBtn setTitle:@"确定" forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(goProces) forControlEvents:UIControlEventTouchUpInside];

    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
    
    [self.navigationController.navigationBar setTintColor:textColor];//文字颜色
    
    //深色模式显示,后续需要增加模式改变的监听!!!
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];//背景颜色
    }else{
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];//背景颜色
    }
    
    //申请授权访问通讯录
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    CNContactStore * store = [[CNContactStore alloc] init];
    switch (status) {
        case CNAuthorizationStatusNotDetermined://用户还没决定授权
            {
                [store requestAccessForEntityType:CNEntityTypeContacts completionHandler:^(BOOL granted,NSError * _Nullable error){
                    
                    if (granted) {
                        NSLog(@"授权成功");
                        //初始化数据
                        
                        
                        
                    }else{
                        NSLog(@"授权失败");
                        [self alertReTry];
                        
                    }
                    
                }];
            }
            break;
        case CNAuthorizationStatusRestricted://当前手机用户,无权授权
            {
                //给用户提示:您没被授权开放通讯录权限,请联系机主
            }
            break;
        case CNAuthorizationStatusDenied://明确拒绝了访问通讯录
            {
                NSLog(@"没有权限");
                //给用户提示:我们现在无权访问您的通讯录,这将无法继续  取消,再次一次
                
                
            }
            break;
        case CNAuthorizationStatusAuthorized://已经同意方案通讯录
            {
                //初始化数据
                
                
                
            }
            break;
        default:
            break;
    }
    
    
    NSLog(@"初始化列表");
    [self initData];
    [self createTableView];
}

//给用户提示:授权失败,这将无法继续  取消,再次一次
- (void) alertReTry {

    // 初始化对话框
    UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"提示"
                                                                   message:@"授权失败,这将无法继续."
                                                            preferredStyle:UIAlertControllerStyleAlert];
    // 确定注销
    UIAlertAction *reTry = [UIAlertAction actionWithTitle:@"再试一次"
                                                    style:UIAlertActionStyleDefault
                                                  handler:^(UIAlertAction *_Nonnull action) {
        //再试一次
        
        
    }];
    UIAlertAction *cancel = [UIAlertAction actionWithTitle:@"取消"
                                                     style:UIAlertActionStyleCancel
                                                   handler:nil];

    [alert addAction:reTry];
    [alert addAction:cancel];
    // 弹出对话框
    [self presentViewController:alert animated:true completion:nil];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.editing = YES;//进入编辑状态
    self.tableView.allowsMultipleSelectionDuringEditing = YES;//允许多选
    
    [self.view addSubview:self.tableView];
}

//确定
- (void) goProces {
    NSLog(@"确定");
    NSArray<NSIndexPath *> *selectedContacts = self.tableView.indexPathsForSelectedRows;
    
    for(int i=0;i<selectedContacts.count;i++) {
        //从分组数组中，获取某组section的某行row数据
        NSArray * section = self.sortedArrForArrays[selectedContacts[i].section];
        ChineseString * contact = section[selectedContacts[i].row];
        
        NSLog(@"%@",contact.string);//这里需要加上数组越界的判断
    }
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}
//全选
- (void) selectAllContact {
    NSLog(@"全选");
    for (int i=0; i<self.sortedArrForArrays.count; i++) {//循环组
        for (int j = 0; j<[[self.sortedArrForArrays objectAtIndex:i] count]; j++) {//循环每组的行
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:j inSection:i];
            [self.tableView selectRowAtIndexPath:indexPath animated:YES scrollPosition:UITableViewScrollPositionNone];//设置选中状态
        }
    }
    
}
//取消
- (void) cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark 列表的相关方法
//每组有几行
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [[self.sortedArrForArrays objectAtIndex:section] count];
}
//一共有多少组
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedArrForArrays count];
}
//组名称
- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionHeadsKeys objectAtIndex:section];
}
//组内容数组
- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionHeadsKeys;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"CellId";
    ContactCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        //cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
        cell = [[NSBundle mainBundle] loadNibNamed:@"ContactCell" owner:nil options:nil].firstObject;
        //设置选中后的样式,(无样式，哈哈哈哈，不然加个灰色背景，不好看)
        cell.selectedBackgroundView = [[UIView alloc] init];
        
    }
    
    if ([self.sortedArrForArrays count] > indexPath.section) {
        NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            cell.contactName.text = str.string;
            [cell.contactImg setImage:[UIImage systemImageNamed:@"lasso"]];
        } else {
            NSLog(@"数组越界");
        }
    } else {
        NSLog(@"分组数组越界");
    }
    
    //cell.accessoryType = UITableViewCellAccessoryCheckmark;//👉🏻右边打对勾✅
    
    return cell;
}

//cell的高度，不设置会有警告
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 44;
}
//选中时的回调
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{

}

//对数组重新提取（拼音）首字母和重新分组，返回已分组好的数据，arrays里面有array，array存储具体行，arrays存储分组
- (NSMutableArray *)getChineseStringArr:(NSMutableArray *)arrToSort {
    NSMutableArray *chineseStringsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        ChineseString *chineseString = [[ChineseString alloc]init];
        chineseString.string = [NSString stringWithString:[arrToSort objectAtIndex:i]];
        
        if(chineseString.string == nil){
            chineseString.string = @"";
        }
        
        if(![chineseString.string isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < chineseString.string.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([chineseString.string characterAtIndex:j])]uppercaseString];
                
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            chineseString.pinYin = pinYinResult;
        } else {
            chineseString.pinYin = @"";
        }
        [chineseStringsArray addObject:chineseString];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"pinYin" ascending:YES]];
    [chineseStringsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;

    for(int index = 0; index < [chineseStringsArray count]; index++)
    {
        ChineseString *chineseStr = (ChineseString *)[chineseStringsArray objectAtIndex:index];
        NSMutableString *strchar= [NSMutableString stringWithString:chineseStr.pinYin];
        NSString *sr= [strchar substringToIndex:1];
        //NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![self.sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [self.sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] init];
            checkValueAtIndex = NO;
        }
        if([self.sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
           [TempArrForGrouping addObject:[chineseStringsArray objectAtIndex:index]];
            if(checkValueAtIndex == NO)
            {
                [arrayForArrays addObject:TempArrForGrouping];
                checkValueAtIndex = YES;
            }
        }
    }
    return arrayForArrays;
}

- (void)initData {
    //init
    self.dataArr = [[NSMutableArray alloc] init];
    self.sortedArrForArrays = [[NSMutableArray alloc] init];
    self.sectionHeadsKeys = [[NSMutableArray alloc] init];
    
    //add test data
    [self.dataArr addObject:@"Steve Jobs"];
    [self.dataArr addObject:@"Einstein"];
    [self.dataArr addObject:@"John von Neumann"];
    [self.dataArr addObject:@"Tim Cook"];
    [self.dataArr addObject:@"汪淼"];
    [self.dataArr addObject:@"史强"];
    [self.dataArr addObject:@"丁仪"];
    [self.dataArr addObject:@"常伟思"];
    [self.dataArr addObject:@"杨冬"];
    [self.dataArr addObject:@"魏成"];
    [self.dataArr addObject:@"沙瑞山"];
    [self.dataArr addObject:@"徐冰冰"];
    [self.dataArr addObject:@"斯坦顿"];
    [self.dataArr addObject:@"林云"];
    [self.dataArr addObject:@"李瑶"];
    [self.dataArr addObject:@"豆豆"];
    [self.dataArr addObject:@"楠楠"];
    [self.dataArr addObject:@"洋洋"];
    [self.dataArr addObject:@"咪咪"];
    [self.dataArr addObject:@"叶文洁"];
    [self.dataArr addObject:@"杨卫宁"];
    [self.dataArr addObject:@"雷志成"];
    [self.dataArr addObject:@"叶文雪"];
    [self.dataArr addObject:@"叶哲泰"];
    [self.dataArr addObject:@"邵琳"];
    [self.dataArr addObject:@"白沐霖"];
    [self.dataArr addObject:@"程丽华"];
    [self.dataArr addObject:@"红卫兵1"];
    [self.dataArr addObject:@"红卫兵2"];
    [self.dataArr addObject:@"红卫兵3"];
    [self.dataArr addObject:@"红卫兵4"];
    [self.dataArr addObject:@"阮雯"];
    [self.dataArr addObject:@"马钢"];
    [self.dataArr addObject:@"齐猎头"];
    [self.dataArr addObject:@"大凤"];
    [self.dataArr addObject:@"伊文斯"];
    [self.dataArr addObject:@"潘寒"];
    [self.dataArr addObject:@"申玉菲"];
    [self.dataArr addObject:@"拉菲尔"];
    [self.dataArr addObject:@"核弹女孩"];
    [self.dataArr addObject:@"元首"];
    [self.dataArr addObject:@"1379号监听员"];
    [self.dataArr addObject:@"科学执政官"];
    [self.dataArr addObject:@"军事执政官"];
    [self.dataArr addObject:@"农业执政官"];
    [self.dataArr addObject:@"工业执政官"];
    [self.dataArr addObject:@"文教执政官"];
    [self.dataArr addObject:@"罗辑"];
    [self.dataArr addObject:@"庄颜"];
    [self.dataArr addObject:@"弗雷德里克·泰勒"];
    [self.dataArr addObject:@"曼努尔·雷迪亚兹"];
    [self.dataArr addObject:@"比尔·希恩斯"];
    [self.dataArr addObject:@"冯·诺依曼"];
    [self.dataArr addObject:@"墨子"];
    [self.dataArr addObject:@"山杉惠子"];
    [self.dataArr addObject:@"政府人员"];
    [self.dataArr addObject:@"萨伊"];
    [self.dataArr addObject:@"伽尔宁"];
    [self.dataArr addObject:@"坎特"];
    [self.dataArr addObject:@"张翔"];
    [self.dataArr addObject:@"井上宏一"];
    [self.dataArr addObject:@"加尔诺夫"];
    [self.dataArr addObject:@"本·乔纳森"];
    [self.dataArr addObject:@"章北海"];
    [self.dataArr addObject:@"吴岳"];
    [self.dataArr addObject:@"斐兹罗将军"];
    [self.dataArr addObject:@"雷德尔"];
    [self.dataArr addObject:@"琼斯"];
    [self.dataArr addObject:@"威尔逊"];
    [self.dataArr addObject:@"凯瑟琳"];
    [self.dataArr addObject:@"林格"];
    [self.dataArr addObject:@"哈里斯"];
    [self.dataArr addObject:@"艾伦"];
    [self.dataArr addObject:@"麦克"];
    [self.dataArr addObject:@"威廉·科兹莫"];
    [self.dataArr addObject:@"褚岩"];
    [self.dataArr addObject:@"东方延绪"];
    [self.dataArr addObject:@"列文"];
    [self.dataArr addObject:@"井上明"];
    [self.dataArr addObject:@"蓝西"];
    [self.dataArr addObject:@"赵鑫"];
    [self.dataArr addObject:@"李维"];
    [self.dataArr addObject:@"西子"];
    [self.dataArr addObject:@"斯科特"];
    [self.dataArr addObject:@"塞巴斯蒂安·史耐德"];
    [self.dataArr addObject:@"鲍里斯·洛文斯基"];
    [self.dataArr addObject:@"卡尔·乔伊娜"];
    [self.dataArr addObject:@"白蓉"];
    [self.dataArr addObject:@"张援朝"];
    [self.dataArr addObject:@"张为明"];
    [self.dataArr addObject:@"晓虹"];
    [self.dataArr addObject:@"张延"];
    [self.dataArr addObject:@"杨晋文"];
    [self.dataArr addObject:@"苗福全"];
    [self.dataArr addObject:@"史晓明"];
    [self.dataArr addObject:@"熊文"];
    [self.dataArr addObject:@"郭正明"];
    [self.dataArr addObject:@"肯博士"];
    [self.dataArr addObject:@"罗宾逊将军"];
    [self.dataArr addObject:@"程心"];
    [self.dataArr addObject:@"狄奥伦娜"];
    [self.dataArr addObject:@"康斯坦丁十一世"];
    [self.dataArr addObject:@"法扎兰"];
    [self.dataArr addObject:@"云天明"];
    [self.dataArr addObject:@"老李"];
    [self.dataArr addObject:@"张医生"];
    [self.dataArr addObject:@"胡文"];
    [self.dataArr addObject:@"何博士"];
    [self.dataArr addObject:@"托马斯·维德"];
    [self.dataArr addObject:@"米哈伊尔·瓦季姆"];
    [self.dataArr addObject:@"于维民"];
    [self.dataArr addObject:@"柯曼琳"];
    [self.dataArr addObject:@"乔依娜"];
    [self.dataArr addObject:@"毕云峰"];
    [self.dataArr addObject:@"曹彬"];
    [self.dataArr addObject:@"安东诺夫"];
    [self.dataArr addObject:@"A·J·霍普金斯"];
    [self.dataArr addObject:@"艾AA"];
    [self.dataArr addObject:@"智子"];
    [self.dataArr addObject:@"关一帆"];
    [self.dataArr addObject:@"约瑟夫·莫沃维奇"];
    [self.dataArr addObject:@"韦斯特"];
    [self.dataArr addObject:@"戴文"];
    [self.dataArr addObject:@"伊万"];
    [self.dataArr addObject:@"薇拉"];
    [self.dataArr addObject:@"艾克"];
    [self.dataArr addObject:@"刘晓明"];
    [self.dataArr addObject:@"詹姆斯·亨特"];
    [self.dataArr addObject:@"秋原玲子"];
    [self.dataArr addObject:@"朴义君"];
    [self.dataArr addObject:@"卓文"];
    [self.dataArr addObject:@"弗雷斯"];
    [self.dataArr addObject:@"深水王子"];
    [self.dataArr addObject:@"露珠公主"];
    [self.dataArr addObject:@"针眼画师"];
    [self.dataArr addObject:@"空灵画师"];
    [self.dataArr addObject:@"长帆"];
    [self.dataArr addObject:@"巴勒莫"];
    [self.dataArr addObject:@"杰森"];
    [self.dataArr addObject:@"威纳尔"];
    [self.dataArr addObject:@"阿历克塞·瓦西里"];
    [self.dataArr addObject:@"歌者"];
    [self.dataArr addObject:@"高way"];
    [self.dataArr addObject:@"布莱尔"];
    [self.dataArr addObject:@"白Ice"];

    
    self.sortedArrForArrays = [self getChineseStringArr:self.dataArr];
}


@end
