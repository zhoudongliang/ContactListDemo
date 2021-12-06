//
//  ContactCell.h
//  ContactListDemo
//
//  Created by 周栋梁 on 2021/12/5.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface ContactCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIImageView *contactImg;
@property (weak, nonatomic) IBOutlet UILabel *contactName;

@end

NS_ASSUME_NONNULL_END
