//
//  EmojiCollectionViewCell.m
//  ContactListDemo
//
//  Created by 周栋梁 on 2021/12/10.
//

#import "EmojiCollectionViewCell.h"

@implementation EmojiCollectionViewCell

- (void)awakeFromNib {
    [super awakeFromNib];
    // Initialization code
    [self.selectImage setHidden:YES];
}

- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    if (selected) {
        [self.selectImage setHidden:NO];
    } else {
        [self.selectImage setHidden:YES];
        
    }
}

@end
