//
//  VMNewsTests.m
//  VMNewsTests
//
//  Created by Thanachao Luengwitayakorn on 5/20/17.
//  Copyright © 2017 Thanachao Luengwitayakorn. All rights reserved.
//

#import "VMUtils.h"
#import "common.h"
#import <XCTest/XCTest.h>
#import "NewsResponseModel.h"
#import "NewsModel.h"

@interface VMNewsTests : XCTestCase

@end

@implementation VMNewsTests

- (void)setUp {
    [super setUp];
    // Put setup code here. This method is called before the invocation of each test method in the class.
}

- (void)tearDown {
    // Put teardown code here. This method is called after the invocation of each test method in the class.
    [super tearDown];

}

- (void)testConvertToDisplayDate {
    NSString *dateInput = @"2017-05-17T07:55:37Z";
    NSString *actualDateInput = [VMUtils convertToDisplayDate:dateInput] ;
    
    NSString *expectedDateInput = @"2017-05-17 07:55";
    XCTAssertEqualObjects(expectedDateInput, actualDateInput, @"Incorrect date conversion") ;
                          
}

- (void)testConvertNSStringToDate {
    NSDate *expectDate = [VMUtils convertNSStringToDate:@"2017-05-17T07:55:37Z"] ;
    
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    // this is imporant - we set our input date format to match our input string
    // if format doesn't match you'll get nil from your string, so be careful
    [dateFormatter setTimeZone:[NSTimeZone timeZoneWithName:@"UTC"]];
    [dateFormatter setDateFormat:@"yyyy-MM-dd'T'HH:mm:ss'Z'"];
    NSDate *actualDate  = [dateFormatter dateFromString:@"2017-05-17T07:55:37Z"];
    
    XCTAssertEqualObjects(expectDate, actualDate, @"Unable to parse NSString to NSDate") ;
}

- (void)testJsonParser {
     NSString *dataString = @"{\"status\":\"ok\",\"source\":\"techcrunch\",\"sortBy\":\"top\",\"articles\":[{\"author\":\"Jon Evans\",\"title\":\"Google in, Google out\",\"description\":\"Call it the Triumph of the Stacks. I attended Google I/O this week, and saw a lot of cool things: but what really hit home for me, at the keynote and the..\",\"url\":\"https://techcrunch.com/2017/05/21/google-in-google-out/\",\"urlToImage\":\"https://tctechcrunch2011.files.wordpress.com/2017/05/tin-jon.jpg?w=764&h=400&crop=1\",\"publishedAt\":\"2017-05-21T13:00:03Z\"}]}" ;
    
    NSError *error;
    NewsResponseModel *newResponseModel = [[NewsResponseModel alloc] initWithString:dataString error:&error] ;
    if (error == nil) {
        NSMutableArray<NewsModel *> *listNews = newResponseModel.articles ;
        XCTAssertEqualObjects( [listNews objectAtIndex:0].author, @"Jon Evans", @"JsonModel parsing error") ;
        
    } else {
        NSLog(@"JSON: %@", error);
    }

}

@end
