//
//  VMUtils.m
//  VMNews
//
//  Created by Thanachao Luengwitayakorn on 5/21/17.
//  Copyright © 2017 Thanachao Luengwitayakorn. All rights reserved.
//

#import "VMUtils.h"

@implementation VMUtils

+ (NSString *)convertToDisplayDate:(NSString *)dateString{
    
    //NSLocale *enUSPOSIXLocale = [[NSLocale alloc] initWithLocaleIdentifier:@"en_US_POSIX"];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *date  = [dateFormatter dateFromString:dateString];

    [dateFormatter setDateFormat:@"yyyy-MM-dd HH:mm"];
    return [dateFormatter stringFromDate:date];
}

+ (NSDate *)convertNSStringToDate:(NSString *)dateString {
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *date  = [dateFormatter dateFromString:dateString];
    return date ;
    
}

+ (UIImage*)imageWithImage:(UIImage*)sourceImage scaledToWidth:(float) i_width
{
    if (sourceImage.size.width <= i_width) {
        return sourceImage ;
        
    } else {
        float oldWidth = sourceImage.size.width;
        float scaleFactor = i_width / oldWidth;
        
        float newHeight = sourceImage.size.height * scaleFactor;
        float newWidth = oldWidth * scaleFactor;
        
        UIGraphicsBeginImageContext(CGSizeMake(newWidth, newHeight));
        [sourceImage drawInRect:CGRectMake(0, 0, newWidth, newHeight)];
        UIImage *newImage = UIGraphicsGetImageFromCurrentImageContext();
        UIGraphicsEndImageContext();
        
        return newImage;
    }
}

@end
