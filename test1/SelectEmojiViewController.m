//
//  SelectEmojiViewController.m
//  ContactListDemo
//
//  Created by 周栋梁 on 2021/12/10.
//

#import "SelectEmojiViewController.h"
#import "EmojiModel.h"
#import "EmojiCollectionViewCell.h"

@interface SelectEmojiViewController ()

@end

@implementation SelectEmojiViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.dataArray = [[NSMutableArray alloc] init];
    self.btnArray = [[NSMutableArray alloc] init];
    
    
    [self loadData];
    
    [self createCollectionView];
    
}

- (void) loadData {
    NSArray * array = @[@"😁",@"🐴",@"💰",@"🏃🏻‍♀️",@"🪝",@"🎂",@"👁",@"😍",@"😭",@"😎",@"📚",@"🌲",@"😓"];
    
    for (int i=0;i<array.count; i++) {
        EmojiModel *em = [[EmojiModel alloc] init];
        em.emojiImageString = array[i];
        em.emojiBtnTag = i;
        [self.dataArray addObject:em];
        NSString * btnStr = [NSString stringWithFormat:@"%ld",(long)i];
        [self.btnArray addObject:btnStr];
    }
}

- (void)createCollectionView {
    
    CGRect rect =  CGRectMake(0, 0, self.view.frame.size.width, self.view.frame.size.height - 44);
    
    UICollectionViewFlowLayout * layout = [[UICollectionViewFlowLayout alloc] init];
    self.collectionView = [[UICollectionView alloc] initWithFrame:rect collectionViewLayout:layout];
    
    [self.collectionView registerClass:[EmojiCollectionViewCell class] forCellWithReuseIdentifier:@"emojicell"];
    [self.collectionView setDelegate:self];
    [self.collectionView setDataSource:self];
    
    [self.view addSubview:self.collectionView];
    
    
    
}

- (NSInteger)collectionView:(nonnull UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section {
    
    return self.dataArray.count;
}

- (__kindof UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath {
    EmojiCollectionViewCell * cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"emojicell" forIndexPath:indexPath];
    
    return cell;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
}

- (BOOL)collectionView:(UICollectionView *)collectionView shouldSelectItemAtIndexPath:(NSIndexPath *)indexPath {
    
    return YES;
}

@end
