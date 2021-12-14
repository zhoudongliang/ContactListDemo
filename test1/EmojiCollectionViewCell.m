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

//直接设置图片
-(void) setImage:(UIImage *) image {
    dispatch_async(dispatch_get_main_queue(), ^{
        [self.emojiImageView setImage:image];
    });
}
//设置字符串，然后转图片
-(void) setImageSting:(NSString *) imageString {
    dispatch_async(dispatch_get_global_queue(0, 0), ^{
        //下面是耗时操作，异步执行
        UIColor * color = [UIColor clearColor];//默认是透明的
        //下面这些都是为了给图片加个背景色
        UIImage * tmpImage = [self imageForText:imageString bgColor:[UIColor clearColor] canvasSize:35.0];//35.0是为了让图片占画布的范围大一些，好去获取主色调
        color = [self mainColorOfImage:tmpImage];
        color = [color colorWithAlphaComponent:0.382];
        UIImage * emojiImage = [self imageForText:imageString bgColor:color canvasSize:60.0];//实际是60大小正好，也系统设置的差不多
        
        //执行完了后，回调通知主线程刷新UI
        dispatch_async(dispatch_get_main_queue(), ^{
            [self.emojiImageView setImage:emojiImage];
        });
    });
}

//文字(emoji)转图片
-(UIImage *)imageForText:(NSString *)text bgColor:(UIColor *) bgColor canvasSize:(CGFloat ) canvasSize {
    //CGFloat canvasSize = 60.0;
    
    CGSize size  = CGSizeMake(canvasSize,canvasSize);
    // check if UIGraphicsBeginImageContextWithOptions is available (iOS is 4.0+)
    if (&UIGraphicsBeginImageContextWithOptions != NULL){
        UIGraphicsBeginImageContextWithOptions(size,NO,0.0);
    }
    
    // optional: add a shadow, to avoid clipping the shadow you should make the context size bigger
    //
    // CGContextRef ctx = UIGraphicsGetCurrentContext();
    // CGContextSetShadowWithColor(ctx, CGSizeMake(1.0, 1.0), 5.0, [[UIColor grayColor] CGColor]);
    
    // draw in context, you can use also drawInRect:withFont:
    //[text drawAtPoint:CGPointMake(0.0, 40.0) withFont:font];
    CGContextRef ctx = UIGraphicsGetCurrentContext();
    CGContextSetFillColorWithColor(ctx, [bgColor CGColor]);//背景色
    CGContextFillRect(ctx, CGRectMake(0, 0, canvasSize,canvasSize));
    
    CGContextSetFillColorWithColor(ctx, [[UIColor blackColor] CGColor]);
    
    //获取文字尺寸
    CGSize textSize = [text sizeWithAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40]}];
    //让文字居中显示
    [text drawInRect:CGRectMake((canvasSize - textSize.width) / 2, (canvasSize - textSize.height) / 2, canvasSize,canvasSize) withAttributes:@{NSFontAttributeName:[UIFont systemFontOfSize:40]}];
    
    // transfer image
    UIImage *image = UIGraphicsGetImageFromCurrentImageContext();
    UIGraphicsEndImageContext();
    
    return image;
}

//由取图片主色，据说有性能问题？参考这个网址-> https://www.jianshu.com/p/ef663a07e5cc
-(UIColor *)mainColorOfImage:(UIImage *)image {
    int bitmapInfo = kCGBitmapByteOrderDefault | kCGImageAlphaPremultipliedLast;

    //第一步：先把图片缩小，加快计算速度，但越小结果误差可能越大
    CGSize thumbSize = CGSizeMake(16,16);
    CGColorSpaceRef colorSpace = CGColorSpaceCreateDeviceRGB();
    CGContextRef context = CGBitmapContextCreate(NULL,
                                                 thumbSize.width,
                                                 thumbSize.height,
                                                 8,//bits per component
                                                 thumbSize.width*4,
                                                 colorSpace,
                                                 bitmapInfo);
    CGRect drawRect = CGRectMake(0, 0, thumbSize.width, thumbSize.height);
   
    //NSImage 转 CGImageRef
    CGImageSourceRef source;
    source = CGImageSourceCreateWithData((CFDataRef)UIImagePNGRepresentation(image), NULL);
    CGImageRef maskRef =  CGImageSourceCreateImageAtIndex(source, 0, NULL);
    
    CGContextDrawImage(context, drawRect, maskRef);
    CGColorSpaceRelease(colorSpace);
    //第二步：取每个点的像素值
    unsigned char* data = CGBitmapContextGetData (context);
    if (data == NULL)return nil;
    NSCountedSet * cls = [NSCountedSet setWithCapacity:thumbSize.width*thumbSize.height];
    for (int x=0; x<thumbSize.width; x++) {
        for (int y=0; y<thumbSize.height; y++) {
            int offset = 4*(x*y);
            int red = data[offset];
            int green = data[offset+1];
            int blue = data[offset+2];
            int alpha = data[offset+3];
            NSArray *clr = @[@(red),@(green),@(blue),@(alpha)];
            if ((red+green+blue) > 0) {
                [cls addObject:clr];
            }
            
        }
    }
    CGContextRelease(context);
    //第三步：找到出现次数最多的那个颜色
    NSEnumerator *enumerator = [cls objectEnumerator];
    NSArray *curColor = nil;
    NSArray *MaxColor = nil;
    NSUInteger MaxCount = 0;
    while ( (curColor = [enumerator nextObject]) != nil ){
        NSUInteger tmpCount = [cls countForObject:curColor];
        if (tmpCount < MaxCount) continue;
         MaxCount=tmpCount;
         MaxColor=curColor;
    }
    return [UIColor colorWithRed:([MaxColor[0] intValue]/255.0f)
                           green:([MaxColor[1] intValue]/255.0f)
                            blue:([MaxColor[2] intValue]/255.0f)
                           alpha:([MaxColor[3] intValue]/255.0f)];

}

@end
