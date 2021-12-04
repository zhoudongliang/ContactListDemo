//
//  ViewController.m
//  test1
//
//  Created by 周栋梁 on 2021/12/4.
//

#import "ViewController.h"
#import "pinyin.h"
#import "ChineseString.h"

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    
    [self initData];
    [self createTableView];
}

#pragma mark create method

- (void)initData {
    //init
    self.dataArr = [[NSMutableArray alloc] init];
    self.sortedArrForArrays = [[NSMutableArray alloc] init];
    self.sectionHeadsKeys = [[NSMutableArray alloc] init];
    
    //add test data
    [self.dataArr addObject:@"郭靖"];
    [self.dataArr addObject:@"黄蓉"];
    [self.dataArr addObject:@"杨过"];
    [self.dataArr addObject:@"苗若兰"];
    [self.dataArr addObject:@"令狐冲"];
    [self.dataArr addObject:@"小龙女"];
    [self.dataArr addObject:@"胡斐"];
    [self.dataArr addObject:@"水笙"];
    [self.dataArr addObject:@"任盈盈"];
    [self.dataArr addObject:@"白琇"];
    [self.dataArr addObject:@"狄云"];
    [self.dataArr addObject:@"石破天"];
    [self.dataArr addObject:@"殷素素"];
    [self.dataArr addObject:@"张翠山"];
    [self.dataArr addObject:@"张无忌"];
    [self.dataArr addObject:@"青青"];
    [self.dataArr addObject:@"袁冠南"];
    [self.dataArr addObject:@"萧中慧"];
    [self.dataArr addObject:@"袁承志"];
    [self.dataArr addObject:@"乔峰"];
    [self.dataArr addObject:@"王语嫣"];
    [self.dataArr addObject:@"段玉"];
    [self.dataArr addObject:@"虚竹"];
    [self.dataArr addObject:@"苏星河"];
    [self.dataArr addObject:@"丁春秋"];
    [self.dataArr addObject:@"庄聚贤"];
    [self.dataArr addObject:@"azi"];
    [self.dataArr addObject:@"阿朱"];
    [self.dataArr addObject:@"阿碧"];
    [self.dataArr addObject:@"鸠魔智"];
    [self.dataArr addObject:@"萧远山"];
    [self.dataArr addObject:@"慕容复"];
    [self.dataArr addObject:@"慕容博"];
    [self.dataArr addObject:@"Jim"];
    [self.dataArr addObject:@"Lily"];
    [self.dataArr addObject:@"Ethan"];
    [self.dataArr addObject:@"Green小"];
    [self.dataArr addObject:@"Green大"];
    [self.dataArr addObject:@"DavidSmall"];
    [self.dataArr addObject:@"DavidBig"];
    [self.dataArr addObject:@"James"];
    [self.dataArr addObject:@"Kobe Brand"];
    [self.dataArr addObject:@"Kobe Crand"];
    
    self.sortedArrForArrays = [self getChineseStringArr:self.dataArr];
}

- (void)createTableView {
    self.tableView = [[UITableView alloc] initWithFrame:self.view.frame style:UITableViewStylePlain];
    
    self.tableView.dataSource = self;
    self.tableView.delegate = self;
    
    [self.view addSubview:self.tableView];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return  [[self.sortedArrForArrays objectAtIndex:section] count];
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return [self.sortedArrForArrays count];
}

- (NSString *)tableView:(UITableView *)tableView titleForHeaderInSection:(NSInteger)section
{
    return [self.sectionHeadsKeys objectAtIndex:section];
}

- (NSArray *)sectionIndexTitlesForTableView:(UITableView *)tableView {
    return self.sectionHeadsKeys;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSString *cellId = @"CellId";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellId];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellId];
    }
    if ([self.sortedArrForArrays count] > indexPath.section) {
        NSArray *arr = [self.sortedArrForArrays objectAtIndex:indexPath.section];
        if ([arr count] > indexPath.row) {
            ChineseString *str = (ChineseString *) [arr objectAtIndex:indexPath.row];
            cell.textLabel.text = str.string;
        } else {
            NSLog(@"arr out of range");
        }
    } else {
        NSLog(@"sortedArrForArrays out of range");
    }
        
    return cell;
}


//对数组重新提取首字母和重新分组 返回已分组好的数据
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
        NSLog(@"%@",sr);        //sr containing here the first character of each string
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


@end
