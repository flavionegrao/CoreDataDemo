//
//  AppDelegate.h
//  CoreDataDemo
//
//  Created by Flavio Negrão Torres on 19/08/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreData/CoreData.h>

@interface AppDelegate : UIResponder <UIApplicationDelegate>

@property (strong, nonatomic) UIWindow *window;

@property (readonly, strong, nonatomic) NSManagedObjectContext *managedObjectContext;


@end

