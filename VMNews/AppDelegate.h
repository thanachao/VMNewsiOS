//
//  AppDelegate.h
//  VMNews
//
//  Created by Thanachao Luengwitayakorn on 5/20/17.
//  Copyright © 2017 Thanachao Luengwitayakorn. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong) NSPersistentContainer *persistentContainer;

- (void)saveContext;


@end

