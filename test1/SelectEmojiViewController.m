//
//  SelectEmojiViewController.m
//  ContactListDemo
//
//  Created by 周栋梁 on 2021/12/10.
//

#import "SelectEmojiViewController.h"
#import "EmojiModel.h"
#import "EmojiCollectionViewCell.h"

#define GH_SCREENWIDTH [UIScreen mainScreen].bounds.size.width
#define GH_SCREENHIGH  [UIScreen mainScreen].bounds.size.height
// 多少列
#define GH_BRANDSECTION 6
// 列表间隔距离
#define GH_BRANDDEV 8
// cell宽度
#define GH_LIST1CELLWIDTH (GH_SCREENWIDTH - (GH_BRANDSECTION + 1)*GH_BRANDDEV) / GH_BRANDSECTION

@interface SelectEmojiViewController ()

@end

@implementation SelectEmojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.title = @"选择头像";
    
    UIColor *textColor = [UIColor darkTextColor];
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        textColor = [UIColor lightTextColor];
    }
    
    //左侧按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];
    
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
    
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.btnArray = [[NSMutableArray alloc] init];
    
    
    [self loadData];
    
    [self createCollectionView];
    
}

- (void) loadData {
    NSArray * array = @[@"😁",@"🐴",@"💰",@"🏃🏻‍♀️",@"🪝",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🌲",@"😓",@"💰",@"🏃🏻‍♀️",@"🪝",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🌲",@"😓"];
    
    for (int i=0;i<array.count; i++) {
        EmojiModel *em = [[EmojiModel alloc] init];
        em.emojiImageString = array[i];
        em.emojiBtnTag = i;
        [self.dataArray addObject:em];
        NSString * btnStr = [NSString stringWithFormat:@"%ld",(long)i];
        [self.btnArray addObject:btnStr];
    }
}


//全选
- (void) selectAllContact {
    NSLog(@"全选");
    
    NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.collectionView indexPathsForVisibleItems]];
    
    for (int i = 0; i < 1; i++)
        {
            NSIndexPath *indexPath = [anArrayOfIndexPath objectAtIndex:i];
            EmojiCollectionViewCell * cell = (EmojiCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];

            //[cell setSelected:YES];
            
            [cell aa];
            
            [self collectionView:self.collectionView shouldSelectItemAtIndexPath:indexPath];
            
        }
   
}
//取消
- (void) cancel {
    [self dismissViewControllerAnimated:YES completion:nil];
}

//确定
- (void) goProcess {
    NSLog(@"确定");
    
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)createCollectionView {
    
    CGRect rect =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    //[layout setItemSize:CGSizeMake(100, 100)];//不用这个了
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];

    [self.collectionView registerNib:[UINib nibWithNibName:@"EmojiCollectionViewCell" bundle:[NSBundle mainBundle]] forCellWithReuseIdentifier:@"emojicell"];
    
    //创建collectionview时设置多选
    self.collectionView.allowsMultipleSelection = YES;
    
    
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    [self.view addSubview:self.collectionView];
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    
    EmojiCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojicell" forIndexPath:indexPath];
    
    //NSLog(@"cellForItemAtIndexPath");
    
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"didSelectItemAtIndexPath");
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"shouldDeselectItemAtIndexPath");
    
    return YES;
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    NSLog(@"shouldSelectItemAtIndexPath");
    return YES;
}

- (void)performBatchUpdates:(void (^ __nullable)(void))updates completion:(void (^ __nullable)(BOOL finished))completion {
    NSLog(@"performBatchUpdates");
    
}

// 定义每个Cell的大小
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(GH_LIST1CELLWIDTH, GH_LIST1CELLWIDTH);
}
 
// 定义每个Section的四边间距
- (UIEdgeInsets)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout insetForSectionAtIndex:(NSInteger)section {
    // UIEdgeInsets insets = {top, left, bottom, right};
    return UIEdgeInsetsMake(GH_BRANDDEV, GH_BRANDDEV, GH_BRANDDEV, GH_BRANDDEV);
}
 
// 两行cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section {
    return GH_BRANDDEV;
}
 
// 两列cell之间的间距
- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section {
    return GH_BRANDDEV;
}

//这里也可以设置每个cell的大小
/*
- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout*)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath {
    return CGSizeMake(110, 110);
}
*/
@end
