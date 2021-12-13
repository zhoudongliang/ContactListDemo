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
    
    self.isSelectAll = YES;//默认为显示全选
    
    self.title = @"选择头像";
    
    UIColor *textColor = [UIColor darkTextColor];
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        textColor = [UIColor lightTextColor];
    }
    
    //左侧按钮
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(cancel)];

    //设置右侧按钮
    [self setRightButtonView:@"全选" text2:@"确定"];
    
    [self.navigationController.navigationBar setTintColor:textColor];//文字颜色
    
    //深色模式显示,后续需要增加模式改变的监听!!!
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        [self.navigationController.navigationBar setBarTintColor:[UIColor clearColor]];//背景颜色
    }else{
        [self.navigationController.navigationBar setBarTintColor:[UIColor whiteColor]];//背景颜色
    }
    
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.selectedDataArray = [[NSMutableArray alloc] init];
    
    [self loadData];
    
    [self createCollectionView];
    
}

- (void) loadData {
    NSArray * array = @[@"😁",@"🐴",@"💰",@"🏃🏻‍♀️",@"🪝",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🌲",@"😓",@"💰",@"🏃🏻‍♀️",@"🪝",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🌲",@"😓"];
    
    for (int i=0;i<array.count; i++) {
        EmojiModel *em = [[EmojiModel alloc] init];
        em.emojiImageString = array[i];
        em.emojiBtnTag = i;
        [self.dataArray addObject:em];
    }
}

//全选
- (void) selectAllContact {
    //只要是全选,或者全部取消权限,都得重置被选中的数据
    [self.selectedDataArray removeAllObjects];
    
    //NSArray *anArrayOfIndexPath = [NSArray arrayWithArray:[self.collectionView indexPathsForVisibleItems]];//这只是当前页
    
    for (int i = 0; i < self.dataArray.count; i++)
        {
            NSIndexPath * indexPath = [NSIndexPath indexPathForRow:i inSection:0];
            EmojiCollectionViewCell * cell = (EmojiCollectionViewCell*)[self.collectionView cellForItemAtIndexPath:indexPath];

            if (self.isSelectAll) {
                [cell setSelected:YES];
                //这里需要设置被选中的Item，否则处于“非选中”的Item是无法触发，shouleSelected 和 DeSelected 代理方法的，就是选中后，就无法取消选中了
                [self.collectionView selectItemAtIndexPath:indexPath animated:YES scrollPosition:UICollectionViewScrollPositionNone];
                //放到选中的数组里
                [self.selectedDataArray addObject:self.dataArray[i]];//取消的时候就不管了,因上面是先清空
                
            }else{
                [cell setSelected:NO];
                [self.collectionView deselectItemAtIndexPath:indexPath animated:YES];
                
            }
        }
    self.isSelectAll = !self.isSelectAll;//全选和取消全选
    if (self.isSelectAll) {
        //设置右侧按钮
        [self setRightButtonView:@"全选" text2:@"确定"];
    }else{
        //设置右侧按钮
        [self setRightButtonView:@"取消" text2:@"确定"];
    }
    /*
    NSLog(@"---------------------");
    for (int i=0; i<self.selectedDataArray.count; i++) {
        EmojiModel * em = self.selectedDataArray[i];
        NSLog(@"+++++%@",em.emojiImageString);
    }
    NSLog(@"---------------------");
    */
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

//右侧两个按钮,全选和确定
-(void) setRightButtonView:(NSString *)text1 text2:(NSString *)text2 {
    //适配深色模式
    UIColor *textColor = [UIColor darkTextColor];
    if (self.traitCollection.userInterfaceStyle == UIUserInterfaceStyleDark) {
        textColor = [UIColor lightTextColor];
    }
    //右侧按钮
    //右侧两个按钮,全选和确定
    UIView *rightButtonView = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 120, 50)];
    //全选按钮
    UIButton *selectAllBtn = [[UIButton alloc] initWithFrame:CGRectMake(6, 0, 75, 44)];
    [rightButtonView addSubview:selectAllBtn];
    [selectAllBtn setTitleColor:textColor forState:UIControlStateNormal];
    [selectAllBtn setTitle:text1 forState:UIControlStateNormal];
    [selectAllBtn setContentHorizontalAlignment:UIControlContentHorizontalAlignmentRight];
    [selectAllBtn addTarget:self action:@selector(selectAllContact) forControlEvents:UIControlEventTouchUpInside];

    //确定按钮
    UIButton *okBtn = [[UIButton alloc] initWithFrame:CGRectMake(70, 0, 75, 44)];
    [rightButtonView addSubview:okBtn];
    [okBtn setTitleColor:textColor forState:UIControlStateNormal];
    [okBtn setTitle:text2 forState:UIControlStateNormal];
    [okBtn addTarget:self action:@selector(goProcess) forControlEvents:UIControlEventTouchUpInside];

    //把右侧的两个按钮添加到rightBarButtonItem
    UIBarButtonItem *rightCunstomButtonView = [[UIBarButtonItem alloc] initWithCustomView:rightButtonView];
    self.navigationItem.rightBarButtonItem = rightCunstomButtonView;
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
    
    EmojiModel * em = self.dataArray[indexPath.item];//套娃第一层
    NSString * emojiImageString = em.emojiImageString;//套娃第二层
    UIImage * emojiImage = [self imageForText:emojiImageString bgColor:[UIColor systemGray5Color] canvasSize:60.0];//这个背景色后面要改成动态的
    [cell.emojiImageView setImage:emojiImage];
    cell.emojiImageView.layer.masksToBounds = YES;
    cell.emojiImageView.layer.cornerRadius = 28;//头像设置成圆形
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //NSLog(@"didSelectItemAtIndexPath");
    
}

//选中某项
- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    //放到选中的数组里
    if (indexPath.item < self.dataArray.count) {
        [self.selectedDataArray addObject:self.dataArray[indexPath.item]];//取消的时候就不管了,因上面是先清空
    }
    /*
    NSLog(@"---------------------");
    for (int i=0; i<self.selectedDataArray.count; i++) {
        EmojiModel * em = self.selectedDataArray[i];
        NSLog(@"+++++%@",em.emojiImageString);
    }
    NSLog(@"---------------------");
     */
    return YES;
}

//取消选中某项
- (BOOL)collectionView:(UICollectionView *)collectionView shouldDeselectItemAtIndexPath:(NSIndexPath *)indexPath {
    //从数组中删除选中的那个
    if (indexPath.item < self.dataArray.count) {
        EmojiModel * em = self.dataArray[indexPath.item];
        [self.selectedDataArray removeObject:em];
        
    }
    /*
    NSLog(@"---------------------");
    for (int i=0; i<self.selectedDataArray.count; i++) {
        EmojiModel * em = self.selectedDataArray[i];
        NSLog(@"-----%@",em.emojiImageString);
    }
    NSLog(@"---------------------");
    */
    return YES;
}

- (void)performBatchUpdates:(void (^ __nullable)(void))updates completion:(void (^ __nullable)(BOOL finished))completion {
    //NSLog(@"performBatchUpdates");
    
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

//文字(emoji)转图片
-(UIImage *)imageForText:(NSString *)text bgColor:(UIColor *) bgColor canvasSize:(CGFloat ) canvasSize {
    //CGFloat canvasSize = 60.0;
    
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
    CGContextSetFillColorWithColor(ctx, [bgColor CGColor]);//背景色
    CGContextFillRect(ctx, CGRectMake(0, 0, canvasSize,canvasSize));
    
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    
    //获取文字尺寸
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40]}];
    //让文字居中显示
    [text drawInRect:CGRectMake((canvasSize - textSize.width) / 2, (canvasSize - textSize.height) / 2, canvasSize,canvasSize) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40]}];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

@end
