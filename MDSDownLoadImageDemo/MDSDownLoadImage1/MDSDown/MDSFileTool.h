//
//  MDSFileTool.h
//  MDSDownLoadImage
//
//  Created by jilei on 16/9/23.
//  Copyright © 2016年 冀磊. All rights reserved.
//

#import <Foundation/Foundation.h>
typedef enum {
    MDSFileToolTypeDocument,
    MDSFileToolTypeCache,
    MDSFileToolTypeLibrary,
    MDSFileToolTypeTmp
} MDSFileToolType;


@interface MDSFileTool : NSObject

/**  获取Document路径  */
+ (NSString *)getDocumentPath;
/**  获取Cache路径  */
+ (NSString *)getCachePath;
/**  获取Library路径  */
+ (NSString *)getLibraryPath;
/**  获取Tmp路径  */
+ (NSString *)getTmpPath;
/**  此路径下是否有此文件存在  */
+ (BOOL)fileIsExists:(NSString *)path;

/**
 *  创建目录下文件
 *  一般来说，文件要么放在Document,要么放在Labrary下的Cache里面
 *  这里也是只提供这两种存放路径
 *
 *  @param fileName 文件名
 *  @param type     路径类型
 *  @param context  数据内容
 *
 *  @return 文件路径
 */
+ (NSString *)createFileName:(NSString *)fileName  type:(MDSFileToolType)type context:(NSData *)context;

/**
 *  读取一个文件
 *
 */
+ (NSData *)readDataWithFileName:(NSString *)fileName type:(MDSFileToolType)type;
@end
