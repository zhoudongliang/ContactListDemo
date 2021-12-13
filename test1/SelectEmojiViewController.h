//
//  SelectEmojiViewController.h
//  ContactListDemo
//
//  Created by 周栋梁 on 2021/12/10.
//

#import "ViewController.h"

NS_ASSUME_NONNULL_BEGIN

@interface SelectEmojiViewController : UIViewController<UICollectionViewDelegate,UICollectionViewDataSource>

@property (nonatomic,retain) UICollectionView * collectionView;
@property (nonatomic,retain) NSMutableArray * dataArray;//所有数据
@property (nonatomic,retain) NSMutableArray * selectedDataArray;//被选中的数据

@property (nonatomic,assign) BOOL isSelectAll;//是全选还是取消全选

@end

NS_ASSUME_NONNULL_END
