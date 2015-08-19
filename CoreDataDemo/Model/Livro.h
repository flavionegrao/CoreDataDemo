//
//  Livro.h
//  CoreDataDemo
//
//  Created by Flavio Negrão Torres on 19/08/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Editora, NSManagedObject;

@interface Livro : NSManagedObject

@property (nonatomic, retain) NSString * isbn;
@property (nonatomic, retain) NSString * titulo;
@property (nonatomic, retain) NSManagedObject *autor;
@property (nonatomic, retain) Editora *editora;

@end
