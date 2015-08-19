//
//  Editora.h
//  CoreDataDemo
//
//  Created by Flavio Negrão Torres on 19/08/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class NSManagedObject;

@interface Editora : NSManagedObject

@property (nonatomic, retain) NSString * cnpj;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSSet *livros;
@end

@interface Editora (CoreDataGeneratedAccessors)

- (void)addLivrosObject:(NSManagedObject *)value;
- (void)removeLivrosObject:(NSManagedObject *)value;
- (void)addLivros:(NSSet *)values;
- (void)removeLivros:(NSSet *)values;

@end
