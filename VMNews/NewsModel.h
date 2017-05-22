//
//  NewsModel.h
//  VMNews
//
//  Created by Thanachao Luengwitayakorn on 5/20/17.
//  Copyright © 2017 Thanachao Luengwitayakorn. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface NewsModel : JSONModel
@property (nonatomic) NSString <Optional> *author;
@property (nonatomic) NSString *title;
@property (nonatomic) NSString *url;
@property (nonatomic) NSString <Optional> *urlToImage;
@property (nonatomic) NSString <Optional> *publishedAt;
@end
