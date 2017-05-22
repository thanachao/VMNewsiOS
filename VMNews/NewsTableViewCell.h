//
//  NewsTableViewCell.h
//  VMNews
//
//  Created by Thanachao Luengwitayakorn on 5/19/17.
//  Copyright © 2017 Thanachao Luengwitayakorn. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface NewsTableViewCell : UITableViewCell
@property (weak, nonatomic) IBOutlet UIView *view_content;
@property (weak, nonatomic) IBOutlet UIImageView *img_news;
@property (weak, nonatomic) IBOutlet UILabel *txt_title;
@property (weak, nonatomic) IBOutlet UILabel *txt_published_at;
@end
