//
//  LivroTableViewController.m
//  CoreDataDemo
//
//  Created by Flavio Negrão Torres on 19/08/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "LivroTableViewController.h"
#import "Livro.h"
#import "Autor.h"

@interface LivroTableViewController()

@property (nonatomic,strong) NSArray* livros;

@end


@implementation LivroTableViewController

#pragma mark - Getters and Setters

- (void) setAutor:(Autor *)autor {
    _autor = autor;
    if (autor) {
        // Relações no core data são por default NSSets - não ordenandas e com objetos únicos
        // Precisamos transmorma-la em um Array ordenado
        NSSortDescriptor* sortByTitulo = [NSSortDescriptor sortDescriptorWithKey:@"titulo" ascending:YES];
        self.livros = [[self.autor.livros allObjects]sortedArrayUsingDescriptors:@[sortByTitulo]];
    }
}

#pragma mark - TableviewController Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.livros.count;
}

- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Livro* livro = self.livros[indexPath.item];
    NSString* const CellId = @"CellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.textLabel.text = livro.titulo;
    return cell;
}




@end
