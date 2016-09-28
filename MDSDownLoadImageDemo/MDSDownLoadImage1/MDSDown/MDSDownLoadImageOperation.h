//
//  MDSDownLoadImageOperation.h
//  MDSDownLoadImage
//
//  Created by jilei on 16/9/23.
//  Copyright © 2016年 冀磊. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <UIKit/UIKit.h>
@class MDSDownLoadImageOperation;

@protocol MDSDownLoadImageOperationDelegate <NSObject>
@optional
- (void)DownLoadImageOperation:(MDSDownLoadImageOperation *)operation didFinishDownLoadImage:(UIImage *)image;
@end
@interface MDSDownLoadImageOperation : NSOperation
@property (nonatomic, weak) id<MDSDownLoadImageOperationDelegate> delegate;
@property (nonatomic, copy) NSString *url;
@property (nonatomic, strong) NSIndexPath *indexPath;
@end
