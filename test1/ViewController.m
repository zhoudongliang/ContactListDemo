//
//  ViewController.m
//  test1
//
//  Created by 周栋梁 on 2021/12/4.
//

#import "ViewController.h"
#import "pinyin.h"
#import "MyContact.h"
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
    [okBtn addTarget:self action:@selector(goProcess) forControlEvents:UIControlEventTouchUpInside];

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
    
    //初始化数据
    NSLog(@"初始化列表");
    [self initData];
    [self createTableView];

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

- (void)createTableView {
    
    CGRect rect =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
    self.tableView = [[UITableView alloc] initWithFrame:rect style:UITableViewStylePlain];
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    self.tableView.editing = YES;//进入编辑状态
    self.tableView.allowsMultipleSelectionDuringEditing = YES;//允许多选
    
    [self.view addSubview:self.tableView];
}

//确定
- (void) goProcess {
    NSLog(@"确定");
    NSArray<NSIndexPath *> *selectedContacts = self.tableView.indexPathsForSelectedRows;
    
    for(int i=0;i<selectedContacts.count;i++) {
        //从分组数组中，获取某组section的某行row数据
        NSArray * section = self.sortedArrForArrays[selectedContacts[i].section];
        MyContact * contact = section[selectedContacts[i].row];
        
        NSLog(@"%@",contact.contactString);//这里需要加上数组越界的判断
    }
    
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
            
            MyContact *contact = (MyContact *)[arr objectAtIndex:indexPath.row];
            cell.contactName.text = contact.contactString;
            cell.contactImg.layer.masksToBounds = YES;
            cell.contactImg.layer.cornerRadius = cell.contactImg.frame.size.width/2;//头像设置成圆形
            if (contact.contact.thumbnailImageData != nil) {
                [cell.contactImg setImage:[UIImage imageWithData:contact.contact.thumbnailImageData]];
            }else{
                //设置成以首字母为图片的头像
                if (contact.contactString.length > 0) {
                    //NSLog(@"%@",[contact.contactString substringToIndex:1]);
                    
                    UIImage * img = [self imageForText:[contact.contactString substringToIndex:1]];
                    [cell.contactImg setBackgroundColor:[UIColor systemGray5Color]];
                    [cell.contactImg setImage:img];
                }
            }
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
    NSMutableArray *myContactsArray = [NSMutableArray array];
    for(int i = 0; i < [arrToSort count]; i++) {
        MyContact *myContact = [[MyContact alloc] init];
        CNContact *contact = [arrToSort objectAtIndex:i];
        //添加联系人到局部联系人实例中
        myContact.contact = contact;
        
        //如果是英文名,中间加个空格
        NSString * familyName = contact.familyName;
        if (contact.familyName.length > 0) {
            unichar c = [contact.familyName characterAtIndex:contact.familyName.length-1];
            if (isalpha(c) || ispunct(c)) {//如果说是英文字符或相关符号
                familyName = [NSString stringWithFormat:@"%@%@",contact.familyName,@" "];
            }
        }
        
        myContact.contactString = [NSString stringWithFormat:@"%@%@",familyName,contact.givenName];
        
        if(myContact.contactString == nil){
            myContact.contactString = @"";
        }
        
        if(![myContact.contactString isEqualToString:@""]){
            //join the pinYin
            NSString *pinYinResult = [NSString string];
            for(int j = 0;j < myContact.contactString.length; j++) {
                NSString *singlePinyinLetter = [[NSString stringWithFormat:@"%c",
                                                 pinyinFirstLetter([myContact.contactString characterAtIndex:j])] uppercaseString];
                pinYinResult = [pinYinResult stringByAppendingString:singlePinyinLetter];
            }
            myContact.contactPinYin = pinYinResult;
        } else {
            myContact.contactPinYin = @"";
        }
        
        [myContactsArray addObject:myContact];
    }
    
    //sort the ChineseStringArr by pinYin
    NSArray *sortDescriptors = [NSArray arrayWithObject:[NSSortDescriptor sortDescriptorWithKey:@"contactPinYin" ascending:YES]];
    [myContactsArray sortUsingDescriptors:sortDescriptors];
    
    NSMutableArray *arrayForArrays = [NSMutableArray array];
    BOOL checkValueAtIndex= NO;  //flag to check
    NSMutableArray *TempArrForGrouping = nil;

    for(int index = 0; index < [myContactsArray count]; index++)
    {
        MyContact *contact = (MyContact *)[myContactsArray objectAtIndex:index];
        NSMutableString *strchar = [NSMutableString stringWithString:contact.contactPinYin];
        NSString *sr = [strchar substringToIndex:1];
        //NSLog(@"%@",sr);        //sr containing here the first character of each string
        if(![self.sectionHeadsKeys containsObject:[sr uppercaseString]])//here I'm checking whether the character already in the selection header keys or not
        {
            [self.sectionHeadsKeys addObject:[sr uppercaseString]];
            TempArrForGrouping = [[NSMutableArray alloc] init];
            checkValueAtIndex = NO;
        }
        if([self.sectionHeadsKeys containsObject:[sr uppercaseString]])
        {
           [TempArrForGrouping addObject:[myContactsArray objectAtIndex:index]];
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
    
    // 初始化数组
    self.dataArr = [[NSMutableArray alloc] init];
    self.sortedArrForArrays = [[NSMutableArray alloc] init];
    self.sectionHeadsKeys = [[NSMutableArray alloc] init];
    
    // ---  下面是获取通讯录联系人信息  ---
    // 1.获取授权状态
    CNAuthorizationStatus status = [CNContactStore authorizationStatusForEntityType:CNEntityTypeContacts];
    // 2.判断授权状态,如果不是已经授权,则直接返回
    if (status != CNAuthorizationStatusAuthorized) return;
    // 3.创建通信录对象
    CNContactStore *contactStore = [[CNContactStore alloc] init];
    // 4.创建获取通信录的请求对象
    // 4.1.拿到所有打算获取的属性对应的key
    NSArray *keys = @[CNContactIdentifierKey,//唯一标识
                      CNContactGivenNameKey,//名字
                      CNContactFamilyNameKey,//姓氏
                      CNContactImageDataKey,//头像图片
                      CNContactThumbnailImageDataKey,//缩略图
                      CNContactImageDataAvailableKey];//是否有头像标识
    // 4.2.创建CNContactFetchRequest对象
    CNContactFetchRequest *request = [[CNContactFetchRequest alloc] initWithKeysToFetch:keys];
    // 5.遍历所有的联系人
    [contactStore enumerateContactsWithFetchRequest:request error:nil usingBlock:^(CNContact * _Nonnull contact, BOOL * _Nonnull stop) {
        //获取联系人信息
        /*
         NSString *contactId = contact.identifier;
         NSString *lastname = contact.familyName;
         NSString *firstname = contact.givenName;
         NSData *imageDate = contact.imageData;
         NSData *thumImageDate = contact.thumbnailImageData;
         BOOL imgageAvailable = contact.imageDataAvailable;
        
         UIImage * img1 = [UIImage imageWithData:imageDate];
         UIImage * img2 = [UIImage imageWithData:thumImageDate];
         */
        
        //将通讯录保存到数据
        [self.dataArr addObject:contact];
        
    }];
    
    self.sortedArrForArrays = [self getChineseStringArr:self.dataArr];
}

//文字（emoji）转图片
-(UIImage *)imageForText:(NSString *)text {
    
    CGFloat canvasSize = 30.0;
    
    CGSize size  = CGSizeMake(canvasSize,canvasSize);
    // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (&UIGraphicsBeginImageContextWithOptions != NULL){
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    }
    
    // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger
    //
    // CGContextRef ctx = UIGraphicsGetCurrentContext();
    // CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
    
    // draw in context, you can use also drawInRect:withFont:
    //[text drawAtPoint:CGPointMake(0.0, 40.0) withFont:font];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [[UIColor clearColor] CGColor]);//背景色
    CGContextFillRect(ctx, CGRectMake(0, 0, canvasSize,canvasSize));
    
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    
    //获取文字尺寸
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    //让文字居中显示
    [text drawInRect:CGRectMake((canvasSize - textSize.width) / 2, (canvasSize - textSize.height) / 2, canvasSize,canvasSize) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:16]}];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
