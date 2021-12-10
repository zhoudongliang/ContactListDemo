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
}


- (void)setSelected:(BOOL)selected
{
    [super setSelected:selected];
    
    //NSLog(@"aaa");
    
      if (selected) {
          NSLog(@"aa");
           self.layer.backgroundColor = [[UIColor redColor] CGColor];
      } else {
          NSLog(@"bb");
           self.layer.backgroundColor = [[UIColor blueColor] CGColor];
    }
}

@end
