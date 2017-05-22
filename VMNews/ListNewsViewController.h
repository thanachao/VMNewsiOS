//
//  ListNewsViewController.h
//  VMNews
//
//  Created by Thanachao Luengwitayakorn on 5/19/17.
//  Copyright © 2017 Thanachao Luengwitayakorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <SVPullToRefresh/SVPullToRefresh.h>

@interface ListNewsViewController : UIViewController <UITableViewDataSource, UITableViewDelegate>
@property (weak, nonatomic) IBOutlet UITableView *tb_news;

@end
