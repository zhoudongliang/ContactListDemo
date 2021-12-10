//
//  EmojiModel.m
//  ContactListDemo
//
//  Created by 周栋梁 on 2021/12/10.
//

#import "EmojiModel.h"

@implementation EmojiModel

- (instancetype)init {
    if (self = [super init]) {
        self.emojiString = @"";
        self.emojiImageString = @"";
        self.emojiBtnTag = 0;
    }
    return self;
}

@end
