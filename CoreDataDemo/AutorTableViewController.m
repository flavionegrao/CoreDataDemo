//
//  AutorTableViewController.m
//  CoreDataDemo
//
//  Created by Flavio Negrão Torres on 19/08/15.
//  Copyright (c) 2015 Apetis. All rights reserved.
//

#import "AutorTableViewController.h"

#import "LivroTableViewController.h"
#import "AppDelegate.h"
#import "Autor.h"
#import "Livro.h"
#import "Editora.h"

@interface AutorTableViewController ()

@property (nonatomic, strong) NSManagedObjectContext* context;
@property (nonatomic, strong) NSArray* autores;

@end


@implementation AutorTableViewController

#pragma mark - ViewController Lifecycle

- (void) viewDidLoad {
    [super viewDidLoad];
    
    AppDelegate* appDelegate = [UIApplication sharedApplication].delegate;
    self.context = appDelegate.managedObjectContext;
    
    [self loadAutores];
}


#pragma mark - TableviewController Datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return self.autores ? 1 : 0;
}


- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.autores ? self.autores.count : 0;
}


- (UITableViewCell*) tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    Autor* author = self.autores[indexPath.item];
    NSString* const CellId = @"CellId";
    UITableViewCell* cell = [tableView dequeueReusableCellWithIdentifier:CellId];
    cell.textLabel.text = author.nome;
    return cell;
}


#pragma mark - Core Data Methods

- (IBAction)popularButtonDidTouch:(id)sender {
    
    self.navigationItem.rightBarButtonItem.enabled = NO;
    self.title = @"Populando Core Data...";
    
    // Aqui criarmos um contexto fora da main thread para que a UI permaneça funcionando para o usuário.
    NSManagedObjectContext* populateInBackgroundContext = [[NSManagedObjectContext alloc]initWithConcurrencyType:NSPrivateQueueConcurrencyType];
    populateInBackgroundContext.persistentStoreCoordinator = self.context.persistentStoreCoordinator;
    
    NSInteger numberOfAutores = 100000;
    __block NSError* error = nil;
    
    [populateInBackgroundContext performBlock:^{
        
        for (NSInteger i = 1; i <= numberOfAutores; i++) {
            
            // Forçar que os objetos criados sejam "released" a cada iteração
            @autoreleasepool {
                
                // Criar um novo managed object
                Autor* autor = [NSEntityDescription insertNewObjectForEntityForName:@"Autor" inManagedObjectContext:populateInBackgroundContext];
                autor.nome = [NSString stringWithFormat:@"João %@",[NSDate date]];
                
                // Cada autor terá 5 livros
                for (NSInteger j = 0; j <= 4; j++) {
                    Livro* livro = [NSEntityDescription insertNewObjectForEntityForName:@"Livro" inManagedObjectContext:populateInBackgroundContext];
                    
                    // Propriedades
                    livro.titulo = [NSString stringWithFormat:@"Livro do Autor %@",[NSDate date]];
                    livro.isbn = @"ABC123";
                    
                    // Relações
                    livro.autor = autor;
                }
                
                
                // Salvar a cada 50 objetos criados ou no ultimo.
                if (i % 100 == 0 || i == numberOfAutores) {
                    if (![populateInBackgroundContext save:&error]) {
                        break;
                        
                    } else {
                        // Manter a memória sobre controler resetando o context.
                        // Todos os managed objexts serão esquecidos
                        [populateInBackgroundContext reset];
                        NSLog(@"Context has been saved and reset - object count: %ld",(long) i);
                        
                    }
                }
            }
        }
        
        // Feedback para o usuário
        UIAlertController* alertController;
        if (!error) {
            NSString* msg = [NSString stringWithFormat:@"%ld Objetos foram criados",numberOfAutores];
            alertController = [UIAlertController alertControllerWithTitle:@"Sucesso" message:msg preferredStyle:UIAlertControllerStyleAlert];
        } else {
            alertController = [UIAlertController alertControllerWithTitle:@"Error" message:@"Erro salvando Core Data" preferredStyle:UIAlertControllerStyleAlert];
        }
        [alertController addAction:[UIAlertAction actionWithTitle:@"OK" style:UIAlertActionStyleDefault handler:nil]];
        [self presentViewController:alertController animated:YES completion:nil];
        
        dispatch_async(dispatch_get_main_queue(), ^{
            self.navigationItem.rightBarButtonItem.enabled = YES;
            
            // Remover os atuais a carregar tudo de novo
            self.autores = nil;
            [self.context reset];
            [self loadAutores];
        });
    }];
}

// Versão sincrona
- (void) loadAutores {
    
    // Fetch Request para os Autores
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Autor"];
    
    // Traz de 20 em 20 para memória não entupir
    fetchRequest.fetchBatchSize = 20;
    
    // Ordenados por nome
    NSSortDescriptor* sortByName = [NSSortDescriptor sortDescriptorWithKey:@"nome" ascending:NO];
    fetchRequest.sortDescriptors = @[sortByName];
    
    // Execute o request
    NSError* error;
    self.autores = [self.context executeFetchRequest:fetchRequest error:&error];
    
    self.title = [NSString stringWithFormat:@"Autores (%ld)",self.autores.count];
    
    // Recarrege os resultados
    [self.tableView reloadData];
    
}


// Versão assyncrona - não bloqueia a main thread
- (void) loadAuthorAssync {
    NSFetchRequest* fetchRequest = [[NSFetchRequest alloc]initWithEntityName:@"Autor"];
    fetchRequest.fetchBatchSize = 20;
    
    NSSortDescriptor* sortByName = [NSSortDescriptor sortDescriptorWithKey:@"nome" ascending:YES];
    fetchRequest.sortDescriptors = @[sortByName];
    
    __weak  typeof(self) weakSelf = self;
    
    // Initialize Asynchronous Fetch Request
    NSAsynchronousFetchRequest *asynchronousFetchRequest = [[NSAsynchronousFetchRequest alloc] initWithFetchRequest:fetchRequest completionBlock:^(NSAsynchronousFetchResult *result) {
        dispatch_async(dispatch_get_main_queue(), ^{
            
            // Process Asynchronous Fetch Result
            if (result.finalResult) {
                // Update Autores
                weakSelf.autores = result.finalResult;
                
                // Reload Table View
                [weakSelf.tableView reloadData];
            }
            
            // Remove Observer
            [result.progress removeObserver:weakSelf forKeyPath:@"completedUnitCount" context:NULL];
        });
    }];
    
    // Execute Asynchronous Fetch Request
    [self.context performBlock:^{
        
        // Execute Asynchronous Fetch Request
        NSError *asynchronousFetchRequestError = nil;
        [weakSelf.context executeRequest:asynchronousFetchRequest error:&asynchronousFetchRequestError];
        
        if (asynchronousFetchRequestError) {
            NSLog(@"Unable to execute asynchronous fetch result.");
            NSLog(@"%@, %@", asynchronousFetchRequestError, asynchronousFetchRequestError.localizedDescription);
        }
    }];
}


#pragma mark - Navigation

- (void) prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    LivroTableViewController* tvc = segue.destinationViewController;
    
    NSIndexPath* selectedIndexPath = [self.tableView indexPathForSelectedRow];
    Autor* autor = self.autores[selectedIndexPath.item];
    tvc.autor = autor;
    
}


@end
