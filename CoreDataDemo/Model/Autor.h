//
//  Autor.h
//  CoreDataDemo
//
//  Created by Flavio Negrão Torres on 19/08/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class Livro;

@interface Autor : NSManagedObject

@property (nonatomic, retain) NSDate * nascimento;
@property (nonatomic, retain) NSString * nome;
@property (nonatomic, retain) NSString * sobrenome;
@property (nonatomic, retain) NSSet *livros;
@end

@interface Autor (CoreDataGeneratedAccessors)

- (void)addLivrosObject:(Livro *)value;
- (void)removeLivrosObject:(Livro *)value;
- (void)addLivros:(NSSet *)values;
- (void)removeLivros:(NSSet *)values;

@end
