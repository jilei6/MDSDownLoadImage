//
//  MDSDownLoadImageOperation.m
//  MDSDownLoadImage
//
//  Created by jilei on 16/9/23.
//  Copyright © 2016年 冀磊. All rights reserved.
//

#import "MDSDownLoadImageOperation.h"
#import "MDSFileTool.h"
@implementation MDSDownLoadImageOperation
- (void)main   //重写main方法即可
{
    @autoreleasepool
    {    //在子线程中，并不会自动添加自动释放池，所以，手动添加，免得出现内存泄露的问题
        //NSString *STR=[NSString stringWithFormat:<#(nonnull NSString *), ...#>]stringByAddingPercentEscapesUsingEncoding
       self.url = [self.url stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLQueryAllowedCharacterSet]];
        NSURL *DownLoadUrl = [NSURL URLWithString:self.url];
        if (self.isCancelled) return;          //如果下载操作被取消，那么就无需下面操作了
//        NSData *data = [NSData dataWithContentsOfURL:DownLoadUrl];
        NSError *error = nil;
        NSData *data = [[NSData alloc]initWithContentsOfURL:DownLoadUrl options:NSUncachedRead error:&error];
        if (self.isCancelled) return;
        UIImage *image = [UIImage imageWithData:data];
        if (self.isCancelled) return;
        
        dispatch_async(dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0), ^{
            [MDSFileTool createFileName:self.url type:MDSFileToolTypeCache context:data]; //将数据缓存到本地
        });
        
        
        if ([self.delegate respondsToSelector:@selector(DownLoadImageOperation:didFinishDownLoadImage:)]) {
            dispatch_async(dispatch_get_main_queue(), ^{   //回到主线程，更新UI
                
                [self.delegate DownLoadImageOperation:self didFinishDownLoadImage:image];
            });
        }
    }
}
@end
