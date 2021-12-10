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
@property (nonatomic,retain) NSMutableArray * dataArray;
@property (nonatomic,retain) NSMutableArray * btnArray;

@property (strong , nonatomic) NSIndexPath * m_lastAccessed;

@end

NS_ASSUME_NONNULL_END
