//
//  LivroTableViewController.h
//  CoreDataDemo
//
//  Created by Flavio Negrão Torres on 19/08/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <UIKit/UIKit.h>

@class Autor;

@interface LivroTableViewController : UITableViewController

@property (nonatomic, strong) Autor* autor;

@end
