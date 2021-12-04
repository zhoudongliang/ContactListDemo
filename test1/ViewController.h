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
@property (nonatomic, retain) NSMutableArray *dataArr;
@property (nonatomic, retain) NSMutableArray *sortedArrForArrays;
@property (nonatomic, retain) NSMutableArray *sectionHeadsKeys;



@end

