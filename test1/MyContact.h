//
//  MyContact.h
//  test1
//
//  Created by 周栋梁 on 2021/12/4.
//

#import <Foundation/Foundation.h>
#import <Contacts/Contacts.h>

NS_ASSUME_NONNULL_BEGIN

@interface MyContact : NSObject

@property(nonatomic, copy)NSString *contactString;//联系人名称
@property(nonatomic, copy)NSString *contactPinYin;//联系人拼音
@property(nonatomic, copy)CNContact *contact;//整体联系人信息(可能只获取保存了部分)

@end


NS_ASSUME_NONNULL_END
