//
//  ViewController.h
//  test1
//
//  Created by 周栋梁 on 2021/12/4.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <UITableViewDataSource, UITableViewDelegate> {
    
}

@property (nonatomic ,retain) UITableView *tableView;
@property (nonatomic, retain) NSMutableArray *dataArr;//所有数据
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;//以组为单位的数据
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;//分组的标题
@property (nonatomic, retain) NSMutableArray *selectedIndexArray;//被选中数据的索引


@end

