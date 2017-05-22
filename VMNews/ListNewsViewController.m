//
//  ListNewsViewController.m
//  VMNews
//
//  Created by Thanachao Luengwitayakorn on 5/19/17.
//  Copyright © 2017 Thanachao Luengwitayakorn. All rights reserved.
//

#import "ListNewsViewController.h"
#import <AFNetworking/AFNetworking.h>
#import <SDWebImage/UIImageView+WebCache.h>
#import "NewsModel.h"
#import "NewsTableViewCell.h"
#import "NewsResponseModel.h"
#import "common.h"
#import "VMUtils.h"

#define PAGE_LIMIT 4

@interface ListNewsViewController () {
    NSMutableArray<NewsModel *> *listNews, *listNewsCache;
    int mPosition, currentIndex ;
    int screenWidthPixel ;
    BOOL isEndOfRecord, isListRefreshed ;
    NSMutableArray *_objects;
    NSMutableDictionary *heightAtIndexPath;
}

@end

@implementation ListNewsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setupUI] ;
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void) setupUI {
    
    float scaleFactor = [[UIScreen mainScreen] scale];
    CGRect screen = [[UIScreen mainScreen] bounds];
    screenWidthPixel = screen.size.width * scaleFactor;

     heightAtIndexPath = [NSMutableDictionary new];
    _tb_news.rowHeight = UITableViewAutomaticDimension;
    _tb_news.estimatedRowHeight =  300.0;

    //  setup infinite scrolling
    [_tb_news addInfiniteScrollingWithActionHandler:^{
        if (!isEndOfRecord) {
            [self bindNewsToList:NO withRefreshed:NO];
        }

    }];
    
    // setup pull-to-refresh
    [_tb_news addPullToRefreshWithActionHandler:^{
        //[self loadActivity:YES withRefreshed:YES];
        isListRefreshed = YES ;
        [self bindNewsToList:YES withRefreshed:isListRefreshed];
    }];
}

- (void)viewWillAppear:(BOOL)animated {
    [super viewWillAppear:animated];
    
    _tb_news.pullToRefreshView.arrowColor = [UIColor whiteColor] ;
    _tb_news.pullToRefreshView.textColor = [UIColor whiteColor] ;
    [_tb_news.pullToRefreshView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite] ;
    [_tb_news.infiniteScrollingView setActivityIndicatorViewStyle:UIActivityIndicatorViewStyleWhite] ;
    
    [self loadNews] ;
    
}

- (void)loadNews {
    NSDictionary *parameters = @{@"source": @"cnn", @"apiKey": WEBSERVICE_KEY};
    
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    [manager GET:WEBSERVICE_ENDPOINT parameters:parameters progress:nil success:^(NSURLSessionTask *task, id responseObject) {
        NSDictionary *responseDict = responseObject;
        
        NSError *error;
        NewsResponseModel *newResponseModel = [[NewsResponseModel alloc] initWithDictionary:responseDict error:&error] ;
        if (error == nil) {
            listNewsCache = newResponseModel.articles ;
            [self bindNewsToList:YES withRefreshed:NO] ;
        } else {
            NSLog(@"JSON: %@", error);
        }
        
        
    } failure:^(NSURLSessionTask *operation, NSError *error) {
        NSLog(@"Error: %@", error);
        
    }];
}

- (void)bindNewsToList:(BOOL)isReload withRefreshed:(BOOL) isRefreshed {
    
    int64_t delayInSeconds = 0;
    dispatch_time_t popTime = dispatch_time(DISPATCH_TIME_NOW, delayInSeconds * NSEC_PER_SEC);
    dispatch_after(popTime, dispatch_get_main_queue(), ^(void){

            int tempCurrentIndex ;
            if (isReload && !isRefreshed) {
                // TableView Reload
                tempCurrentIndex = currentIndex = 0;
                isEndOfRecord = NO;
                listNews = [[NSMutableArray alloc] init];
                
            } else if (isReload && isRefreshed) {
                // TableView Refresh
                tempCurrentIndex = 0;
            } else {
                // TableView Load More
                tempCurrentIndex = currentIndex;
            }
        
            int size = [listNewsCache count] ;
            int incremental ;
        
            if (tempCurrentIndex + PAGE_LIMIT <= size) {
                incremental = PAGE_LIMIT;
                
            } else {
                incremental = size - tempCurrentIndex;
                
            }
        
            NSMutableArray<NewsModel*> *listTemp = [[listNewsCache subarrayWithRange:NSMakeRange(tempCurrentIndex, incremental)] mutableCopy] ;
        
            if (listTemp != nil) {
                
                if (isListRefreshed) {
                    isListRefreshed = NO;
                    [self setUITableViewStopAnimating:isReload] ;
                    
                    int result = [self compareLatestNews] ;
                    if (result > 0) {
                        isEndOfRecord = NO ;
                        [self loadNews] ;
                    }
                    
                } else {
                    [listNews addObjectsFromArray:listTemp] ;
                    
                    if ([listNews count] < [listNewsCache count]) {
                        isEndOfRecord = NO ;
                        currentIndex = currentIndex + PAGE_LIMIT ;
                        
                    } else {
                        isEndOfRecord = YES ;
                    }
                    
                    [_tb_news reloadData] ;
                    [_tb_news setNeedsLayout];
                    [_tb_news layoutIfNeeded];
                    [_tb_news reloadData];
                    
                   [self setUITableViewStopAnimating:isReload] ;

                }
                
            } else {
                [self setUITableViewStopAnimating:isReload] ;
                        
            }
                   
    });
                
}
                   
- (int) compareLatestNews {
   int result = 0;
   
   if (listNews != nil && [listNewsCache count] != 0) {
          if ([listNews objectAtIndex:0].publishedAt != nil && [listNewsCache objectAtIndex:0].publishedAt ) {
              return [[VMUtils convertNSStringToDate:[listNewsCache objectAtIndex:0].publishedAt] compare:[VMUtils convertNSStringToDate:[listNews objectAtIndex:0].publishedAt]] ;
           }
   }
   
   return result;
}

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = [heightAtIndexPath objectForKey:indexPath];
    
    if(height) {
        return height.floatValue;
        
    } else {
        return UITableViewAutomaticDimension;
        
    }
}

- (void)tableView:(UITableView *)tableView willDisplayCell:(UITableViewCell *)cell forRowAtIndexPath:(NSIndexPath *)indexPath {
    NSNumber *height = @(cell.frame.size.height);
    [heightAtIndexPath setObject:height forKey:indexPath];

}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return [listNews count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    NewsTableViewCell *cell = nil ;
    NewsModel *cellNewsModel = nil ;
    
    static NSString *CellIdentifier = @"NewsTableViewCell";
    
    cellNewsModel = [listNews objectAtIndex:indexPath.row] ;
    
    cell = (NewsTableViewCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier forIndexPath:indexPath];
    
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.view_content.layer.cornerRadius = 5;
    cell.view_content.layer.masksToBounds = true;
    
    if (cellNewsModel.urlToImage != nil){
        
        [cell.img_news sd_setImageWithURL:[NSURL URLWithString:cellNewsModel.urlToImage]
                         placeholderImage:[UIImage imageNamed:@"placeholder.png"] options:SDWebImageRefreshCached
              completed:^(UIImage *image, NSError *error, SDImageCacheType cacheType, NSURL *imageURL) {
                  if (error == nil) {
                      UIImage *modImg = [VMUtils imageWithImage:image scaledToWidth:screenWidthPixel] ;
                      [cell.img_news setImage:modImg] ;

                  } else {
                      NSLog(@"SDWebImage: %@", error);

                  }

              }];
    }
    
    if (cellNewsModel.title != nil){
        cell.txt_title.text = cellNewsModel.title ;
    }
    
    if (cellNewsModel.publishedAt != nil){
        cell.txt_published_at.text = [VMUtils convertToDisplayDate:cellNewsModel.publishedAt] ;
        
    }
    
    return cell;
}

- (void) setUITableViewStopAnimating:(BOOL) reloadType {
    if (reloadType){
        [_tb_news.pullToRefreshView stopAnimating];
    } else {
        [_tb_news.infiniteScrollingView stopAnimating];
    }
}

- (void)flushCache
{
    [SDWebImageManager.sharedManager.imageCache clearMemory];
    [SDWebImageManager.sharedManager.imageCache clearDiskOnCompletion:nil];
}

- (void)viewWillTransitionToSize:(CGSize)size withTransitionCoordinator:(id)coordinator {
    // best call super just in case
    [super viewWillTransitionToSize:size withTransitionCoordinator:coordinator];
    // will execute before rotation
    
    [coordinator animateAlongsideTransition:^(id  _Nonnull context) {
        // will execute during rotation
        
    } completion:^(id  _Nonnull context) {
        // will execute after rotation
        
    }];
}

//#pragma mark - Rotation
//- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)toInterfaceOrientation {
//    return (toInterfaceOrientation != UIInterfaceOrientationPortraitUpsideDown);
//}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
