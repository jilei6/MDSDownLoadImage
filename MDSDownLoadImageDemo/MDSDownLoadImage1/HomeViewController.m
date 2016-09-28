//
//  HomeViewController.m
//  MDSImageCache
//
//  Created by jilei on 16/9/18.
//  Copyright © 2016年 冀磊. All rights reserved.
//

#import "HomeViewController.h"
//#import "UIImageView+MDSCache.h"
#import "MDSDownLoadImageOperation.h"
#import "MDSFileTool.h"
@interface HomeViewController ()<UITableViewDelegate,UITableViewDataSource,MDSDownLoadImageOperationDelegate, UIScrollViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property(nonatomic,strong) NSArray *imagesArray;
@property (nonatomic, strong) NSOperationQueue *queue;

//  key:图片的url  values: 相对应的operation对象  （判断该operation下载操作是否正在执行，当同一个url地址的图片正在下载，那么不需要再次下载，以免重复下载，当下载操作执行完，需要移除）
@property (nonatomic, strong) NSMutableDictionary *operations;

//  key:图片的url  values: 相对应的图片        （缓存，当下载操作完成，需要将所下载的图片放到缓存中，以免同一个url地址的图片重复下载）
@property (nonatomic, strong) NSMutableDictionary *images;


@end

@implementation HomeViewController
- (NSOperationQueue *)queue
{
    if (_queue == nil)
    {
        _queue = [[NSOperationQueue alloc] init];
        _queue.maxConcurrentOperationCount = 5;
    }
    return _queue;
}
- (NSMutableDictionary *)operations
{
    if (_operations == nil)
    {
        _operations = [NSMutableDictionary dictionary];
    }
    return _operations;
}

- (NSMutableDictionary *)images
{
    if (_images == nil) {
        _images = [NSMutableDictionary dictionary];
    }
    return _images;
}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.tableView.rowHeight=70;
    
    NSString *imagesString=@"http://media.thedoc.cn/img/aa2a0a8e-33f9-41fd-b482-f34baaf86d73.jpg,http://media.thedoc.cn/img/_2015_09_11_8651604a1db54be5b4064323687c4493.jpg,http://media.thedoc.cn/img/6b92773e-8663-4f28-a403-51de4f2485ad.jpg,http://media.thedoc.cn/img/d80d2bbd-d332-45b0-81e0-9a86c6bf6984.JPG,http://media.thedoc.cn/img/ddd1177f-f37f-46c5-9e17-5d7bcaaf734d.jpg,http://media.thedoc.cn/img/23472377-ee1c-45be-a401-2f12db714715.jpg,http://media.thedoc.cn/img/9940ed55-969e-4ee5-bf13-022337794409.jpg,http://media.thedoc.cn/img/32694652-3262-46eb-b610-7e4ff0e2ac09.jpg,http://media.thedoc.cn/img/a8ba7912-642c-401f-95fd-cc48292ee658.JPG,http://media.thedoc.cn/img/5a1cabef-9794-462f-9b1b-d7add51b4f43.jpg,http://media.thedoc.cn/img/48b4c41f-7c9d-4964-9b44-336ed5f88bf5.jpg,http://media.thedoc.cn/img/01d0b979-d10b-4a7c-a279-a5ba696f4db4.jpg,http://media.thedoc.cn/img/1effcccb-118d-41e7-a998-3768e332ae5e.jpg,http://media.thedoc.cn/img/e208cb41-59ee-44dc-9851-afa5b9d1e83c.jpg,http://media.thedoc.cn/img/bce353b5-5abe-430d-9a59-43ab345ee101.JPG,http://media.thedoc.cn/img/07279acd-e087-499a-9d9d-72ae201bba86.jpg,http://media.thedoc.cn/img/04a754ee-8f6c-4e21-9ac6-7147b21ba909.jpg,http://media.thedoc.cn/img/47a0f1c5-26ea-434d-bd74-01b36787e9e4.JPG,http://media.thedoc.cn/img/e1bec4a6-28a6-4f92-86c2-59acfad675cb.JPG,http://media.thedoc.cn/img/00b06bb1-fe4c-4186-ae68-9d2ee9e98c11.jpg,http://media.thedoc.cn/img/1a111956-5d6b-4f1c-879c-f33235837536.jpg,http://media.thedoc.cn/img/a9fbbd3e-88da-4e56-91ea-3de1aa7cda07.jpg,http://media.thedoc.cn/img/dad4506b-1155-477b-88ae-84a2965e7995.jpg,http://media.thedoc.cn/img/91edfaa0-c382-44b5-b6ea-234464ca82b6.JPG,http://media.thedoc.cn/img/46c946e7-e111-4cca-b113-781eccb7af55.JPG,http://media.thedoc.cn/img/57818c29-dc74-4bde-a9d3-0a430a4cec3c.JPG,http://media.thedoc.cn/img/923f8bae-cb37-4023-a868-11ca15ead3bc.jpg,http://media.thedoc.cn/img/aecc24a8-cba4-44c9-9ae3-c00dea1963b8.jpg,http://media.thedoc.cn/img/ccab7a6f-6fd8-438c-80b0-2c0f2bfe9688.JPG,http://media.thedoc.cn/img/6c1202e7-38a2-4988-bcef-b5a999bb2384.jpg,http://media.thedoc.cn/img/25e4dcf7-d2b2-472a-aded-fd690931dfb7.jpg,http://media.thedoc.cn/img/0d77b509-cbf9-4531-bdc7-d50738e9dcaf.jpg";
    
       _imagesArray=[imagesString componentsSeparatedByString:@","];
    // Do any additional setup after loading the view from its nib.
//    ,http://media.thedoc.cn/img/4f481bdb-91b4-4e79-9100-b948bbf299cd.JPG,http://media.thedoc.cn/img/22c9bdc4-cc98-49ce-97c5-633b28ecf900.jpg,http://media.thedoc.cn/img/601ea569-d0e5-4bf2-9335-10ff49872779.jpg,http://media.thedoc.cn/img/5e8845cc-0170-4db3-adee-819e0274948f.jpg,http://media.thedoc.cn/img/074ff15f-a1b6-4165-ac61-0859af160551.jpg,http://media.thedoc.cn/img/b01dc405-02a4-4513-942e-b7dd2525b160.JPG,http://media.thedoc.cn/img/e25160a2-e9fd-4ba7-844a-793ffe515a4f.jpg,http://media.thedoc.cn/img/0e156396-5a00-4f98-a5ed-5bb31161db0e.jpg,http://media.thedoc.cn/img/6ee1357d-3f7a-4f6a-83c8-b5c60d645e3e.JPG,http://media.thedoc.cn/img/b2e8b020-91f0-43ea-a4ee-e19eba025da8.JPG,http://media.thedoc.cn/img/ce9a36c9-ede9-4279-abb4-dcccc1da4976.jpg,http://media.thedoc.cn/img/3095498f-9067-4ace-b4f5-892ab3fcda61.jpg
    
    
    
    
//    http://media.thedoc.cn/img/aa2a0a8e-33f9-41fd-b482-f34baaf86d73.jpg,http://media.thedoc.cn/img/_2015_09_11_8651604a1db54be5b4064323687c4493.jpg,http://media.thedoc.cn/img/6b92773e-8663-4f28-a403-51de4f2485ad.jpg,http://media.thedoc.cn/img/d80d2bbd-d332-45b0-81e0-9a86c6bf6984.JPG,http://media.thedoc.cn/img/ddd1177f-f37f-46c5-9e17-5d7bcaaf734d.jpg,http://media.thedoc.cn/img/23472377-ee1c-45be-a401-2f12db714715.jpg,http://media.thedoc.cn/img/9940ed55-969e-4ee5-bf13-022337794409.jpg,http://media.thedoc.cn/img/32694652-3262-46eb-b610-7e4ff0e2ac09.jpg,http://media.thedoc.cn/img/a8ba7912-642c-401f-95fd-cc48292ee658.JPG,http://media.thedoc.cn/img/5a1cabef-9794-462f-9b1b-d7add51b4f43.jpg,http://media.thedoc.cn/img/48b4c41f-7c9d-4964-9b44-336ed5f88bf5.jpg,http://media.thedoc.cn/img/01d0b979-d10b-4a7c-a279-a5ba696f4db4.jpg,http://media.thedoc.cn/img/1effcccb-118d-41e7-a998-3768e332ae5e.jpg,http://media.thedoc.cn/img/e208cb41-59ee-44dc-9851-afa5b9d1e83c.jpg,http://media.thedoc.cn/img/bce353b5-5abe-430d-9a59-43ab345ee101.JPG,http://media.thedoc.cn/img/07279acd-e087-499a-9d9d-72ae201bba86.jpg,http://media.thedoc.cn/img/04a754ee-8f6c-4e21-9ac6-7147b21ba909.jpg,http://media.thedoc.cn/img/47a0f1c5-26ea-434d-bd74-01b36787e9e4.JPG,http://media.thedoc.cn/img/e1bec4a6-28a6-4f92-86c2-59acfad675cb.JPG,http://media.thedoc.cn/img/00b06bb1-fe4c-4186-ae68-9d2ee9e98c11.jpg,http://media.thedoc.cn/img/1a111956-5d6b-4f1c-879c-f33235837536.jpg,http://media.thedoc.cn/img/a9fbbd3e-88da-4e56-91ea-3de1aa7cda07.jpg,http://media.thedoc.cn/img/dad4506b-1155-477b-88ae-84a2965e7995.jpg,http://media.thedoc.cn/img/91edfaa0-c382-44b5-b6ea-234464ca82b6.JPG,http://media.thedoc.cn/img/46c946e7-e111-4cca-b113-781eccb7af55.JPG,http://media.thedoc.cn/img/57818c29-dc74-4bde-a9d3-0a430a4cec3c.JPG,http://media.thedoc.cn/img/923f8bae-cb37-4023-a868-11ca15ead3bc.jpg,http://media.thedoc.cn/img/aecc24a8-cba4-44c9-9ae3-c00dea1963b8.jpg,http://media.thedoc.cn/img/ccab7a6f-6fd8-438c-80b0-2c0f2bfe9688.JPG,http://media.thedoc.cn/img/6c1202e7-38a2-4988-bcef-b5a999bb2384.jpg,http://media.thedoc.cn/img/25e4dcf7-d2b2-472a-aded-fd690931dfb7.jpg,http://media.thedoc.cn/img/0d77b509-cbf9-4531-bdc7-d50738e9dcaf.jpg
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}
//返回有多少个Sections
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return _imagesArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{

    
    static NSString *CellWithIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellWithIdentifier];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellWithIdentifier];
    }
//
    // Configure the cell.

//    [cell.imageView loadImageWithURL:_imagesArray[indexPath.row] progressBlock:^(NSInteger alreadyReceiveSize, NSInteger expectedContentLength) {
//        
//    } completed:^(NSData *data, UIImage *image, NSError *error, BOOL finished) {
//        
//    }];
    NSString *STR=_imagesArray[indexPath.row];
    UIImage *image = self.images[STR];   //优先从内存缓存中读取图片
    
    if (image)     //如果内存缓存中有
    {
        cell.imageView.image = image;
    }
    //如果内存缓存中没有，那么从本地缓存中读取
    
    NSData *imageData = [MDSFileTool readDataWithFileName:_imagesArray[indexPath.row] type:MDSFileToolTypeCache];
    
    if (imageData&&imageData.length>0)  //如果本地缓存中有图片，则直接读取，更新
    {
        UIImage *image = [UIImage imageWithData:imageData];
        self.images[STR] = image;
        cell.imageView.image = image;
    }
    else
    {
        cell.imageView.image = [UIImage imageNamed:@"TestMam"];
    
        MDSDownLoadImageOperation *operation = self.operations[STR];
        if (operation)
        {  //正在下载（可以在里面取消下载）
        }
        else
        { //没有在下载
            operation = [[MDSDownLoadImageOperation alloc] init];
            operation.delegate = self;
            operation.url = STR;
            operation.indexPath = indexPath;
            [self.queue addOperation:operation];  //异步下载
            
            
            self.operations[STR] = operation;  //加入字典，表示正在执行此次操作
        }
    }



    return cell;

}


- (void)DownLoadImageOperation:(MDSDownLoadImageOperation *)operation didFinishDownLoadImage:(UIImage *)image
{
    [self.operations removeObjectForKey:operation.url];    //下载操作完成，所以把它清掉，表示没有正在下载
    
    if (image){
        self.images[operation.url] = image;    //下载完毕，放入缓存，免得重复下载
        
        [self.tableView reloadRowsAtIndexPaths:@[operation.indexPath] withRowAnimation:UITableViewRowAnimationNone];
    }
    
}

#pragma mark --- UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView  {
    dispatch_queue_t queue = dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_DEFAULT, 0);
    
    dispatch_apply(self.imagesArray.count, queue, ^(size_t i) {
        //ZYApp *appTmp = self.apps[i];
        NSString *urlStr = _imagesArray[i];
        
        MDSDownLoadImageOperation *operation = self.operations[urlStr];
        if (operation)
        {
            operation.queuePriority = NSOperationQueuePriorityNormal;
        }
    });
    
    NSArray *tempArray = [self.tableView indexPathsForVisibleRows];
    
    dispatch_apply(tempArray.count, queue, ^(size_t i) {
        NSIndexPath *indexPath = tempArray[i];
        
     
        NSString *urlStr = self.imagesArray[indexPath.row];
        MDSDownLoadImageOperation *operation = self.operations[urlStr];
        if (operation)
        {
            operation.queuePriority = NSOperationQueuePriorityVeryHigh;
        }
    });
    
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView
{
    self.queue.suspended = YES;
}

- (void)scrollViewWillEndDragging:(UIScrollView *)scrollView withVelocity:(CGPoint)velocity targetContentOffset:(inout CGPoint *)targetContentOffset
{
    self.queue.suspended = NO;
}
/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
 //loadImageWithURL
*/

@end
