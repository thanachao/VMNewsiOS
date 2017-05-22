//
//  NewsResponseModel.h
//  VMNews
//
//  Created by Thanachao Luengwitayakorn on 5/20/17.
//  Copyright © 2017 Thanachao Luengwitayakorn. All rights reserved.
//

@protocol NewsModel;

#import <JSONModel/JSONModel.h>

@interface NewsResponseModel : JSONModel
@property (nonatomic) NSString *status;
@property (nonatomic) NSString *source;
@property (nonatomic) NSString *sortBy;
@property (nonatomic) NSMutableArray <NewsModel>  *articles;

@end
