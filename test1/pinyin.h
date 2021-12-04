//
//  pinyin.h
//  test1
//
//  Created by 周栋梁 on 2021/12/4.
//

/*
 * // Example
 *
 * #import "pinyin.h"
 *
 * NSString *str = @"蒂姆库克";
 * for (int i = 0; i < [str length]; i++)
 * {
 *     printf("%c", pinyinFirstLetter([str characterAtIndex:i]));
 * }
 *
 */

#define ALPHA    @"ABCDEFGHIJKLMNOPQRSTUVWXYZ#"
char pinyinFirstLetter(unsigned short hanzi);
