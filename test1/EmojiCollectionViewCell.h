//
//  EmojiCollectionViewCell.h
//  ContactListDemo
//
//  Created by 周栋梁 on 2021/12/10.
//

#import <UIKit/UIKit.h>

NS_ASSUME_NONNULL_BEGIN

@interface EmojiCollectionViewCell : UICollectionViewCell
@property (weak, nonatomic) IBOutlet UIImageView *emojiImageView;
@property (weak, nonatomic) IBOutlet UIImageView *selectImage;

-(void) aa;

@end

NS_ASSUME_NONNULL_END
