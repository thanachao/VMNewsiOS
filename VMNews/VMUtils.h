//
//  VMUtils.h
//  VMNews
//
//  Created by Thanachao Luengwitayakorn on 5/21/17.
//  Copyright © 2017 Thanachao Luengwitayakorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <Foundation/Foundation.h>

@interface VMUtils : NSObject

+ (NSString *)convertToDisplayDate:(NSString *)dateString ;
+ (NSDate *)convertNSStringToDate:(NSString *)dateString ;
+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth:(float) i_width ;

@end
