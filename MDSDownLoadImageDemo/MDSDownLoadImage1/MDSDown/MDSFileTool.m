//
//  MDSFileTool.m
//  MDSDownLoadImage
//
//  Created by jilei on 16/9/23.
//  Copyright © 2016年 冀磊. All rights reserved.
//

#import "MDSFileTool.h"

@implementation MDSFileTool
+ (NSString *)getRootPath:(MDSFileToolType)type
{
    switch (type) {
        case MDSFileToolTypeDocument:
            return [self getDocumentPath];
            break;
        case MDSFileToolTypeCache:
            return [self getCachePath];
            break;
        case MDSFileToolTypeLibrary:
            return [self getLibraryPath];
            break;
        case MDSFileToolTypeTmp:
            return [self getTmpPath];
            break;
        default:
            break;
    }
    return nil;
}

+ (NSString *)getDocumentPath
{
    return [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) lastObject];
    
}

+ (NSString *)getCachePath
{
    return [NSSearchPathForDirectoriesInDomains(NSCachesDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)getLibraryPath
{
    return [NSSearchPathForDirectoriesInDomains(NSLibraryDirectory, NSUserDomainMask, YES) lastObject];
}

+ (NSString *)getTmpPath
{
    return NSTemporaryDirectory();
}

+ (BOOL)fileIsExists:(NSString *)path
{
    if (path == nil || path.length == 0) {
        return false;
    }
    return [[NSFileManager defaultManager] fileExistsAtPath:path];
}


+ (NSString *)createFileName:(NSString *)fileName  type:(MDSFileToolType)type context:(NSData *)context
{
    if (fileName == nil || fileName.length == 0) {
        return nil;
    }
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *path = [[self getRootPath:type] stringByAppendingPathComponent:fileName];
    if (![self fileIsExists:path])
    {
        //        if (![[NSFileManager defaultManager] removeItemAtPath:path error:nil]) {
        //            return nil;
        //        }
        [[NSFileManager defaultManager] createFileAtPath:path contents:context attributes:nil];
    }
    
    return path;
}

+ (NSData *)readDataWithFileName:(NSString *)fileName type:(MDSFileToolType)type
{
    if (fileName == nil || fileName.length == 0) {
        return nil;
    }
    
    fileName = [fileName stringByReplacingOccurrencesOfString:@"/" withString:@"-"];
    NSString *path = [[self getRootPath:type] stringByAppendingPathComponent:fileName];
    
    if ([self fileIsExists:path])
    {
        return [[NSFileManager defaultManager] contentsAtPath:path];
    }
    return nil;
}

@end
